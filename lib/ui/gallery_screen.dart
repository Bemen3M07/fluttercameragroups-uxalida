import 'dart:io'; // Manejo de archivos
import 'package:flutter/material.dart'; // Widgets Flutter
import '../services/image_service.dart'; // Servicio imágenes

class GalleryScreen extends StatefulWidget { // Pantalla galería
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImageService imageService = ImageService(); // Servicio imágenes
  List<File> images = []; // Lista de imágenes

  final Set<String> selectedPaths = {}; // Rutas seleccionadas

  @override
  void initState() {
    super.initState();
    loadImages(); // Carga imágenes
  }

  Future<void> loadImages() async {
    images = await imageService.loadImages(); // Obtiene imágenes
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Center(child: Text('No hi ha imatges')); // Sin imágenes
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

                          setState(() => selectedPaths.clear()); // Limpia selección
                        },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: 'Recarregar',
                icon: const Icon(Icons.refresh),
                onPressed: loadImages, // Recarga imágenes
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columnas
            ),
            itemCount: images.length,
            itemBuilder: (_, i) {
              final img = images[i]; // Imagen actual
              final path = img.path; // Ruta
              final isSelected = selectedPaths.contains(path); // Estado selección

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedPaths.remove(path); // Deselecciona
                    } else {
                      selectedPaths.add(path); // Selecciona
                    }
                  });
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(img, fit: BoxFit.cover), // Muestra imagen
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
