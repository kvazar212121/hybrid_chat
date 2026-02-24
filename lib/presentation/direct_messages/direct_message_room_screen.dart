import 'package:flutter/material.dart';
import '../../../service_locator.dart';
import '../global_chat/widgets/chat_bubble.dart';

class DirectMessageRoomScreen extends StatefulWidget {
  final String userName;
  final String avatarUrl;

  const DirectMessageRoomScreen({
    super.key,
    required this.userName,
    required this.avatarUrl,
  });

  @override
  State<DirectMessageRoomScreen> createState() => _DirectMessageRoomScreenState();
}

class ChatMessage {
  final String original;
  final String translated;
  final bool isMe;
  ChatMessage(this.original, this.translated, this.isMe);
}

class _DirectMessageRoomScreenState extends State<DirectMessageRoomScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textCtrl = TextEditingController();

  void _sendMessage() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    _textCtrl.clear();

    final mockMsg = ChatMessage(text, "Translating...", true);
    setState(() => _messages.insert(0, mockMsg));

    final trans = await translator.translate(text, 'en');
    setState(() {
      _messages[0] = ChatMessage(text, trans, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.avatarUrl),
            ),
            const SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                return ChatBubble(
                  originalText: m.original,
                  translatedText: m.translated,
                  isMe: m.isMe,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Theme.of(context).cardColor,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textCtrl,
                decoration: const InputDecoration(
                  hintText: 'Xabar yozing...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blueAccent),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
