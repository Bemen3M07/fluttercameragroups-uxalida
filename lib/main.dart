import 'package:flutter/material.dart';
import 'ui/camera_screen.dart';
import 'ui/gallery_screen.dart';
import 'ui/audio_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// App principal
/// Se fuerza una proporción de teléfono (9:16) cuando se ejecuta
/// en escritorio o navegador.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'P3 Multimedia',
      home: const AspectRatioWrapper(),
    );
  }
}

/// Envoltorio para forzar proporción de móvil
class AspectRatioWrapper extends StatelessWidget {
  const AspectRatioWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: const HomeScreen(),
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
  int index = 0;

  final screens = const [
    CameraScreen(),
    GalleryScreen(),
    AudioScreen(),
  ];

  final titles = const ['Càmera', 'Imatges', 'Reproductor multimèdia'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index]),
      ),
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), label: 'Càmera'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Imatges'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: 'Reproductor'),
        ],
      ),
    );
  }
}
