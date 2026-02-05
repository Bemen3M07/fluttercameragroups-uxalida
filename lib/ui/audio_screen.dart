import 'dart:async'; // Para manejar suscripciones a streams
import 'package:flutter/material.dart'; // Widgets de Flutter
import '../services/audio_service.dart'; // Servicio de audio
import '../models/audio_model.dart'; // Modelo de audio

class AudioScreen extends StatefulWidget { // Pantalla de reproductor de audio
  const AudioScreen({super.key}); // Constructor

  @override
  State<AudioScreen> createState() => _AudioScreenState(); // Estado asociado
}

class _AudioScreenState extends State<AudioScreen> { // Estado de la pantalla
  final AudioService audioService = AudioService(); // Servicio central de audio

  late List<AudioModel> playlist; // Lista editable de reproducción

  final List<AudioModel> preloaded = [ // Lista de audios precargados
    AudioModel(title: 'Song 1', assetPath: 'audio/song1.mp3'), // Canción 1
    AudioModel(title: 'Song 2', assetPath: 'audio/song2.mp3'), // Canción 2
  ];

  StreamSubscription? _posSub; // Subscripción a la posición del audio
  StreamSubscription? _durSub; // Subscripción a la duración del audio

  @override
  void initState() { // Método que se ejecuta al iniciar la pantalla
    super.initState(); // Llama al initState padre

    playlist = List.from(preloaded); // Inicializa la playlist
    audioService.setPlaylist(playlist); // Asigna la playlist al servicio

    _posSub = audioService.player.onPositionChanged.listen((_) { // Escucha cambios de posición
      if (mounted) setState(() {}); // Actualiza la UI si está montada
    });

    _durSub = audioService.player.onDurationChanged.listen((_) { // Escucha cambios de duración
      if (mounted) setState(() {}); // Actualiza la UI
    });
  }

  @override
  void dispose() { // Método al destruir la pantalla
    _posSub?.cancel(); // Cancela subscripción de posición
    _durSub?.cancel(); // Cancela subscripción de duración
    super.dispose(); // Llama al dispose padre
  }

  void addDummySong() { // Añade una canción de prueba
    final index = playlist.length + 1; // Calcula índice

    setState(() { // Actualiza estado
      final song = AudioModel( // Crea nuevo modelo
        title: 'Afegida $index', // Título dinámico
        assetPath: preloaded.first.assetPath, // Usa asset existente
      );
      playlist.add(song); // Añade a la lista
      audioService.setPlaylist(playlist); // Actualiza servicio
    });
  }

  @override
  Widget build(BuildContext context) { // Construye la UI
    final total = audioService.totalDuration.inSeconds.toDouble(); // Duración total
    final pos = audioService.currentPosition.inSeconds.toDouble(); // Posición actual
    final safeMax = total <= 0 ? 1.0 : total; // Evita valores inválidos
    final safeVal = pos.clamp(0.0, safeMax); // Limita el valor del slider

    return Column( // Layout vertical
      children: [
        SwitchListTile( // Switch modo random
          title: const Text('Random'), // Texto
          value: audioService.randomMode, // Valor actual
          onChanged: (v) => setState(() => audioService.randomMode = v), // Cambia estado
        ),

        SwitchListTile( // Switch modo infinito
          title: const Text('Mode infinit'), // Texto
          value: audioService.infiniteMode, // Valor actual
          onChanged: (v) => setState(() => audioService.infiniteMode = v), // Cambia estado
        ),

        Slider( // Barra de progreso
          min: 0, // Valor mínimo
          max: safeMax, // Valor máximo
          value: safeVal, // Valor actual
          onChanged: (v) async { // Al mover slider
            await audioService.seek(Duration(seconds: v.toInt())); // Mueve audio
            if (mounted) setState(() {}); // Refresca UI
          },
        ),

        Row( // Controles de reproducción
          mainAxisAlignment: MainAxisAlignment.center, // Centrado
          children: [
            IconButton( // Retroceder 10s
              icon: const Icon(Icons.replay_10),
              onPressed: () async {
                await audioService.backward10(); // Retrocede
                if (mounted) setState(() {});
              },
            ),
            IconButton( // Anterior
              icon: const Icon(Icons.skip_previous),
              onPressed: () async {
                await audioService.previous(); // Canción anterior
                if (mounted) setState(() {});
              },
            ),
            IconButton( // Play / Pause
              icon: Icon(
                audioService.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () async {
                await audioService.togglePlay(); // Alterna reproducción
                if (mounted) setState(() {});
              },
            ),
            IconButton( // Siguiente
              icon: const Icon(Icons.skip_next),
              onPressed: () async {
                await audioService.next(); // Canción siguiente
                if (mounted) setState(() {});
              },
            ),
            IconButton( // Avanzar 10s
              icon: const Icon(Icons.forward_10),
              onPressed: () async {
                await audioService.forward10(); // Avanza
                if (mounted) setState(() {});
              },
            ),
          ],
        ),

        Padding( // Control de velocidad
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Text('Velocitat'), // Texto
              Expanded(
                child: Slider(
                  min: 0.5, // Velocidad mínima
                  max: 2.0, // Velocidad máxima
                  divisions: 6, // Divisiones
                  value: audioService.speed, // Valor actual
                  label: '${audioService.speed.toStringAsFixed(2)}x', // Etiqueta
                  onChanged: (v) async {
                    await audioService.setSpeed(v); // Cambia velocidad
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),

        Padding( // Botón añadir canción
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ElevatedButton.icon(
            onPressed: addDummySong, // Acción
            icon: const Icon(Icons.add), // Icono
            label: const Text('Afegir cançó a la llista'), // Texto
          ),
        ),

        const SizedBox(height: 8), // Espacio

        Expanded( // Lista de canciones
          child: ListView.builder(
            itemCount: playlist.length, // Número de elementos
            itemBuilder: (_, i) {
              return ListTile(
                title: Text(playlist[i].title), // Título
                leading: Icon(
                  i == audioService.currentIndex
                      ? Icons.play_arrow
                      : Icons.music_note,
                ),
                onTap: () async {
                  await audioService.playIndex(i); // Reproduce canción
                  if (mounted) setState(() {});
                },
                trailing: IconButton(
                  tooltip: 'Eliminar', // Tooltip
                  icon: const Icon(Icons.delete), // Icono borrar
                  onPressed: () {
                    setState(() {
                      audioService.removeAt(i); // Elimina canción
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
