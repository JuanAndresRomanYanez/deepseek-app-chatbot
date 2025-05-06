import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:deepseek_app/config/config.dart';

/// Servicio para llamar a TU backend RAG en /query
class RagService {
  /// Llama a la API de RAG y devuelve la respuesta del bot.
  static Future<Map<String, dynamic>> fetchBotResponse(String userMessage, List<Map<String, String>> history, String summary) async {
    final uri = Uri.parse("${Environment.localApiBaseUrl}/query");
    final body = jsonEncode({
      "question": userMessage,
      "history": history,
      "summary": summary,
    });
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("Error en la solicitud: ${response.statusCode}. Body: ${response.body}");
    }

    // Decodifica la respuesta en un Map
    final data = jsonDecode(utf8.decode(response.bodyBytes));

    // 'data' debería ser algo como: {"answer": "...", "sources": ["..."]}
    return data as Map<String, dynamic>;
  }
}
