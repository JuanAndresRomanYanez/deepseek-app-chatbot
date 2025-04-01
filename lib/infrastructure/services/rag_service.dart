import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:deepseek_app/config/config.dart';

/// Servicio para llamar a TU backend RAG en /query
class RagService {
  /// Envía la pregunta del usuario y obtiene la respuesta y fuentes.
  static Future<Map<String, dynamic>> fetchBotResponse(String userMessage) async {
    final uri = Uri.parse("${Environment.localApiBaseUrl}/query");

    // POST con JSON: {"question": userMessage}
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"question": userMessage}),
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
