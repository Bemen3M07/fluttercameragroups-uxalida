import 'dart:io'; // Manejo de archivos
import 'package:flutter/material.dart'; // Widgets Flutter
import 'package:camera/camera.dart'; // API cámara
import '../services/camera_service.dart'; // Servicio cámara
import '../services/image_service.dart'; // Servicio imágenes

class CameraScreen extends StatefulWidget { // Pantalla de cámara
  const CameraScreen({super.key}); // Constructor

  @override
  State<CameraScreen> createState() => _CameraScreenState(); // Estado
}

class _CameraScreenState extends State<CameraScreen> { // Estado de la pantalla
  final CameraService cameraService = CameraService(); // Servicio cámara
  final ImageService imageService = ImageService(); // Servicio imágenes

  List<CameraDescription>? cameras; // Lista de cámaras
  int cameraIndex = 0; // Índice cámara actual
  bool initialized = false; // Indica si está inicializada

  String? lastPhotoPath; // Ruta última foto

  @override
  void initState() { // Al iniciar
    super.initState(); // Llama al padre
    initCamera(); // Inicializa cámara
    loadLastPhoto(); // Carga última foto
  }

  Future<void> loadLastPhoto() async { // Carga última imagen
    final last = await imageService.loadLastImage(); // Obtiene imagen
    if (!mounted) return; // Verifica estado
    setState(() => lastPhotoPath = last?.path); // Actualiza estado
  }

  Future<void> initCamera() async { // Inicializa cámara
    cameras = await availableCameras(); // Obtiene cámaras
    await cameraService.init(cameras![cameraIndex]); // Inicializa controlador
    if (!mounted) return;
    setState(() => initialized = true); // Marca inicializado
  }

  @override
  void dispose() { // Al destruir
    cameraService.dispose(); // Libera cámara
    super.dispose(); // Llama al padre
  }

  Future<void> _showSavedAlert(String path) async { // Muestra alerta
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Foto guardada'), // Título
        content: Text('S’ha emmagatzemat a:\n$path'), // Contenido
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cierra diálogo
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) { // Construye UI
    if (!initialized) {
      return const Center(child: CircularProgressIndicator()); // Loader
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: CameraPreview(cameraService.controller), // Vista cámara
              ),

              if (lastPhotoPath != null) // Si hay foto previa
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white), // Borde
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados
                      image: DecorationImage(
                        image: FileImage(File(lastPhotoPath!)), // Imagen
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        Container( // Menú inferior de cámara
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05), // Color fondo
            border: const Border(
              top: BorderSide(width: 1, color: Colors.black12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espaciado
            children: [
              IconButton(
                tooltip: 'Canviar càmera',
                icon: const Icon(Icons.cameraswitch),
                onPressed: () async {
                  cameraIndex = (cameraIndex + 1) % cameras!.length; // Cambia índice
                  await cameraService.init(cameras![cameraIndex]); // Reinicia cámara
                  if (!mounted) return;
                  setState(() {});
                },
              ),
              IconButton(
                tooltip: 'Fer foto',
                iconSize: 34,
                icon: const Icon(Icons.camera),
                onPressed: () async {
                  final photo = await cameraService.takePhoto(); // Hace foto
                  final path = await imageService.saveImage(photo); // Guarda foto

                  if (!mounted) return;
                  setState(() => lastPhotoPath = path); // Actualiza miniatura

                  await _showSavedAlert(path); // Muestra alerta
                },
              ),
              IconButton(
                tooltip: 'Flash',
                icon: Icon(
                  cameraService.flashEnabled
                      ? Icons.flash_on
                      : Icons.flash_off,
                ),
                onPressed: () async {
                  await cameraService.toggleFlash(); // Cambia flash
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
