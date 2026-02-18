
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/community_post.dart';
import 'vote_buttons.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/widgets/garden_card.dart';

class CommunityPostCard extends ConsumerWidget {
  final CommunityPost post;
  final VoidCallback? onTap;

  const CommunityPostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GardenCard(
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Votes
              Container(
                width: 40,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: GardenPalette.lightGrey.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: VoteButtons(
                  postId: post.id,
                  initialScore: post.voteScore,
                ),
              ),
              const SizedBox(width: 12),
              
              // Main Column: Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          const Icon(Icons.account_circle, size: 16, color: GardenPalette.darkGrey),
                          const SizedBox(width: 4),
                          Text(
                            'Admin · ${post.createdAt.toString().split(' ')[0]}',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: GardenPalette.darkGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Title
                      Text(
                        post.title,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: GardenPalette.nearBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Content
                      Text(
                        post.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          height: 1.5,
                          color: GardenPalette.darkGrey,
                        ),
                      ),
                      
                      if (post.imageUrl != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            post.imageUrl!,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 12),
                      
                      // Footer
                      Row(
                        children: [
                          const Icon(Icons.mode_comment_outlined, size: 14, color: GardenPalette.darkGrey),
                          const SizedBox(width: 4),
                          Text(
                            '${post.commentCount} Comments',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: GardenPalette.darkGrey,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.share_outlined, size: 14, color: GardenPalette.darkGrey),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
