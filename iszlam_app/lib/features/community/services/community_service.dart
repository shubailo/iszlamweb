
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/community_post.dart';
import '../models/community_comment.dart';
import '../models/mosque.dart';
import '../models/mosque_group.dart';
import '../models/community_vote.dart';

final communityServiceProvider = Provider((ref) => CommunityService());

class CommunityService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Posts
  Future<List<CommunityPost>> getPosts(String mosqueId) async {
    final List<dynamic> response = await _supabase
        .from('community_posts')
        .select()
        .eq('mosque_id', mosqueId)
        .order('created_at', ascending: false);
    
    return response.map((json) => CommunityPost.fromJson(json)).toList();
  }


  Future<void> createPost(CommunityPost post) async {
    await _supabase.from('community_posts').insert(post.toJson());
  }

  // Admin: Communities (Mosques)
  Future<void> createMosque(Mosque mosque) async {
    await _supabase.from('mosques').insert(mosque.toJson());
  }

  Future<void> updateMosque(Mosque mosque) async {
    await _supabase.from('mosques').update(mosque.toJson()).eq('id', mosque.id);
  }

  // Admin: Groups
  Future<List<MosqueGroup>> getMosqueGroups(String mosqueId) async {
    final List<dynamic> response = await _supabase
        .from('mosque_groups')
        .select()
        .eq('mosque_id', mosqueId)
        .order('name', ascending: true);
    
    return response.map((json) => MosqueGroup.fromJson(json)).toList();
  }

  Future<void> createGroup(MosqueGroup group) async {
    await _supabase.from('mosque_groups').insert(group.toJson());
  }

  Future<void> updateGroup(MosqueGroup group) async {
    await _supabase.from('mosque_groups').update(group.toJson()).eq('id', group.id);
  }

  // Polls
  Future<void> votePoll(String postId, int optionIndex) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Fetch current post to get poll state
    final response = await _supabase
        .from('community_posts')
        .select('poll_votes')
        .eq('id', postId)
        .single();
    
    Map<String, dynamic> pollVotes = response['poll_votes'] ?? {};
    int currentCount = pollVotes[optionIndex.toString()] ?? 0;
    pollVotes[optionIndex.toString()] = currentCount + 1;

    await _supabase.from('community_posts').update({
      'poll_votes': pollVotes,
    }).eq('id', postId);
  }

  // Voting
  Future<void> votePost(String postId, int value) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase.from('community_votes').upsert({
      'post_id': postId,
      'user_id': userId,
      'vote_value': value,
    });
  }

  Future<CommunityVote?> getUserVote(String postId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _supabase
        .from('community_votes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return CommunityVote.fromJson(response);
  }

  // Comments
  Future<List<CommunityComment>> getPostComments(String postId) async {
    final List<dynamic> response = await _supabase
        .from('community_comments')
        .select()
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    final List<CommunityComment> allComments = response
        .map((json) => CommunityComment.fromJson(json))
        .toList();

    return _buildCommentTree(allComments);
  }

  Future<void> addComment(String postId, String content, {String? parentId}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase.from('community_comments').insert({
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'parent_id': parentId,
    });
  }

  // Helper to build threaded comment tree
  List<CommunityComment> _buildCommentTree(List<CommunityComment> flatComments) {
    final Map<String, CommunityComment> commentMap = {
      for (var c in flatComments) c.id: c.copyWith(children: [])
    };
    
    final List<CommunityComment> rootComments = [];

    for (var comment in flatComments) {
      if (comment.parentId == null) {
        rootComments.add(commentMap[comment.id]!);
      } else {
        final parent = commentMap[comment.parentId];
        if (parent != null) {
          // Note: Since models are immutable, we need to handle this carefully.
          // In a real app, you might use a mutable list or a more functional approach.
          // Here we re-create the parent with the new child.
          // This is a simplified version for the demo.
          // For deep trees, a more efficient rebuild might be needed.
          final updatedChildren = List<CommunityComment>.from(parent.children)..add(commentMap[comment.id]!);
          commentMap[comment.id] = commentMap[comment.id]!; // Ensuring it's the right one
          commentMap[comment.parentId!] = parent.copyWith(children: updatedChildren);
        }
      }
    }

    // Re-filter root comments to get the updated ones from the map
    return rootComments.map((root) => commentMap[root.id]!).toList();
  }
}
