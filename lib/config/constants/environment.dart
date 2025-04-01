
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String deepSeekKey = dotenv.env['DEEP_SEEK_KEY'] ?? "No key found";

  // Nueva variable para la URL local
  static String localApiBaseUrl = dotenv.env['LOCAL_API_BASE_URL'] ?? "http://10.0.2.2:8000";
  // Nota: 10.0.2.2 es para el emulador de Android si el servidor está en tu misma PC.
  // Si usas un dispositivo físico, pon la IP de tu PC (p. ej. 192.168.0.10). el ipv4 de tu pc

}