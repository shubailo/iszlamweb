
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../models/community_post.dart';
import '../services/community_service.dart';
import '../providers/community_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../auth/auth_service.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final String mosqueId;

  const CreatePostScreen({super.key, required this.mosqueId});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _isSubmitting = true);
    
    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user == null) throw Exception('Not authenticated');

      final now = DateTime.now();
      final post = CommunityPost(
        id: const Uuid().v4(),
        mosqueId: widget.mosqueId,
        creatorId: user.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(communityServiceProvider).createPost(post);
      
      if (mounted) {
        ref.invalidate(communityPostsProvider(widget.mosqueId));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating post: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GardenPalette.white,
      appBar: AppBar(
        title: Text('Create Post', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
        backgroundColor: GardenPalette.white,
        foregroundColor: GardenPalette.nearBlack,
        elevation: 0,
        actions: [
          if (_isSubmitting)
            const Center(child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            ))
          else
            TextButton(
              onPressed: _submit,
              child: Text(
                'Post',
                style: GoogleFonts.outfit(
                  color: GardenPalette.emeraldTeal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Post Title',
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                style: GoogleFonts.outfit(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Body text (optional)',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
