import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

void showUserMenu(BuildContext context, String userName, bool isRecent, void Function(String, bool) onDelete) {
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
              leading: const Icon(Icons.push_pin, color: Colors.blueAccent),
              title: const Text("Tepaga qadab qo'yish (Pin)"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil qadab qo'yildi")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orangeAccent),
              title: const Text("Nomini o'zgartirish"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nomini o'zgartirish oynasi")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text("Ro'yxatdan o'chirish"),
              onTap: () {
                Navigator.pop(context);
                onDelete(userName, isRecent);
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
