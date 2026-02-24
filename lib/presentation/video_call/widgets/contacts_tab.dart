import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../active_call_screen.dart';

class ContactsTab extends StatefulWidget {
  final List<String> contacts;
  final Set<String> selectedContacts;
  final bool isSelectionMode;
  final void Function(String, bool) toggleSelection;
  final void Function(String, bool) showUserMenu;

  const ContactsTab({
    super.key,
    required this.contacts,
    required this.selectedContacts,
    required this.isSelectionMode,
    required this.toggleSelection,
    required this.showUserMenu,
  });

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredContacts = widget.contacts
        .where((c) => c.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Qidirish...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              // MAXSUS TEST XONASI
              if (_searchQuery.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orangeAccent, Colors.redAccent.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.biotech, color: Colors.orange),
                      ),
                      title: const Text(
                        "TEST ROOM (GLOBAL SESSION)",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      subtitle: const Text(
                        "Ikkala qurilmadan ham shu yerga kiring",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ActiveCallScreen(
                            userName: "TEST ROOM",
                            myLang: "en", // Test uchun standart
                            remoteLang: "ru",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const Divider(height: 1),
              Expanded(
                child: filteredContacts.isEmpty
                    ? const Center(child: Text("Kontaktlar topilmadi"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final userName = filteredContacts[index];
                          final isSelected = widget.selectedContacts.contains(userName);
                          final originalIndex = widget.contacts.indexOf(userName) + 1;

                          return ListTile(
                            selected: isSelected,
                            selectedTileColor: AppColors.primary.withAlpha(50),
                            leading: GestureDetector(
                              onTap: () => widget.isSelectionMode
                                  ? widget.toggleSelection(userName, false)
                                  : widget.showUserMenu(userName, false),
                              child: CircleAvatar(
                                backgroundColor: isSelected ? AppColors.primary : Colors.blueAccent.withAlpha(50),
                                child: isSelected
                                    ? const Icon(Icons.check, color: Colors.white)
                                    : Text('$originalIndex', style: const TextStyle(color: Colors.white)),
                              ),
                            ),
                            title: Text(userName, style: const TextStyle(fontWeight: FontWeight.w500)),
                            trailing: widget.isSelectionMode
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.videocam, color: AppColors.primary),
                                    onPressed: () => Navigator.push(
                                        context, MaterialPageRoute(builder: (_) => ActiveCallScreen(userName: userName))),
                                  ),
                            onLongPress: () => widget.toggleSelection(userName, false),
                            onTap: () => widget.isSelectionMode
                                ? widget.toggleSelection(userName, false)
                                : widget.showUserMenu(userName, false),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
