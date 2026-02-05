class AudioModel { // Modelo que representa una canción de audio
  final String title; // Título visible de la canción
  final String assetPath; // Ruta del archivo de audio dentro de assets

  AudioModel({ // Constructor del modelo AudioModel
    required this.title, // Obliga a pasar el título
    required this.assetPath, // Obliga a pasar la ruta del archivo
  });
}
