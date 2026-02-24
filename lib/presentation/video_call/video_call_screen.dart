import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'widgets/recent_calls_tab.dart';
import 'widgets/contacts_tab.dart';
import 'widgets/user_action_menu.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  // Mock data lists
  List<String> recentCalls = List.generate(5, (index) => 'User ${index + 1}');
  List<String> contacts = List.generate(15, (index) => 'Kontakt ${index + 1}');

  // Selection states
  Set<String> selectedRecent = {};
  Set<String> selectedContacts = {};
  bool isSelectionMode = false;

  void _toggleSelection(String item, bool isRecent) {
    setState(() {
      final selectedSet = isRecent ? selectedRecent : selectedContacts;
      if (selectedSet.contains(item)) {
        selectedSet.remove(item);
      } else {
        selectedSet.add(item);
      }

      if (selectedRecent.isEmpty && selectedContacts.isEmpty) {
        isSelectionMode = false;
      } else {
        isSelectionMode = true;
      }
    });
  }

  void _deleteSelected() {
    setState(() {
      recentCalls.removeWhere((item) => selectedRecent.contains(item));
      contacts.removeWhere((item) => selectedContacts.contains(item));
      selectedRecent.clear();
      selectedContacts.clear();
      isSelectionMode = false;
    });
  }

  void _handleUserMenu(String userName, bool isRecent) {
    showUserMenu(context, userName, isRecent, (name, recent) {
      setState(() {
        if (recent) {
          recentCalls.remove(name);
        } else {
          contacts.remove(name);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: isSelectionMode
              ? Text('${selectedRecent.length + selectedContacts.length} ta tanlandi')
              : const Text("Qo'ng'iroqlar"),
          actions: [
            if (isSelectionMode)
              IconButton(
                icon: const Icon(Icons.delete, color: AppColors.error),
                onPressed: _deleteSelected,
              ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Oxirgi'),
              Tab(text: 'Kontaktlar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RecentCallsTab(
              recentCalls: recentCalls,
              selectedRecent: selectedRecent,
              isSelectionMode: isSelectionMode,
              toggleSelection: _toggleSelection,
              showUserMenu: _handleUserMenu,
            ),
            ContactsTab(
              contacts: contacts,
              selectedContacts: selectedContacts,
              isSelectionMode: isSelectionMode,
              toggleSelection: _toggleSelection,
              showUserMenu: _handleUserMenu,
            ),
          ],
        ),
      ),
    );
  }
}
