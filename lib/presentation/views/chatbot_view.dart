import 'dart:convert';
import 'package:deepseek_app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class ChatbotView extends StatefulWidget {
  const ChatbotView({super.key});

  @override
  ChatbotViewState createState() => ChatbotViewState();
}

class ChatbotViewState extends State<ChatbotView> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();

    // Configuración inicial del TTS
    _flutterTts.setLanguage("es-ES");
    _flutterTts.setSpeechRate(0.5);
  }

  Future<void> sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": userMessage});
      _isLoading = true;
    });

    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer ${Environment.deepSeekKey}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "deepseek/deepseek-r1:free",
          "messages": [{"role": "user", "content": userMessage}],
        }),
      );

      print("📡 Status Code de la API: ${response.statusCode}");
      print("📩 Respuesta de la API: ${response.body}");

      if (response.statusCode == 401) {
        setState(() {
          _messages.add({
            "role": "bot",
            "content": "⚠️ Error: Clave API inválida. Verifica tu configuración."
          });
        });
        return;
      }

      if (response.statusCode != 200) {
        setState(() {
          _messages.add({
            "role": "bot",
            "content": "⚠️ Error en la solicitud: ${response.statusCode}."
          });
        });
        return;
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final botResponse = data["choices"]?[0]?["message"]?["content"] ?? "No se recibió respuesta.";

      setState(() {
        _messages.add({"role": "bot", "content": botResponse});
      });

      // Convierte el texto de la respuesta en voz, sin markdown
      final plainText = _stripMarkdown(botResponse);
      await _flutterTts.speak(plainText);

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

  // Iniciar el reconocimiento de voz
  Future<void> _listen() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print("Speech status: $status"),
      onError: (errorNotification) => print("Speech error: $errorNotification"),
    );
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
          if (result.finalResult) {
            setState(() {
              _isListening = false;
            });
            // Envía automáticamente cuando termina de hablar
            sendMessage();
          }
        },
      );
    } else {
      print("El reconocimiento de voz no está disponible");
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  // Reproduce un mensaje (eliminando sintaxis Markdown)
  void _replayMessage(String message) async {
    final plainText = _stripMarkdown(message);
    await _flutterTts.speak(plainText);
  }

  // Limpia sintaxis Markdown para lectura TTS
  String _stripMarkdown(String input) {
    // Elimina **texto**, __texto__, *texto*, _texto_
    String output = input.replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1');
    output = output.replaceAll(RegExp(r'__(.*?)__'), r'$1');
    output = output.replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
    output = output.replaceAll(RegExp(r'_(.*?)_'), r'$1');

    // Elimina bloques de código y backticks
    output = output.replaceAll(RegExp(r'```(.*?)```', dotAll: true), r'$1');
    output = output.replaceAll(RegExp(r'`(.*?)`'), r'$1');

    // Elimina enlaces [texto](url) dejando solo el texto
    output = output.replaceAllMapped(RegExp(r'\[(.*?)\]\((.*?)\)'), (match) {
      return match.group(1) ?? '';
    });

    return output.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChatBot DeepSeek")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["role"] == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.grey[300] : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: MarkdownBody(
                            data: message["content"]!,
                          ),
                        ),
                        // Espacio entre texto y botón
                        const SizedBox(width: 8),
                        // Botón para reproducir mensaje
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () {
                            _replayMessage(message["content"]!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: () {
                    if (_isListening) {
                      _stopListening();
                    } else {
                      _listen();
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null, // Crece verticalmente
                    decoration: const InputDecoration(
                      hintText: "Escribe o habla tu mensaje...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : sendMessage,
                  child: const Text("Enviar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
