import 'package:camera/camera.dart';

class CameraService {
  late CameraController controller;
  bool flashEnabled = false;

  Future<void> init(CameraDescription camera) async {
    controller = CameraController(camera, ResolutionPreset.medium);
    await controller.initialize();
  }

  Future<XFile> takePhoto() async {
    return await controller.takePicture();
  }

  Future<void> toggleFlash() async {
    flashEnabled = !flashEnabled;
    await controller.setFlashMode(
      flashEnabled ? FlashMode.torch : FlashMode.off,
    );
  }

  void dispose() {
    controller.dispose();
  }
}
