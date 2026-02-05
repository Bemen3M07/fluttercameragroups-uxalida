import 'dart:math'; // Se usa para generar números aleatorios
import 'package:audioplayers/audioplayers.dart'; // Librería para reproducir audio
import '../models/audio_model.dart'; // Importa el modelo de audio

class AudioService { // Servicio centralizado para gestionar el audio
  final AudioPlayer _player = AudioPlayer(); // Instancia del reproductor de audio

  List<AudioModel> playlist = []; // Lista de canciones
  int currentIndex = 0; // Índice de la canción actual

  bool isPlaying = false; // Indica si se está reproduciendo audio
  bool randomMode = false; // Modo aleatorio
  bool infiniteMode = false; // Modo reproducción infinita
  double speed = 1.0; // Velocidad de reproducción

  Duration currentPosition = Duration.zero; // Posición actual del audio
  Duration totalDuration = Duration.zero; // Duración total del audio

  AudioService() { // Constructor del servicio
    _player.onPositionChanged.listen((p) { // Escucha cambios de posición
      currentPosition = p; // Actualiza la posición actual
    });

    _player.onDurationChanged.listen((d) { // Escucha cambios de duración
      totalDuration = d; // Guarda la duración total
    });

    _player.onPlayerComplete.listen((_) async { // Cuando termina el audio
      if (infiniteMode) { // Si el modo infinito está activado
        await next(); // Reproduce la siguiente canción
      }
    });
  }

  void setPlaylist(List<AudioModel> list) { // Establece la lista de reproducción
    playlist = list; // Asigna la lista recibida
  }

  Future<void> playIndex(int index) async { // Reproduce una canción concreta
    if (playlist.isEmpty) return; // Si no hay canciones, sale

    currentIndex = index; // Actualiza el índice actual

    await _player.play( // Reproduce el audio
      AssetSource(playlist[index].assetPath), // Usa la ruta del asset
    );

    await _player.setPlaybackRate(speed); // Aplica la velocidad actual
    isPlaying = true; // Marca que se está reproduciendo
  }

  Future<void> togglePlay() async { // Alterna play / pause
    if (isPlaying) { // Si está sonando
      await _player.pause(); // Pausa el audio
      isPlaying = false; // Actualiza estado
    } else {
      await playIndex(currentIndex); // Reproduce la canción actual
    }
  }

  Future<void> next() async { // Reproduce la siguiente canción
    if (playlist.isEmpty) return; // Si no hay canciones, sale

    if (randomMode) { // Si está en modo aleatorio
      currentIndex = Random().nextInt(playlist.length); // Índice aleatorio
    } else {
      currentIndex = (currentIndex + 1) % playlist.length; // Siguiente en orden
    }

    await playIndex(currentIndex); // Reproduce la canción seleccionada
  }

  Future<void> previous() async { // Reproduce la canción anterior
    if (playlist.isEmpty) return; // Si no hay canciones, sale

    currentIndex =
        (currentIndex - 1 + playlist.length) % playlist.length; // Índice anterior

    await playIndex(currentIndex); // Reproduce la canción
  }

  Future<void> seek(Duration position) async { // Mueve la posición del audio
    await _player.seek(position); // Cambia la posición
  }

  Future<void> forward10() async { // Avanza 10 segundos
    final newPos = currentPosition + const Duration(seconds: 10); // Nueva posición
    await seek(newPos); // Aplica el cambio
  }

  Future<void> backward10() async { // Retrocede 10 segundos
    final newPos = currentPosition - const Duration(seconds: 10); // Nueva posición
    await seek(newPos < Duration.zero ? Duration.zero : newPos); // Evita negativos
  }

  Future<void> setSpeed(double value) async { // Cambia la velocidad
    speed = value; // Guarda la velocidad
    await _player.setPlaybackRate(value); // Aplica la velocidad
  }

  void add(AudioModel model) { // Añade una canción a la lista
    playlist.add(model); // Agrega el modelo
  }

  void removeAt(int index) { // Elimina una canción por índice
    if (index < 0 || index >= playlist.length) return; // Validación

    if (index == currentIndex && isPlaying) { // Si se elimina la actual
      _player.stop(); // Detiene el audio
      isPlaying = false; // Actualiza estado
    }

    playlist.removeAt(index); // Elimina la canción

    if (currentIndex >= playlist.length) { // Ajusta índice si hace falta
      currentIndex = 0; // Vuelve al inicio
    }
  }

  AudioPlayer get player => _player; // Devuelve el reproductor
}
