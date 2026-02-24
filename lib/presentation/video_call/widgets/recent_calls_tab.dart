import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../active_call_screen.dart';

class RecentCallsTab extends StatelessWidget {
  final List<String> recentCalls;
  final Set<String> selectedRecent;
  final bool isSelectionMode;
  final void Function(String, bool) toggleSelection;
  final void Function(String, bool) showUserMenu;

  const RecentCallsTab({
    super.key,
    required this.recentCalls,
    required this.selectedRecent,
    required this.isSelectionMode,
    required this.toggleSelection,
    required this.showUserMenu,
  });

  @override
  Widget build(BuildContext context) {
    if (recentCalls.isEmpty) {
      return const Center(child: Text("Oxirgi qo'ng'iroqlar yo'q"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: recentCalls.length,
      itemBuilder: (context, index) {
        final userName = recentCalls[index];
        final isSelected = selectedRecent.contains(userName);

        return ListTile(
          selected: isSelected,
          selectedTileColor: AppColors.primary.withAlpha(50),
          leading: GestureDetector(
            onTap: () => isSelectionMode ? toggleSelection(userName, true) : showUserMenu(userName, true),
            child: CircleAvatar(
              backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white)
                  : const Icon(Icons.person, color: AppColors.textPrimary),
            ),
          ),
          title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Bugun, 14:30', style: TextStyle(color: AppColors.textSecondary)),
          trailing: isSelectionMode
              ? null
              : IconButton(
                  icon: const Icon(Icons.videocam, color: AppColors.success),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ActiveCallScreen(userName: userName))),
                ),
          onLongPress: () => toggleSelection(userName, true),
          onTap: () => isSelectionMode ? toggleSelection(userName, true) : showUserMenu(userName, true),
        );
      },
    );
  }
}
