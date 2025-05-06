
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String localApiBaseUrl = dotenv.env['LOCAL_API_BASE_URL'] ?? "http://10.0.2.2:8000";
  // pon la IP de tu PC (p. ej. 192.168.0.10). el ipv4 de tu pc
}