import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
    final theme = Theme.of(context);
    final bubbleColor = isUser
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.secondaryContainer;
    final textColor = isUser
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSecondaryContainer;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isUser ? 12 : 0),
      bottomRight: Radius.circular(isUser ? 0 : 12),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: radius,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: align,
          children: [
            MarkdownBody(
              data: content,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.play_arrow, color: theme.colorScheme.primary),
                  onPressed: onPlay,
                ),
                IconButton(
                  icon: Icon(Icons.pause, color: theme.colorScheme.primary),
                  onPressed: onPause,
                ),
                IconButton(
                  icon: Icon(Icons.stop, color: theme.colorScheme.primary),
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

