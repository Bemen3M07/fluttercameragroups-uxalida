import 'package:camera/camera.dart'; // Librería para usar la cámara

class CameraService { // Servicio que gestiona la cámara
  late CameraController controller; // Controlador de la cámara
  bool flashEnabled = false; // Estado del flash

  Future<void> init(CameraDescription camera) async { // Inicializa la cámara
    controller = CameraController(camera, ResolutionPreset.medium); // Configura cámara
    await controller.initialize(); // Inicializa el controlador
  }

  Future<XFile> takePhoto() async { // Toma una foto
    return await controller.takePicture(); // Captura la imagen
  }

  Future<void> toggleFlash() async { // Activa o desactiva el flash
    flashEnabled = !flashEnabled; // Cambia el estado
    await controller.setFlashMode( // Aplica el modo de flash
      flashEnabled ? FlashMode.torch : FlashMode.off, // Torch u off
    );
  }

  void dispose() { // Libera recursos
    controller.dispose(); // Cierra el controlador
  }
}
