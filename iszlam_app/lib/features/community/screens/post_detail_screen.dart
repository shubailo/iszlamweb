
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/community_post.dart';
import '../models/community_comment.dart';
import '../providers/community_provider.dart';
import '../services/community_service.dart';
import '../widgets/community_post_card.dart';
import '../../../core/theme/garden_palette.dart';

class PostDetailScreen extends ConsumerWidget {
  final CommunityPost post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = ref.watch(communityCommentsProvider(post.id));

    return Scaffold(
      backgroundColor: GardenPalette.white,
      appBar: AppBar(
        title: Text('Post Details', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        backgroundColor: GardenPalette.white,
        foregroundColor: GardenPalette.nearBlack,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CommunityPostCard(post: post),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(),
                  ),
                ),
                commentsAsync.when(
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text('No comments yet. Be the first!')),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _CommentTreeItem(comment: comments[index]),
                        childCount: comments.length,
                      ),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
                ),
              ],
            ),
          ),
          _CommentInput(postId: post.id),
        ],
      ),
    );
  }
}

class _CommentTreeItem extends StatelessWidget {
  final CommunityComment comment;
  final int depth;

  const _CommentTreeItem({required this.comment, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0 + (depth * 12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: depth > 0 ? GardenPalette.lightGrey : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User · ${comment.createdAt.toString().split(' ')[0]}',
                        style: GoogleFonts.outfit(fontSize: 11, color: GardenPalette.darkGrey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment.content,
                        style: GoogleFonts.outfit(fontSize: 13, color: GardenPalette.nearBlack),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Reply logic
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Reply',
                          style: GoogleFonts.outfit(fontSize: 11, color: GardenPalette.leafyGreen, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...comment.children.map((child) => _CommentTreeItem(comment: child, depth: depth + 1)),
        ],
      ),
    );
  }
}

class _CommentInput extends StatefulWidget {
  final String postId;

  const _CommentInput({required this.postId});

  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: GardenPalette.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, _) => IconButton(
              icon: const Icon(Icons.send, color: GardenPalette.leafyGreen),
              onPressed: () async {
                if (_controller.text.trim().isNotEmpty) {
                  await ref.read(communityServiceProvider).addComment(
                        widget.postId,
                        _controller.text.trim(),
                      );
                  _controller.clear();
                  ref.invalidate(communityCommentsProvider(widget.postId));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
