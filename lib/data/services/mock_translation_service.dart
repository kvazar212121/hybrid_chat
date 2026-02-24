import '../../domain/services/translation_service.dart';

class MockTranslationService implements TranslationService {
  @override
  Future<String> translate(String text, String targetLang, {String fromLang = "en"}) async {
    // Tarjima jarayonini simulyatsiya qilish uchun kutiladi
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock mantiq: Agar matnda 'Salom' bo'lsa 'Hello' ga o'zgaradi va hokazo
    if (text.toLowerCase().contains("salom")) {
      return "Hello, how can I help you?";
    } else if (text.toLowerCase().contains("ob-havo")) {
      return "The weather is very good today.";
    } else if (text.toLowerCase().contains("flutter")) {
      return "Flutter is a great framework.";
    }

    return "[Translated to \$targetLang]: \$text";
  }
}
