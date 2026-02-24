import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'widgets/channel_action_menu.dart';

class ChannelItem {
  final String name;
  final String lastMessage;
  final IconData icon;
  final Color color;

  ChannelItem({
    required this.name,
    required this.lastMessage,
    required this.icon,
    required this.color,
  });
}

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  // Mock data for channels
  final List<ChannelItem> _allChannels = [
    ChannelItem(
      name: 'Flutter Daily',
      lastMessage: "Yangi Flutter yangilanishi e'lon qilindi!",
      icon: Icons.flutter_dash,
      color: Colors.blueAccent,
    ),
    ChannelItem(
      name: 'IT Yangiliklar',
      lastMessage: "Sun'iy intellekt sohasi tez o'smoqda...",
      icon: Icons.newspaper,
      color: Colors.deepOrangeAccent,
    ),
    ChannelItem(
      name: 'Kino & Seriallar',
      lastMessage: 'Bugun oqshom tarmoqda yangi film premyerasi!',
      icon: Icons.movie,
      color: Colors.purpleAccent,
    ),
    ChannelItem(
      name: 'Musiqa Olami',
      lastMessage: "Hafta xit taronalari ro'yxati e'lon qilindi",
      icon: Icons.music_note,
      color: Colors.pinkAccent,
    ),
    ChannelItem(
      name: 'Dasturchilar Kulgisi',
      lastMessage: 'Kod ishlamayapti, nega bilmayman. Endi ishlayapti, yana nega bilmayman.',
      icon: Icons.emoji_emotions,
      color: Colors.amber,
    ),
    ChannelItem(
      name: "Sog'lom Hayot",
      lastMessage: 'Ertalab yugurish qoidalari va tavsiyalar',
      icon: Icons.directions_run,
      color: Colors.greenAccent,
    ),
    ChannelItem(
      name: 'Toshkent Hayoti',
      lastMessage: 'Shaharda bugun ob-havo qanday?',
      icon: Icons.location_city,
      color: AppColors.primary,
    ),
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filter channels based on search query
    final filteredChannels = _allChannels
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanallar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Kanal izlash...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredChannels.isEmpty
                ? const Center(child: Text("Kanal topilmadi"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: filteredChannels.length,
                    itemBuilder: (context, index) {
                      final channel = filteredChannels[index];

                      return ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            showChannelMenu(context, channel.name);
                          },
                          child: CircleAvatar(
                            backgroundColor: channel.color.withAlpha(50),
                            child: Icon(channel.icon, color: channel.color),
                          ),
                        ),
                        title: Text(channel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          channel.lastMessage,
                          style: const TextStyle(color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_active, color: AppColors.textSecondary, size: 16),
                        ),
                        onTap: () {
                          // TODO: Open Channel Details/Chat Mock Action
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("\${channel.name} kanaliga kirildi (Mock)")),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
