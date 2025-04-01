import 'package:flutter/material.dart';

import 'package:deepseek_app/infrastructure/services/services.dart';
import 'package:deepseek_app/presentation/widgets/widgets.dart';

class ChatbotView extends StatefulWidget {
  const ChatbotView({super.key});

  @override
  ChatbotViewState createState() => ChatbotViewState();
}

class ChatbotViewState extends State<ChatbotView> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // Instanciamos nuestro SpeechService
  late SpeechService _speechService;

  @override
  void initState() {
    super.initState();
    _speechService = SpeechService();
  }

  // Envía el mensaje del usuario y obtiene respuesta
  Future<void> sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": userMessage});
      _isLoading = true;
    });
    _controller.clear();

    try {
      // Llamada a la API de deepseek para obtener respuesta
      // final botResponse = await ChatService.fetchBotResponse(userMessage);

      // Llamada a la API del backend RAG
      final data = await RagService.fetchBotResponse(userMessage);
      final botResponse = data["answer"] ?? "No se recibió respuesta.";

      setState(() {
        _messages.add({"role": "bot", "content": botResponse});
      });

      // Reproducir el texto del bot
      _speechService.speak(botResponse);

    } catch (error) {
      setState(() {
        _messages.add({"role": "bot", "content": "Error: $error"});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Inicializa y empieza a escuchar
  Future<void> _listen() async {
    final available = await _speechService.initSpeech();
    if (!available) {
      print("El reconocimiento de voz no está disponible");
      return;
    }
    setState(() {
      _speechService.isListening = true;
    });
    _speechService.startListening((recognizedWords, isFinal) {
      setState(() {
        _controller.text = recognizedWords;
      });
      // Cuando el resultado sea final, enviamos el mensaje automáticamente.
      if (isFinal) {
        sendMessage();
      }
    });
  }


  // Detiene el reconocimiento de voz
  void _stopListening() {
    _speechService.stopListening();
    setState(() {
      _speechService.isListening = false;
    });
  }

  // Manejo de TTS
  void _playTts(String text) => _speechService.speak(text);
  void _pauseTts() => _speechService.pause();
  void _stopTts() => _speechService.stop();

  @override
  Widget build(BuildContext context) {
    final isListening = _speechService.isListening;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("ChatBot DeepSeek"),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["role"] == "user";

                return ChatBubble(
                  isUser: isUser,
                  content: message["content"] ?? '',
                  onPlay: () => _playTts(message["content"] ?? ''),
                  onPause: () => _pauseTts(),
                  onStop: () => _stopTts(),
                );
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(isListening ? Icons.mic : Icons.mic_none),
                  onPressed: () {
                    if (isListening) {
                      _stopListening();
                    } else {
                      _listen();
                    }
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _controller,
                      maxLines: 1,
                      minLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Escribe o habla tu mensaje...",
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: _isLoading ? null : sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
