import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

void showDmMenu(BuildContext context, String userName, String? avatarUrl) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(margin: const EdgeInsets.only(top: 8, bottom: 8), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2))),
            ListTile(
              leading: CircleAvatar(
                radius: 16,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null ? const Icon(Icons.person, size: 20) : null,
              ),
              title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.push_pin, color: Colors.blueAccent),
              title: const Text("Tepaga qadab qo'yish (Pin)"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chat qadab qo'yildi")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off, color: Colors.orangeAccent),
              title: const Text("Ovozsiz qilish (Mute)"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chat ovozsiz qilindi")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text("Chatni o'chirish"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chat o'chirildi")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Bloklash'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foydalanuvchi bloklandi')));
              },
            ),
          ],
        ),
      );
    },
  );
}
