import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:deepseek_app/infrastructure/services/services.dart';

class OfflineDetailSheet extends StatefulWidget {
  final String content;
  final String source;
  final num hits;
  final SpeechService speechService;

  const OfflineDetailSheet({
    super.key,
    required this.content,
    required this.source,
    required this.hits,
    required this.speechService,
  });

  @override
  State<OfflineDetailSheet> createState() => _OfflineDetailSheetState();
}

class _OfflineDetailSheetState extends State<OfflineDetailSheet> {
  @override
  void dispose() {
    // Al cerrarse el sheet, detenemos el TTS
    widget.speechService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Contenido completo
          SingleChildScrollView(child: Text(widget.content)),
          const SizedBox(height: 12),

          // Coincidencias y fuente
          Text(
            "Coincidencias: ${widget.hits}  •  Fuente: ${widget.source}",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),

          // Controles de reproducción y compartir
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                tooltip: 'Play',
                onPressed: () => widget.speechService.speak(widget.content),
              ),
              IconButton(
                icon: const Icon(Icons.pause),
                tooltip: 'Pause',
                onPressed: () => widget.speechService.pause(),
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                tooltip: 'Stop',
                onPressed: () => widget.speechService.stop(),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Compartir',
                onPressed: () => SharePlus.instance.share(
                  ShareParams(text: widget.content),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
