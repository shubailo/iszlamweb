import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../../../core/services/encryption_service.dart';

final chatServiceProvider = Provider((ref) => ChatService(ref));

class ChatService {
  final Ref _ref;
  final SupabaseClient _supabase = Supabase.instance.client;

  ChatService(this._ref);

  Stream<List<ChatMessage>> getMessages(String groupId, String? roomKey) {
    return _supabase
        .from('community_messages')
        .stream(primaryKey: ['id'])
        .eq('group_id', groupId)
        .order('created_at')
        .map((data) {
          final encryption = _ref.read(encryptionServiceProvider);
          return data.map((json) {
            final msg = ChatMessage.fromJson(json);
            if (roomKey != null && roomKey.isNotEmpty) {
              try {
                final decrypted = encryption.decrypt(msg.content, roomKey);
                return ChatMessage(
                  id: msg.id,
                  groupId: msg.groupId,
                  senderId: msg.senderId,
                  senderName: msg.senderName,
                  content: decrypted,
                  createdAt: msg.createdAt,
                );
              } catch (e) {
                return msg; // Fallback to raw if decryption fails
              }
            }
            return msg;
          }).toList();
        });
  }

  Future<void> sendMessage(String groupId, String content, String? roomKey) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final encryption = _ref.read(encryptionServiceProvider);
    String finalContent = content;

    if (roomKey != null && roomKey.isNotEmpty) {
      finalContent = encryption.encrypt(content, roomKey);
    }

    await _supabase.from('community_messages').insert({
      'group_id': groupId,
      'sender_id': user.id,
      'sender_name': user.userMetadata?['full_name'] ?? 'Tag',
      'content': finalContent,
    });
  }
}
