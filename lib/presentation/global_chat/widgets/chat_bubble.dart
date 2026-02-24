import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../../service_locator.dart';

class ChatBubble extends StatelessWidget {
  final String originalText;
  final String translatedText;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.originalText,
    required this.translatedText,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(originalText, style: const TextStyle(color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(
              translatedText,
              style: const TextStyle(color: Colors.orangeAccent, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.volume_up, size: 20, color: Colors.white70),
                onPressed: () => tts.speak(translatedText),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
