import 'dart:async';
import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../models/audio_model.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final AudioService audioService = AudioService();

  final List<AudioModel> audios = [
    // recomendado: esta ruta suele ser correcta con AssetSource:
    AudioModel(title: 'Song 1', assetPath: 'audio/song.mp3'),
  ];

  StreamSubscription? _posSub;
  StreamSubscription? _durSub;

  @override
  void initState() {
    super.initState();
    audioService.setPlaylist(audios);

    // refrescar UI mientras suena
    _posSub = audioService.player.onPositionChanged.listen((_) {
      if (mounted) setState(() {});
    });
    _durSub = audioService.player.onDurationChanged.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = audioService.totalDuration.inSeconds.toDouble();
    final pos = audioService.currentPosition.inSeconds.toDouble();
    final safeMax = total <= 0 ? 1.0 : total;
    final safeVal = pos.clamp(0.0, safeMax);

    return Column(
      children: [
        SwitchListTile(
          title: const Text('Random'),
          value: audioService.randomMode,
          onChanged: (v) => setState(() => audioService.randomMode = v),
        ),
        SwitchListTile(
          title: const Text('Infinit'),
          value: audioService.infiniteMode,
          onChanged: (v) => setState(() => audioService.infiniteMode = v),
        ),
        Slider(
          min: 0,
          max: safeMax,
          value: safeVal,
          onChanged: (v) async {
            await audioService.seek(Duration(seconds: v.toInt()));
            if (mounted) setState(() {});
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.replay_10),
              onPressed: () async {
                await audioService.backward10();
                if (mounted) setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: () async {
                await audioService.previous();
                if (mounted) setState(() {});
              },
            ),
            IconButton(
              icon: Icon(
                audioService.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () async {
                await audioService.togglePlay();
                if (mounted) setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () async {
                await audioService.next();
                if (mounted) setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.forward_10),
              onPressed: () async {
                await audioService.forward10();
                if (mounted) setState(() {});
              },
            ),
          ],
        ),
        Slider(
          min: 0.5,
          max: 2.0,
          value: audioService.speed,
          onChanged: (v) async {
            await audioService.setSpeed(v);
            if (mounted) setState(() {});
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: audios.length,
            itemBuilder: (_, i) {
              return ListTile(
                title: Text(audios[i].title),
                onTap: () async {
                  await audioService.playIndex(i);
                  if (mounted) setState(() {});
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
