import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mosque_group.dart';
import '../services/chat_service.dart';
import '../models/chat_message.dart';
import '../../../core/theme/garden_palette.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupChatScreen extends ConsumerStatefulWidget {
  final MosqueGroup group;
  final String? roomKey;

  const GroupChatScreen({super.key, required this.group, this.roomKey});

  @override
  ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends ConsumerState<GroupChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    ref.read(chatServiceProvider).sendMessage(
      widget.group.id,
      text,
      widget.roomKey,
    );
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesStream = ref.watch(chatServiceProvider).getMessages(widget.group.id, widget.roomKey);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.group.name, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            if (widget.roomKey != null && widget.roomKey!.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.lock, size: 10, color: Colors.green[700]),
                  const SizedBox(width: 4),
                  Text(
                    'End-to-end encrypted', 
                    style: TextStyle(fontSize: 10, color: Colors.green[700], fontWeight: FontWeight.w500)
                  ),
                ],
              ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: GardenPalette.nearBlack,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('Nincsenek üzenetek', style: TextStyle(color: Colors.grey[400])),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  reverse: true, // Latest at bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    final isMe = msg.senderId == Supabase.instance.client.auth.currentUser?.id;
                    return _ChatBubble(message: msg, isMe: isMe);
                  },
                );
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Üzenet írása...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: GardenPalette.leafyGreen,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                message.senderName,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[600]),
              ),
            ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? GardenPalette.leafyGreen : Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
              ),
              boxShadow: [
                if (isMe) 
                  BoxShadow(
                    color: GardenPalette.leafyGreen.withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Text(
              message.content,
              style: GoogleFonts.outfit(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
