import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'widgets/dm_action_menu.dart';
import 'direct_message_room_screen.dart';

class DmItem {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;

  DmItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    required this.unreadCount,
  });
}

class DirectMessagesScreen extends StatefulWidget {
  const DirectMessagesScreen({super.key});

  @override
  State<DirectMessagesScreen> createState() => _DirectMessagesScreenState();
}

class _DirectMessagesScreenState extends State<DirectMessagesScreen> {
  String _searchQuery = "";

  final List<DmItem> _allDms = [
    DmItem(name: "Otabek", lastMessage: "Qachon ko'rishamiz?", time: "14:30", avatarUrl: "https://i.pravatar.cc/100?img=11", unreadCount: 2),
    DmItem(name: "Jasur", lastMessage: "Aka kod ishlayaptimi?", time: "12:15", avatarUrl: "https://i.pravatar.cc/100?img=12", unreadCount: 0),
    DmItem(name: "Aziza", lastMessage: "Vazifani jo'natib yubordim", time: "Kecha", avatarUrl: "https://i.pravatar.cc/100?img=5", unreadCount: 1),
    DmItem(name: "Dilshod", lastMessage: "Yangi app juda zo'r bo'pti gaping yo'q!", time: "Kecha", avatarUrl: "https://i.pravatar.cc/100?img=14", unreadCount: 0),
    DmItem(name: "Malika", lastMessage: "Zoom link tashlab yuboring...", time: "Dushanba", avatarUrl: "https://i.pravatar.cc/100?img=9", unreadCount: 0),
    DmItem(name: "Sardor", lastMessage: "Flutter zo'rmi yoki React Native?", time: "10 Mart", avatarUrl: "https://i.pravatar.cc/100?img=15", unreadCount: 5),
    DmItem(name: "Botir", lastMessage: "Uchrashuv bekor qilindi", time: "05 Mart", avatarUrl: "https://i.pravatar.cc/100?img=33", unreadCount: 0),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _allDms.where((dm) => dm.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Shaxsiy xabarlar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Xabarlarni qidirish...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty ? const Center(child: Text("Xabar topilmadi")) : _buildDmList(filtered),
          ),
        ],
      ),
    );
  }

  Widget _buildDmList(List<DmItem> filtered) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final dm = filtered[index];
        return ListTile(
          leading: GestureDetector(
            onTap: () => showDmMenu(context, dm.name, dm.avatarUrl),
            child: CircleAvatar(radius: 26, backgroundImage: NetworkImage(dm.avatarUrl)),
          ),
          title: Text(dm.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(dm.lastMessage, style: const TextStyle(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(dm.time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 4),
              if (dm.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: Text('${dm.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DirectMessageRoomScreen(
                  userName: dm.name,
                  avatarUrl: dm.avatarUrl,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
