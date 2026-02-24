import '../../domain/services/tts_service.dart';

class MockTTSService implements TTSService {
  @override
  Future<void> speak(String text) async {
    // Aslida bu yerda Flutter TTS ishlatiladi.
    // Hozir mock bo'lgani uchun konsolga chiqaramiz.
    print("▶️ [TTS O'QIYAPTI]: \$text");
    await Future.delayed(const Duration(seconds: 2));
    print("⏹️ [TTS TO'XTADI]");
  }

  @override
  Future<void> stop() async {
    print("⏹️ [TTS MAJBURIY TO'XTATILDI]");
  }
}
