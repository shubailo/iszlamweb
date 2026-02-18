class CommunityVote {
  final String id;
  final String userId;
  final String postId;
  final int voteValue; // 1 or -1
  final DateTime createdAt;

  const CommunityVote({
    required this.id,
    required this.userId,
    required this.postId,
    required this.voteValue,
    required this.createdAt,
  });

  factory CommunityVote.fromJson(Map<String, dynamic> json) {
    return CommunityVote(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      voteValue: json['vote_value'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'vote_value': voteValue,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
