import 'package:flutter/material.dart';

typedef SendCallback = Future<void> Function(String text);
typedef MicCallback = Future<void> Function();

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isListening;
  final SendCallback onSend;
  final MicCallback onMicToggle;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isListening,
    required this.onSend,
    required this.onMicToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: true,
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Material(
          elevation: 4,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: Scrollbar(
                      child: TextField(
                        controller: controller,
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Escribe tu mensaje…',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ),

                // Icono dinámico: mic o send
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    final hasText = value.text.trim().isNotEmpty;
                    return IconButton(
                      icon: Icon(
                        hasText
                          ? Icons.send
                          : (isListening ? Icons.mic : Icons.mic_none),
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        if (hasText) {
                          onSend(controller.text.trim());
                        } else {
                          onMicToggle();
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}