import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/services/tts_service.dart';

class FlutterTTSService implements TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  FlutterTTSService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  @override
  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  @override
  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
