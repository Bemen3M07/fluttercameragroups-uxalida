import 'dart:io'; // Manejo de archivos
import 'package:camera/camera.dart'; // Tipo XFile
import 'package:path_provider/path_provider.dart'; // Rutas del sistema
import 'package:image_gallery_saver/image_gallery_saver.dart'; // Guardar en galería
import 'package:permission_handler/permission_handler.dart'; // Permisos

class ImageService { // Servicio para gestionar imágenes
  Future<String> saveImage(XFile file) async { // Guarda imagen
    final dir = await getApplicationDocumentsDirectory(); // Directorio interno
    final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg'; // Nombre único
    await file.saveTo(path); // Guarda el archivo
    return path; // Devuelve la ruta
  }

  Future<List<File>> loadImages() async { // Carga imágenes guardadas
    final dir = await getApplicationDocumentsDirectory(); // Directorio interno
    final images = dir
        .listSync() // Lista archivos
        .where((e) => e.path.toLowerCase().endsWith('.jpg')) // Filtra jpg
        .map((e) => File(e.path)) // Convierte a File
        .toList(); // Convierte a lista

    images.sort((a, b) => b.path.compareTo(a.path)); // Ordena por fecha
    return images; // Devuelve lista
  }

  Future<File?> loadLastImage() async { // Carga la última imagen
    final list = await loadImages(); // Obtiene todas
    if (list.isEmpty) return null; // Si no hay, devuelve null
    return list.first; // Devuelve la más reciente
  }

  Future<int> exportToGallery(List<String> filePaths) async { // Exporta imágenes
    if (filePaths.isEmpty) return 0; // Si no hay imágenes

    final photosStatus = await Permission.photos.request(); // Permiso fotos
    final storageStatus = await Permission.storage.request(); // Permiso almacenamiento

    final hasSomePermission =
        photosStatus.isGranted || storageStatus.isGranted; // Verifica permisos

    if (!hasSomePermission &&
        (photosStatus.isDenied || storageStatus.isDenied)) {
      return 0; // Si no hay permisos, cancela
    }

    int ok = 0; // Contador de éxitos
    for (final p in filePaths) { // Recorre las rutas
      final res = await ImageGallerySaver.saveFile(p); // Guarda en galería
      final isSuccess = (res is Map && res['isSuccess'] == true); // Comprueba éxito
      if (isSuccess) ok++; // Incrementa contador
    }
    return ok; // Devuelve cuántas se exportaron
  }
}
