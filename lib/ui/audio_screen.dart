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

  /// Lista real editable de reproducción
  late List<AudioModel> playlist;

  /// Lista de mp3 precarregados (assets)
  final List<AudioModel> preloaded = [
    AudioModel(title: 'Song 1', assetPath: 'audio/song1.mp3'),
    AudioModel(title: 'Song 2', assetPath: 'audio/song2.mp3'),
  ];

  StreamSubscription? _posSub;
  StreamSubscription? _durSub;

  @override
  void initState() {
    super.initState();

    /// Inicialmente la playlist es la lista de mp3 precarregados
    playlist = List.from(preloaded);
    audioService.setPlaylist(playlist);

    /// Refrescar UI mientras suena
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

  void addDummySong() {
    final index = playlist.length + 1;

    setState(() {
      final song = AudioModel(
        title: 'Afegida $index',
        assetPath: preloaded.first.assetPath,
      );
      playlist.add(song);
      audioService.setPlaylist(playlist);
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = audioService.totalDuration.inSeconds.toDouble();
    final pos = audioService.currentPosition.inSeconds.toDouble();
    final safeMax = total <= 0 ? 1.0 : total;
    final safeVal = pos.clamp(0.0, safeMax);

    return Column(
      children: [
        /// MODOS
        SwitchListTile(
          title: const Text('Random'),
          value: audioService.randomMode,
          onChanged: (v) => setState(() => audioService.randomMode = v),
        ),

        SwitchListTile(
          title: const Text('Mode infinit'),
          value: audioService.infiniteMode,
          onChanged: (v) => setState(() => audioService.infiniteMode = v),
        ),

        /// Barra de progreso
        Slider(
          min: 0,
          max: safeMax,
          value: safeVal,
          onChanged: (v) async {
            await audioService.seek(Duration(seconds: v.toInt()));
            if (mounted) setState(() {});
          },
        ),

        /// Controles
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
                audioService.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
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

        /// Velocidad
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Text('Velocitat'),
              Expanded(
                child: Slider(
                  min: 0.5,
                  max: 2.0,
                  divisions: 6,
                  value: audioService.speed,
                  label: '${audioService.speed.toStringAsFixed(2)}x',
                  onChanged: (v) async {
                    await audioService.setSpeed(v);
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),

        /// Botón para añadir canciones (requisito añadir)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ElevatedButton.icon(
            onPressed: addDummySong,
            icon: const Icon(Icons.add),
            label: const Text('Afegir cançó a la llista'),
          ),
        ),

        const SizedBox(height: 8),

        /// Lista scrollable
        Expanded(
          child: ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (_, i) {
              return ListTile(
                title: Text(playlist[i].title),
                leading: Icon(
                  i == audioService.currentIndex
                      ? Icons.play_arrow
                      : Icons.music_note,
                ),
                onTap: () async {
                  await audioService.playIndex(i);
                  if (mounted) setState(() {});
                },
                trailing: IconButton(
                  tooltip: 'Eliminar',
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      audioService.removeAt(i);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
