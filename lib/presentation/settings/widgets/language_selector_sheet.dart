import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

void showLanguageSelector(
  BuildContext context,
  String currentLanguage,
  ValueChanged<String> onLanguageChanged,
  ValueChanged<String> onDownloadRequested,
) {
  final List<Map<String, String>> languages = [
    {"name": "O'zbek tili", "code": "uz"},
    {"name": "Русский", "code": "ru"},
    {"name": "English", "code": "en"},
    {"name": "Deutsch", "code": "de"},
    {"name": "日本語 (Japanese)", "code": "ja"},
    {"name": "中文 (Chinese)", "code": "zh"},
    {"name": "Français", "code": "fr"},
    {"name": "Türkçe", "code": "tr"},
    {"name": "Español", "code": "es"},
    {"name": "한국어 (Korean)", "code": "ko"},
    {"name": "العربية (Arabic)", "code": "ar"},
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tilni tanlang',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final isSelected = lang['name'] == currentLanguage;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? AppColors.primary : AppColors.background,
                      child: Text(
                        lang['code']!.toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      lang['name']!,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                    onTap: () {
                      Navigator.pop(context); // Yopish (Bottom sheet)
                      
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.surface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Til modelini yuklash', style: TextStyle(color: AppColors.textPrimary)),
                          content: Text("\${lang['name']} tili uchun oflayn tarjima modelini yuklab olishni xohlaysizmi?", style: const TextStyle(color: AppColors.textSecondary)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                onLanguageChanged(lang['name']!);
                              },
                              child: const Text("Yo'q", style: TextStyle(color: AppColors.textSecondary)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                              onPressed: () {
                                Navigator.pop(ctx);
                                onLanguageChanged(lang['name']!);
                                onDownloadRequested(lang['name']!);
                              },
                              child: const Text("Xo'p"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
