import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

/// Estados de TTS para referencia.
enum TtsState { playing, paused, stopped }

/// Servicio que maneja Speech-to-Text (STT) y Text-to-Speech (TTS).
class SpeechService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool isListening = false;
  TtsState ttsState = TtsState.stopped;

  SpeechService() {
    _initTts();
  }

  void _initTts() {
    _flutterTts.setLanguage("es-ES");
    _flutterTts.setSpeechRate(0.5);

    _flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });
    _flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
    });
    _flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stopped;
      // print("TTS Error: $msg");
    });
  }

  /// Inicia STT y retorna `true` si está disponible.
  Future<bool> initSpeech() async {
    bool available = await _speechToText.initialize();
    isListening = false;
    return available;
  }

  /// Empieza a escuchar y notifica cada vez que reconoce palabras.
  /// Cuando finaliza el reconocimiento, se `isListening = false`.
  void startListening(Function(String recognizedWords, bool isFinal) onResult) {
    isListening = true;
    _speechToText.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
        if (result.finalResult) {
          isListening = false;
        }
      },
    );
  }

  /// Detiene STT
  void stopListening() {
    _speechToText.stop();
    isListening = false;
  }

  /// Reproduce el texto con TTS
  Future<void> speak(String text) async {
    // Elimina los dobles asteriscos que se usan en Markdown para negritas
    final sanitizedText = text.replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (match) {
      return match.group(1) ?? '';
    });
    await _flutterTts.speak(sanitizedText);
  }


  /// Pausa TTS (no siempre soportado)
  Future<void> pause() async {
    var result = await _flutterTts.pause();
    if (result == 1) {
      ttsState = TtsState.paused;
    } else {
      // print("Pause no soportado en esta plataforma.");
    }
  }

  /// Detiene TTS
  Future<void> stop() async {
    await _flutterTts.stop();
    ttsState = TtsState.stopped;
  }
}
