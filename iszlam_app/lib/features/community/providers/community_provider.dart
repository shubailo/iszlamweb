
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import '../models/community_post.dart';
import '../models/community_comment.dart';
import '../models/community_vote.dart';
import '../services/community_service.dart';

final communityPostsProvider = FutureProvider.family<List<CommunityPost>, String>((ref, mosqueId) async {
  final service = ref.watch(communityServiceProvider);
  return service.getPosts(mosqueId);
});

final communityCommentsProvider = FutureProvider.family<List<CommunityComment>, String>((ref, postId) async {
  final service = ref.watch(communityServiceProvider);
  return service.getPostComments(postId);
});

final userVoteProvider = FutureProvider.family<CommunityVote?, String>((ref, postId) async {
  final service = ref.watch(communityServiceProvider);
  return service.getUserVote(postId);
});

final postVoteStateProvider = StateProvider.family<int, String>((ref, postId) {
  // Initial vote score from post
  return 0; // Will be set by UI or a more complex provider
});
