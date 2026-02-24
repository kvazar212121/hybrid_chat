import 'dart:async';
import 'dart:math';
import '../../domain/services/stt_service.dart';

class MockSTTService implements STTService {
  final _controller = StreamController<String>.broadcast();
  bool _isListening = false;
  Timer? _timer;

  final List<String> _mockPhrases = [
    "Salom, qanday yordam bera olaman?",
    "Bugun ob-havo juda yaxshi.",
    "Ushbu xabar mock STT orqali kelmoqda.",
    "Flutter - ajoyib freymvork.",
    "Dasturlash - bu kelajak kasbi.",
  ];

  @override
  bool get isListening => _isListening;

  @override
  Stream<String> get textStream => _controller.stream;

  @override
  Future<void> startListening() async {
    if (_isListening) return;
    _isListening = true;
    
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isListening) {
        timer.cancel();
        return;
      }
      final randomPhrase = _mockPhrases[Random().nextInt(_mockPhrases.length)];
      _controller.add(randomPhrase);
    });
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
    _timer?.cancel();
  }
}
