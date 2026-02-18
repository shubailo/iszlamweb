class CommunityComment {
  final String id;
  final String postId;
  final String userId;
  final String? parentId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CommunityComment> children;

  const CommunityComment({
    required this.id,
    required this.postId,
    required this.userId,
    this.parentId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.children = const [],
  });

  factory CommunityComment.fromJson(Map<String, dynamic> json) {
    return CommunityComment(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      parentId: json['parent_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      children: [], // Populated manually during tree construction
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'parent_id': parentId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CommunityComment copyWith({
    String? content,
    List<CommunityComment>? children,
  }) {
    return CommunityComment(
      id: id,
      postId: postId,
      userId: userId,
      parentId: parentId,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      children: children ?? this.children,
    );
  }
}
