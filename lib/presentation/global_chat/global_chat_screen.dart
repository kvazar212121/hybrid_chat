import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'global_chat_room_screen.dart';

class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({super.key});

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  // Mock data for global chat groups
  List<String> chatGroups = [
    'Flutter Uzbekistan',
    'Python Developers',
    'Global English Practice',
    'AI & Machine Learning',
    'Startup Community',
    'Designers Hub',
    'Mobile Devs Global',
    'Gaming Lounge',
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filter groups based on search query
    final filteredGroups = chatGroups
        .where((g) => g.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Guruhlar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Guruh qidirish...',
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
            child: filteredGroups.isEmpty
                ? const Center(child: Text("Guruh topilmadi"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      final groupName = filteredGroups[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withAlpha(50),
                          child: const Icon(Icons.group, color: AppColors.primary),
                        ),
                        title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text("So'nggi xabar mock...", style: TextStyle(color: AppColors.textSecondary)),
                        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GlobalChatRoomScreen(groupName: groupName),
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
  }
}
