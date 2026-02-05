import 'package:flutter/material.dart'; // Flutter
import 'ui/camera_screen.dart'; // Pantalla cámara
import 'ui/gallery_screen.dart'; // Pantalla galería
import 'ui/audio_screen.dart'; // Pantalla audio

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa bindings
  runApp(const MyApp()); // Lanza app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita banner debug
      title: 'P3 Multimedia', // Título
      home: const AspectRatioWrapper(), // Pantalla inicial
    );
  }
}

class AspectRatioWrapper extends StatelessWidget {
  const AspectRatioWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12, // Fondo
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16, // Proporción móvil
          child: const HomeScreen(), // Pantalla principal
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0; // Índice pantalla actual

  final screens = const [
    CameraScreen(), // Pantalla cámara
    GalleryScreen(), // Pantalla galería
    AudioScreen(), // Pantalla audio
  ];

  final titles = const [
    'Càmera',
    'Imatges',
    'Reproductor multimèdia'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index]), // Título dinámico
      ),
      body: screens[index], // Pantalla activa
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index, // Índice actual
        onTap: (value) => setState(() => index = value), // Cambia pantalla
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), label: 'Càmera'),
          BottomNavigationBarItem(
              icon: Icon(Icons.image), label: 'Imatges'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: 'Reproductor'),
        ],
      ),
    );
  }
}
