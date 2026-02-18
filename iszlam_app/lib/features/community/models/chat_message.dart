class ChatMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      groupId: json['group_id'],
      senderId: json['sender_id'],
      senderName: json['sender_name'] ?? 'Névtelen',
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'sender_id': senderId,
      'sender_name': senderName,
      'content': content,
    };
  }
}
