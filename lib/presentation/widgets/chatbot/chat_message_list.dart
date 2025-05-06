import 'package:flutter/material.dart';
import 'chat_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final List<Map<String, String>> messages;
  final bool isLoading;
  final int? playingIndex;
  final void Function(int index, String text) onPlay;
  final void Function(int index) onPause;
  final void Function(int index) onStop;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.playingIndex,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isUser = msg['role'] == 'user';
            final content = msg['content'] ?? '';
            return ChatBubble(
              isUser: isUser,
              content: content,
              onPlay: () => onPlay(index, content),
              onPause: () => onPause(index),
              onStop: () => onStop(index),
            );
          },
        ),
        if (isLoading)
          const Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
