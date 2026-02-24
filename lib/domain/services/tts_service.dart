abstract class TTSService {
  /// Berilgan matnni ovozli qilib o'qiydi
  Future<void> speak(String text);

  /// Ovoz chiqarishni to'xtatadi
  Future<void> stop();
}
