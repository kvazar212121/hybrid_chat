import 'dart:async';
import 'dart:convert';
import 'package:vosk_flutter/vosk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/services/stt_service.dart';

class VoskSTTService implements STTService {
  final VoskFlutterPlugin _vosk = VoskFlutterPlugin.instance();
  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;

  final _textController = StreamController<String>.broadcast();
  bool _isListening = false;

  /// Vosk modelini yuklash (modelPath - telefon ichidagi papka yo'li)
  Future<void> initModel(String modelPath) async {
    _model = await _vosk.createModel(modelPath);
    _recognizer = await _vosk.createRecognizer(
      model: _model!,
      sampleRate: 16000,
    );
  }

  @override
  bool get isListening => _isListening;

  @override
  Stream<String> get textStream => _textController.stream;

  @override
  Future<void> startListening() async {
    if (_isListening) return;
    if (_recognizer == null) {
      throw Exception("Vosk modeli yuklanmagan! Avval initModel() chaqiring.");
    }

    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) return;

    _isListening = true;
    _speechService = await _vosk.initSpeechService(_recognizer!);

    _speechService!.onResult().listen((resultJson) {
      final data = jsonDecode(resultJson);
      final text = (data['text'] ?? '').toString().trim();
      if (text.isNotEmpty) {
        _textController.add(text);
      }
    });

    await _speechService!.start();
  }

  @override
  Future<void> stopListening() async {
    if (!_isListening) return;
    _isListening = false;
    await _speechService?.stop();
    _speechService?.dispose();
    _speechService = null;
  }

  Future<void> dispose() async {
    await stopListening();
    _recognizer?.dispose();
    _model?.dispose();
    await _textController.close();
  }
}
