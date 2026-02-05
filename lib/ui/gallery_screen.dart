import 'dart:io';
import 'package:flutter/material.dart';
import '../services/image_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImageService imageService = ImageService();
  List<File> images = [];

  // Selección robusta: por path (File no compara bien)
  final Set<String> selectedPaths = {};

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    images = await imageService.loadImages();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Center(child: Text('No hi ha imatges'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload),
                  label: Text('Exportar (${selectedPaths.length})'),
                  onPressed: selectedPaths.isEmpty
                      ? null
                      : () async {
                          final ok = await imageService
                              .exportToGallery(selectedPaths.toList());

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                ok == 0
                                    ? 'No s’han pogut exportar (permís o error)'
                                    : 'Exportades $ok imatges a la galeria',
                              ),
                            ),
                          );

                          // opcional: limpiar selección
                          setState(() => selectedPaths.clear());
                        },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: 'Recarregar',
                icon: const Icon(Icons.refresh),
                onPressed: loadImages,
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: images.length,
            itemBuilder: (_, i) {
              final img = images[i];
              final path = img.path;
              final isSelected = selectedPaths.contains(path);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedPaths.remove(path);
                    } else {
                      selectedPaths.add(path);
                    }
                  });
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(img, fit: BoxFit.cover),
                    if (isSelected)
                      const Positioned(
                        right: 6,
                        top: 6,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
