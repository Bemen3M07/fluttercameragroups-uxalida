import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  Future<String> saveImage(XFile file) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await file.saveTo(path);
    return path;
  }

  Future<List<File>> loadImages() async {
    final dir = await getApplicationDocumentsDirectory();
    final images = dir
        .listSync()
        .where((e) => e.path.toLowerCase().endsWith('.jpg'))
        .map((e) => File(e.path))
        .toList();

    // ordenar por más reciente (por nombre timestamp)
    images.sort((a, b) => b.path.compareTo(a.path));
    return images;
  }

  Future<File?> loadLastImage() async {
    final list = await loadImages();
    if (list.isEmpty) return null;
    return list.first;
  }

  /// Exporta a la galería del dispositivo (real).
  /// Devuelve cuántas se exportaron correctamente.
  Future<int> exportToGallery(List<String> filePaths) async {
    if (filePaths.isEmpty) return 0;

    // Permisos: en Android antiguos hace falta. En Android 10+ suele ir sin.
    // Usamos una petición segura; si no aplica, no pasa nada.
    final photosStatus = await Permission.photos.request();
    final storageStatus = await Permission.storage.request();

    final hasSomePermission =
        photosStatus.isGranted || storageStatus.isGranted;

    // Si el sistema no requiere permisos, igual funcionará.
    // Si requiere y no concede, no podemos exportar.
    if (!hasSomePermission && (photosStatus.isDenied || storageStatus.isDenied)) {
      return 0;
    }

    int ok = 0;
    for (final p in filePaths) {
      final res = await ImageGallerySaver.saveFile(p);
      // res suele contener {"isSuccess": true/false, ...}
      final isSuccess = (res is Map && res['isSuccess'] == true);
      if (isSuccess) ok++;
    }
    return ok;
  }
}

