class CommunityPost {
  final String id;
  final String mosqueId;
  final String creatorId;
  final String title;
  final String content;
  final String? imageUrl;
  final String? audioUrl;
  final int voteScore;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommunityPost({
    required this.id,
    required this.mosqueId,
    required this.creatorId,
    required this.title,
    required this.content,
    this.imageUrl,
    this.audioUrl,
    this.voteScore = 0,
    this.commentCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'],
      mosqueId: json['mosque_id'],
      creatorId: json['creator_id'] ?? '',
      title: json['title'],
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      audioUrl: json['audio_url'],
      voteScore: json['vote_score'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mosque_id': mosqueId,
      'creator_id': creatorId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'vote_score': voteScore,
      'comment_count': commentCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CommunityPost copyWith({
    String? title,
    String? content,
    String? imageUrl,
    String? audioUrl,
    int? voteScore,
    int? commentCount,
  }) {
    return CommunityPost(
      id: id,
      mosqueId: mosqueId,
      creatorId: creatorId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      voteScore: voteScore ?? this.voteScore,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
