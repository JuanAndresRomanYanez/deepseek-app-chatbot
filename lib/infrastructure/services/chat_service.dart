import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:deepseek_app/config/config.dart';

/// Servicio para llamar a la API de OpenRouter y obtener respuesta del bot.
class ChatService {
  static Future<String> fetchBotResponse(String userMessage) async {
    final response = await http.post(
      Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer ${Environment.deepSeekKey}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "deepseek/deepseek-r1:free",
        "messages": [
          {"role": "user", "content": userMessage}
        ],
      }),
    );

    if (response.statusCode == 401) {
      throw Exception("⚠️ Error: Clave API inválida. Verifica tu configuración.");
    } else if (response.statusCode != 200) {
      throw Exception("⚠️ Error en la solicitud: ${response.statusCode}.");
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final botResponse = data["choices"]?[0]?["message"]?["content"] ?? "No se recibió respuesta.";
    return botResponse;
  }
}
