import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/services/translation_service.dart';

class ApiTranslationService implements TranslationService {
  final String baseUrl;

  ApiTranslationService({this.baseUrl = "http://localhost:8000"});

  @override
  Future<String> translate(String text, String targetLang, {String fromLang = "en"}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/translate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "text": text,
          "from_lang": fromLang,
          "to_lang": targetLang,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["translated"] ?? text;
      } else {
        return "Xato: ${response.statusCode}";
      }
    } catch (e) {
      return "Tarjima xatosi: $e";
    }
  }
}
