import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';
import '../services/image_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraService cameraService = CameraService();
  final ImageService imageService = ImageService();

  List<CameraDescription>? cameras;
  int cameraIndex = 0;
  bool initialized = false;

  String? lastPhotoPath;

  @override
  void initState() {
    super.initState();
    initCamera();
    loadLastPhoto();
  }

  Future<void> loadLastPhoto() async {
    final last = await imageService.loadLastImage();
    if (!mounted) return;
    setState(() => lastPhotoPath = last?.path);
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    await cameraService.init(cameras![cameraIndex]);
    if (!mounted) return;
    setState(() => initialized = true);
  }

  @override
  void dispose() {
    cameraService.dispose();
    super.dispose();
  }

  Future<void> _showSavedAlert(String path) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Foto guardada'),
        content: Text('S’ha emmagatzemat a:\n$path'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(child: CameraPreview(cameraService.controller)),

              // Miniatura de la última foto (requisito)
              if (lastPhotoPath != null)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(File(lastPhotoPath!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // “menú diferenciado” para controles (visualmente separado)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            border: const Border(top: BorderSide(width: 1, color: Colors.black12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                tooltip: 'Canviar càmera',
                icon: const Icon(Icons.cameraswitch),
                onPressed: () async {
                  cameraIndex = (cameraIndex + 1) % cameras!.length;
                  await cameraService.init(cameras![cameraIndex]);
                  if (!mounted) return;
                  setState(() {});
                },
              ),
              IconButton(
                tooltip: 'Fer foto',
                iconSize: 34,
                icon: const Icon(Icons.camera),
                onPressed: () async {
                  final photo = await cameraService.takePhoto();
                  final path = await imageService.saveImage(photo);

                  if (!mounted) return;
                  setState(() => lastPhotoPath = path);

                  // ALERT con la ruta (requisito)
                  await _showSavedAlert(path);
                },
              ),
              IconButton(
                tooltip: 'Flash',
                icon: Icon(
                  cameraService.flashEnabled ? Icons.flash_on : Icons.flash_off,
                ),
                onPressed: () async {
                  await cameraService.toggleFlash();
                  if (!mounted) return;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
