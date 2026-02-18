
enum CommunityPostType { text, image, link, poll }

class CommunityPost {
  final String id;
  final String mosqueId;
  final String creatorId;
  final String title;
  final String content;
  final CommunityPostType postType;
  final String? imageUrl;
  final String? linkUrl;
  final String? audioUrl;
  final List<String>? pollOptions;
  final Map<int, int>? pollVotes; // Option index -> Vote count
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
    this.postType = CommunityPostType.text,
    this.imageUrl,
    this.linkUrl,
    this.audioUrl,
    this.pollOptions,
    this.pollVotes,
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
      postType: CommunityPostType.values.firstWhere(
        (e) => e.name == (json['post_type'] ?? 'text'),
        orElse: () => CommunityPostType.text,
      ),
      imageUrl: json['image_url'],
      linkUrl: json['link_url'],
      audioUrl: json['audio_url'],
      pollOptions: json['poll_options'] != null 
          ? List<String>.from(json['poll_options']) 
          : null,
      pollVotes: json['poll_votes'] != null 
          ? (json['poll_votes'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(int.parse(key), value as int),
            )
          : null,
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
      'post_type': postType.name,
      'image_url': imageUrl,
      'link_url': linkUrl,
      'audio_url': audioUrl,
      'poll_options': pollOptions,
      'poll_votes': pollVotes?.map((key, value) => MapEntry(key.toString(), value)),
      'vote_score': voteScore,
      'comment_count': commentCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CommunityPost copyWith({
    String? title,
    String? content,
    CommunityPostType? postType,
    String? imageUrl,
    String? linkUrl,
    String? audioUrl,
    List<String>? pollOptions,
    Map<int, int>? pollVotes,
    int? voteScore,
    int? commentCount,
  }) {
    return CommunityPost(
      id: id,
      mosqueId: mosqueId,
      creatorId: creatorId,
      title: title ?? this.title,
      content: content ?? this.content,
      postType: postType ?? this.postType,
      imageUrl: imageUrl ?? this.imageUrl,
      linkUrl: linkUrl ?? this.linkUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      pollOptions: pollOptions ?? this.pollOptions,
      pollVotes: pollVotes ?? this.pollVotes,
      voteScore: voteScore ?? this.voteScore,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
