import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';
import 'widgets/language_selector_sheet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _offlineMode = true;
  bool _isDownloading = false;
  bool _notifications = true;
  String _selectedLanguage = "O'zbek tili";

  void _downloadModel([String? langName]) async {
    setState(() => _isDownloading = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isDownloading = false);
    if (mounted) {
      final msg = langName != null
          ? "\$langName tili uchun offline model yuklab olindi!"
          : "Offline STT/TTS Modeli (200MB) yuklab olindi!";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sozlamalar'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          const ProfileHeader(
            name: "Shoxrux",
            username: "shoxrux_dev",
            avatarUrl: "https://i.pravatar.cc/150",
          ),
          const SizedBox(height: 8),

          SettingsSection(
            title: "Hisob (Asosiy)",
            children: [
              SettingsTile(icon: Icons.phone, title: "+998 90 123 45 67", subtitle: "Telefon raqamini o'zgartirish", iconColor: Colors.blueAccent),
              SettingsTile(icon: Icons.alternate_email, title: "@shoxrux_dev", subtitle: "Foydalanuvchi nomi", iconColor: Colors.deepPurpleAccent),
              SettingsTile(icon: Icons.info_outline, title: "Flutter Developer | HybridChat", subtitle: "Tarjimai hol (Bio)", iconColor: Colors.greenAccent),
            ],
          ),

          SettingsSection(
            title: "Tarjima & Offline rejim",
            children: [
              SwitchListTile(
                title: const Text('Offline rejim', style: TextStyle(color: AppColors.textPrimary)),
                subtitle: const Text('Majburiy offline tarjima (STT/TTS)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.orange.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.wifi_off, color: Colors.orange, size: 20),
                ),
                activeColor: AppColors.primary,
                value: _offlineMode,
                onChanged: (val) => setState(() => _offlineMode = val),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.pinkAccent.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.download, color: Colors.pinkAccent, size: 20),
                ),
                title: const Text('Til modellarini yuklash', style: TextStyle(color: AppColors.textPrimary)),
                subtitle: const Text('Hajmi: ~200MB (Ona tili uchun)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                trailing: _isDownloading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        onPressed: _downloadModel,
                        child: const Text('Yuklash', style: TextStyle(fontSize: 12)),
                      ),
              ),
            ],
          ),

          SettingsSection(
            title: "Tashqi ko'rinish & Platforma",
            children: [
              SwitchListTile(
                title: const Text('Bildirishnomalar (Notifications)', style: TextStyle(color: AppColors.textPrimary)),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.redAccent.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.notifications_active, color: Colors.redAccent, size: 20),
                ),
                activeColor: AppColors.primary,
                value: _notifications,
                onChanged: (val) => setState(() => _notifications = val),
              ),
              SettingsTile(icon: Icons.color_lens, title: "Mavzu (Theme)", subtitle: "Qorong'u (Dark) yoqilgan", iconColor: Colors.indigoAccent),
              SettingsTile(
                icon: Icons.language,
                title: "Mening tilim",
                subtitle: _selectedLanguage,
                iconColor: Colors.teal,
                onTap: () {
                  showLanguageSelector(context, _selectedLanguage, (val) {
                    setState(() {
                      _selectedLanguage = val;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ilova tili \$val ga o'zgartirildi!")));
                  }, (langName) {
                    _downloadModel(langName);
                  });
                },
              ),
              SettingsTile(icon: Icons.lock, title: "Maxfiylik va Xavfsizlik", iconColor: Colors.blueGrey),
              SettingsTile(icon: Icons.storage, title: "Ma'lumotlar va Xotira", iconColor: Colors.cyan),
            ],
          ),

          SettingsSection(
            title: "Yordam",
            children: [
              SettingsTile(icon: Icons.help_outline, title: "Savol-Javoblar (FAQ)", iconColor: Colors.amber),
              SettingsTile(icon: Icons.share, title: "Ilovani ulashish", iconColor: Colors.lightGreen),
              ListTile(
                title: const Center(
                  child: Text('Tizimdan chiqish', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chiqish bajarilmoqda...')));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text("HybridChat v1.0.0 (Beta)", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
