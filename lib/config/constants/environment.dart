
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String deepSeekKey = dotenv.env['DEEP_SEEK_KEY'] ?? "No key found";

}