import 'package:flutter/material.dart';

import 'package:deepseek_app/infrastructure/services/services.dart';
import 'package:deepseek_app/presentation/widgets/widgets.dart';

class ChatbotView extends StatefulWidget {
  const ChatbotView({super.key});

  @override
  State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String _summary = "";
  int? _playingIndex;

  late final SpeechService _speechService;

  @override
  void initState() {
    super.initState();
    _speechService = SpeechService();
  }

  @override
  void dispose() {
    _speechService.stop();
    _controller.dispose();
    super.dispose();
  }

  Future<void> sendMessage([String? text]) async {
    final user = (text ?? _controller.text).trim();
    if (user.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": user});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final data = await RagService.fetchBotResponse(user, _messages, _summary);
      final bot = data["answer"] ?? "No se recibió respuesta.";

      setState(() {
        _messages.add({"role": "assistant", "content": bot});
        _summary = data["summary"] ?? _summary;
      });

      // Si estamos reproduciendo otra, detenla
      if (_playingIndex != null) {
        _speechService.stop();
        _playingIndex = null;
      }
      await _speechService.speak(bot);
    } catch (e) {
      setState(() {
        _messages.add({"role": "assistant", "content": "Error: $e"});
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleMic() async {
    if (_speechService.isListening) {
      _speechService.stopListening();
      setState(() {});
    } else {
      final ok = await _speechService.initSpeech();
      if (!ok) return;
      setState(() {});
      _speechService.startListening((words, isFinal) {
        setState(() => _controller.text = words);
        if (isFinal) {
          _speechService.stopListening();
          sendMessage(words);
        }
      });
    }
  }

  Future<void> _playBubble(int idx, String content) async {
    // si ya hay otra en play, la detenemos
    if (_playingIndex != null && _playingIndex != idx) {
      _speechService.stop();
    }
    _playingIndex = idx;
    await _speechService.speak(content);
  }

  void _pauseBubble(int idx) {
    if (_playingIndex == idx) {
      _speechService.pause();
    }
  }

  void _stopBubble(int idx) {
    if (_playingIndex == idx) {
      _speechService.stop();
      setState(() => _playingIndex = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChatBot")),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              messages: _messages,
              isLoading: _isLoading,
              playingIndex: _playingIndex,
              onPlay: _playBubble,
              onPause: _pauseBubble,
              onStop: _stopBubble,
            ),
          ),

          // Input Bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: ChatInputBar(
              controller: _controller,
              isListening: _speechService.isListening,
              onMicToggle: _toggleMic,
              onSend: (txt) => sendMessage(txt),
            ),
          ),
        ],
      ),
    );
  }
}
