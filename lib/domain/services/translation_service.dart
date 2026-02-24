abstract class TranslationService {
  /// Berilgan matnni [targetLang] tiliga tarjima qiladi
  Future<String> translate(String text, String targetLang, {String fromLang = "en"});
}
