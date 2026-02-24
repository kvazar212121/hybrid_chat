import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

void showChannelMenu(BuildContext context, String channelName) {
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
              leading: const Icon(Icons.open_in_new, color: Colors.blueAccent),
              title: const Text('Kanalni ochish'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("\$channelName kanaliga kirildi")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.push_pin, color: Colors.greenAccent),
              title: const Text("Tepaga qadab qo'yish (Pin)"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kanal qadab qo'yildi")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off, color: Colors.orangeAccent),
              title: const Text("Ovozsiz qilish (Mute)"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kanal ovozsiz qilindi")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
              title: const Text('Kanaldan chiqish'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kanaldan chiqildi')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: const Text('Shikoyat qilish (Report)'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shikoyat yuborildi')));
              },
            ),
          ],
        ),
      );
    },
  );
}
