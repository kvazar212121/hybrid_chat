import 'data/services/api_translation_service.dart';
import 'data/services/vosk_model_manager.dart';
import 'data/services/flutter_tts_service.dart';
import 'data/services/mock_stt_service.dart';
import 'data/services/vosk_stt_service.dart';
import 'domain/services/stt_service.dart';
import 'domain/services/tts_service.dart';
import 'domain/services/translation_service.dart';

// SSH orqali ulanib turgan serverning ichki IP manzili
const String kServerHost = "192.168.100.132";
const String kServerHttpUrl = "http://$kServerHost:8000";
const String kServerWsUrl = "ws://$kServerHost:8000";

class ServiceLocator {
  static final STTService sttService = MockSTTService(); // Default mock
  static final VoskSTTService realSttService = VoskSTTService();
  static final TTSService ttsService = FlutterTTSService();
  static final TranslationService translationService =
      ApiTranslationService(baseUrl: kServerHttpUrl);
  static final VoskModelManager voskModelManager = VoskModelManager();
}

STTService get stt => ServiceLocator.sttService;
VoskSTTService get realStt => ServiceLocator.realSttService;
TTSService get tts => ServiceLocator.ttsService;
TranslationService get translation => ServiceLocator.translationService;
VoskModelManager get voskManager => ServiceLocator.voskModelManager;
