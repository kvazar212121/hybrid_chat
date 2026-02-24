import 'package:flutter/material.dart';

class TranslationOverlay extends StatelessWidget {
  final String originalText;
  final String translatedText;

  const TranslationOverlay({
    super.key,
    required this.originalText,
    required this.translatedText,
  });

  @override
  Widget build(BuildContext context) {
    if (originalText.isEmpty) return const SizedBox.shrink();

    return Positioned(
      bottom: 120,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(178), // 0.7 * 255
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(originalText,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(translatedText,
                style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
