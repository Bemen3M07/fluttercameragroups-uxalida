import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import '../models/audio_model.dart';

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

    _player.onPlayerComplete.listen((_) {
      if (infiniteMode) {
        next();
      }
    });
  }

  void setPlaylist(List<AudioModel> list) {
    playlist = list;
  }

  Future<void> playIndex(int index) async {
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

  Future<void> next() async {
    if (randomMode) {
      currentIndex = Random().nextInt(playlist.length);
    } else {
      currentIndex = (currentIndex + 1) % playlist.length;
    }
    await playIndex(currentIndex);
  }

  Future<void> previous() async {
    currentIndex =
        (currentIndex - 1 + playlist.length) % playlist.length;
    await playIndex(currentIndex);
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> forward10() async {
    seek(currentPosition + const Duration(seconds: 10));
  }

  Future<void> backward10() async {
    final newPos = currentPosition - const Duration(seconds: 10);
    await seek(newPos < Duration.zero ? Duration.zero : newPos);
  }

  Future<void> setSpeed(double value) async {
    speed = value;
    await _player.setPlaybackRate(value);
  }

  AudioPlayer get player => _player;
}
