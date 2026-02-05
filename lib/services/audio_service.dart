import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import '../models/audio_model.dart';

/// Servicio centralizado del reproductor de audio
class AudioService {
  final AudioPlayer _player = AudioPlayer();

  List<AudioModel> playlist = [];
  int currentIndex = 0;

  bool isPlaying = false;
  bool randomMode = false;
  bool infiniteMode = false;
  double speed = 1.0;

  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  AudioService() {
    _player.onPositionChanged.listen((p) {
      currentPosition = p;
    });

    _player.onDurationChanged.listen((d) {
      totalDuration = d;
    });

    _player.onPlayerComplete.listen((_) async {
      if (infiniteMode) {
        await next();
      }
    });
  }

  void setPlaylist(List<AudioModel> list) {
    playlist = list;
  }

  /// Reproduce un elemento de la lista
  Future<void> playIndex(int index) async {
    if (playlist.isEmpty) return;

    currentIndex = index;

    await _player.play(
      AssetSource(playlist[index].assetPath),
    );

    await _player.setPlaybackRate(speed);
    isPlaying = true;
  }

  Future<void> togglePlay() async {
    if (isPlaying) {
      await _player.pause();
      isPlaying = false;
    } else {
      await playIndex(currentIndex);
    }
  }

  /// Siguiente pista
  Future<void> next() async {
    if (playlist.isEmpty) return;

    if (randomMode) {
      currentIndex = Random().nextInt(playlist.length);
    } else {
      currentIndex = (currentIndex + 1) % playlist.length;
    }

    await playIndex(currentIndex);
  }

  /// Pista anterior
  Future<void> previous() async {
    if (playlist.isEmpty) return;

    currentIndex =
        (currentIndex - 1 + playlist.length) % playlist.length;

    await playIndex(currentIndex);
  }

  /// Mover posición
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Avanzar 10 segundos
  Future<void> forward10() async {
    final newPos = currentPosition + const Duration(seconds: 10);
    await seek(newPos);
  }

  /// Retroceder 10 segundos
  Future<void> backward10() async {
    final newPos = currentPosition - const Duration(seconds: 10);
    await seek(newPos < Duration.zero ? Duration.zero : newPos);
  }

  /// Cambiar velocidad
  Future<void> setSpeed(double value) async {
    speed = value;
    await _player.setPlaybackRate(value);
  }

  /// Añadir canción a la lista
  void add(AudioModel model) {
    playlist.add(model);
  }

  /// Eliminar canción de la lista
  void removeAt(int index) {
    if (index < 0 || index >= playlist.length) return;

    if (index == currentIndex && isPlaying) {
      _player.stop();
      isPlaying = false;
    }

    playlist.removeAt(index);

    if (currentIndex >= playlist.length) {
      currentIndex = 0;
    }
  }

  AudioPlayer get player => _player;
}
