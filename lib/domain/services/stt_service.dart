abstract class STTService {
  /// Ovozni eshitishni boshlaydi
  Future<void> startListening();

  /// Ovozni eshitishni to'xtatadi
  Future<void> stopListening();

  /// Ovozni matnga aylantirilgan natijasini kuzatish uchun Stream
  Stream<String> get textStream;

  /// Eshitish jarayoni ketayotganligini bildiradi
  bool get isListening;
}
