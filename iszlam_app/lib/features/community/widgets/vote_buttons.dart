
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/community_provider.dart';
import '../services/community_service.dart';
import '../../../core/theme/garden_palette.dart';

class VoteButtons extends ConsumerWidget {
  final String postId;
  final int initialScore;

  const VoteButtons({
    super.key,
    required this.postId,
    required this.initialScore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userVoteAsync = ref.watch(userVoteProvider(postId));
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        userVoteAsync.when(
          data: (vote) => IconButton(
            icon: Icon(
              Icons.arrow_upward_rounded,
              color: vote?.voteValue == 1 ? GardenPalette.leafyGreen : GardenPalette.darkGrey,
            ),
            onPressed: () => ref.read(communityServiceProvider).votePost(postId, 1),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, _) => const Icon(Icons.arrow_upward_rounded, color: GardenPalette.darkGrey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            initialScore.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: GardenPalette.nearBlack,
            ),
          ),
        ),
        userVoteAsync.when(
          data: (vote) => IconButton(
            icon: Icon(
              Icons.arrow_downward_rounded,
              color: vote?.voteValue == -1 ? GardenPalette.errorRed : GardenPalette.darkGrey,
            ),
            onPressed: () => ref.read(communityServiceProvider).votePost(postId, -1),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const Icon(Icons.arrow_downward_rounded, color: GardenPalette.darkGrey),
        ),
      ],
    );
  }
}
