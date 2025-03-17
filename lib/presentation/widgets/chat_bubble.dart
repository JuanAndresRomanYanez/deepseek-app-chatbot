import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Widget sencillo para mostrar un mensaje tipo burbuja.
/// Recibe el rol (user/bot), el contenido y callbacks para TTS.
class ChatBubble extends StatelessWidget {
  final bool isUser;
  final String content;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;

  const ChatBubble({
    super.key,
    required this.isUser,
    required this.content,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isUser ? Colors.blue[100] : Colors.white;
    final bubbleAlign = isUser ? Alignment.centerRight : Alignment.centerLeft;

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isUser ? 12 : 0),
      bottomRight: Radius.circular(isUser ? 0 : 12),
    );

    return Align(
      alignment: bubbleAlign,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: borderRadius,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Texto en Markdown
            MarkdownBody(
              data: content,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            // Filita de botones: Play, Pause, Stop
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: onPlay,
                ),
                IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: onPause,
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: onStop,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
