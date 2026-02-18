
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../models/community_post.dart';
import '../services/community_service.dart';
import '../providers/community_provider.dart';
import '../../../core/theme/garden_palette.dart';
import 'package:iszlamweb_app/features/auth/auth_service.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final String mosqueId;
  final int initialTab;

  const CreatePostScreen({
    super.key,
    required this.mosqueId,
    this.initialTab = 0,
  });

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _linkController = TextEditingController();
  
  // Image State
  PlatformFile? _selectedFile;
  
  // Poll State
  final List<TextEditingController> _pollOptionsControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4, 
      vsync: this, 
      initialIndex: widget.initialTab
    );
     // Connect controller to updating state if needed
     _tabController.addListener(() {
       setState(() {});
     });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    _linkController.dispose();
    for (var c in _pollOptionsControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, 
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _addPollOption() {
    if (_pollOptionsControllers.length < 6) {
      setState(() {
        _pollOptionsControllers.add(TextEditingController());
      });
    }
  }

  void _removePollOption(int index) {
    if (_pollOptionsControllers.length > 2) {
      setState(() {
        _pollOptionsControllers[index].dispose();
        _pollOptionsControllers.removeAt(index);
      });
    }
  }

  CommunityPostType get _currentPostType {
    switch (_tabController.index) {
      case 0: return CommunityPostType.text;
      case 1: return CommunityPostType.image;
      case 2: return CommunityPostType.link;
      case 3: return CommunityPostType.poll;
      default: return CommunityPostType.text;
    }
  }

  bool get _isValid {
    if (_titleController.text.trim().isEmpty) return false;
    
    switch (_currentPostType) {
      case CommunityPostType.image:
        return _selectedFile != null;
      case CommunityPostType.link:
        return _linkController.text.trim().isNotEmpty;
      case CommunityPostType.poll:
        return _pollOptionsControllers.every((c) => c.text.trim().isNotEmpty);
      default:
        return true;
    }
  }

  Future<void> _submit() async {
    if (!_isValid) return;

    setState(() => _isSubmitting = true);
    
    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user == null) throw Exception('Not authenticated');

      final now = DateTime.now();
      
      // Upload image if needed (Mock for now or implement Supabase storage)
      String? imageUrl;
      if (_currentPostType == CommunityPostType.image && _selectedFile != null) {
        // TODO: Implement actual Supabase Storage upload
        // imageUrl = await ref.read(communityServiceProvider).uploadImage(_selectedFile!);
      }

      final post = CommunityPost(
        id: const Uuid().v4(),
        mosqueId: widget.mosqueId,
        creatorId: user.id,
        title: _titleController.text.trim(),
        content: _bodyController.text.trim(),
        postType: _currentPostType,
        imageUrl: imageUrl, 
        linkUrl: _currentPostType == CommunityPostType.link 
            ? _linkController.text.trim() 
            : null,
        pollOptions: _currentPostType == CommunityPostType.poll 
            ? _pollOptionsControllers.map((c) => c.text.trim()).toList() 
            : null,
        pollVotes: _currentPostType == CommunityPostType.poll ? {} : null,
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
      backgroundColor: GardenPalette.offWhite,
      appBar: AppBar(
        title: Text('Create Post', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
        backgroundColor: GardenPalette.white,
        foregroundColor: GardenPalette.nearBlack,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: GardenPalette.nearBlack,
          unselectedLabelColor: GardenPalette.grey,
          indicatorColor: GardenPalette.emeraldTeal,
          tabs: const [
            Tab(text: 'Post', icon: Icon(Icons.description_outlined)),
            Tab(text: 'Image', icon: Icon(Icons.image_outlined)),
            Tab(text: 'Link', icon: Icon(Icons.link)),
            Tab(text: 'Poll', icon: Icon(Icons.poll_outlined)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting || !_isValid ? null : _submit,
            child: Text(
              'POST',
              style: GoogleFonts.outfit(
                color: _isValid ? GardenPalette.emeraldTeal : GardenPalette.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Common Title Field
            Container(
              decoration: BoxDecoration(
                color: GardenPalette.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: GardenPalette.lightGrey),
              ),
              child: TextField(
                controller: _titleController,
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 16),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTextTab(),
                  _buildImageTab(),
                  _buildLinkTab(),
                  _buildPollTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextTab() {
    return Container(
      decoration: BoxDecoration(
        color: GardenPalette.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GardenPalette.lightGrey),
      ),
      child: TextField(
        controller: _bodyController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: GoogleFonts.outfit(fontSize: 16),
        decoration: const InputDecoration(
          hintText: 'Body text (optional)',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildImageTab() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: GardenPalette.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GardenPalette.lightGrey, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_selectedFile != null) ...[
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(4),
                   child: _selectedFile!.bytes != null 
                       ? Image.memory(_selectedFile!.bytes!, fit: BoxFit.contain)
                       : Image.file(File(_selectedFile!.path!), fit: BoxFit.contain),
                 ),
               ),
             ),
             TextButton.icon(
               onPressed: _pickImage,
               icon: const Icon(Icons.refresh),
               label: const Text('Change Image'),
             ),
          ] else
            GestureDetector(
              onTap: _pickImage,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 48, color: GardenPalette.emeraldTeal),
                  const SizedBox(height: 12),
                  Text(
                    'Upload Image',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: GardenPalette.emeraldTeal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLinkTab() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: GardenPalette.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: GardenPalette.lightGrey),
          ),
          child: TextField(
            controller: _linkController,
            style: GoogleFonts.outfit(fontSize: 16),
            decoration: const InputDecoration(
              hintText: 'Url',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: Icon(Icons.link, color: GardenPalette.grey),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200, 
          width: double.infinity,
          decoration: BoxDecoration(
            color: GardenPalette.lightGrey.withAlpha(50),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            'Link Preview',
            style: GoogleFonts.outfit(color: GardenPalette.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildPollTab() {
    return Container(
      decoration: BoxDecoration(
        color: GardenPalette.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GardenPalette.lightGrey),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _pollOptionsControllers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pollOptionsControllers[index],
                        decoration: InputDecoration(
                          hintText: 'Option ${index + 1}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: GardenPalette.lightGrey),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    if (_pollOptionsControllers.length > 2)
                      IconButton(
                        icon: const Icon(Icons.close, color: GardenPalette.grey),
                        onPressed: () => _removePollOption(index),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_pollOptionsControllers.length < 6)
            OutlinedButton.icon(
              onPressed: _addPollOption,
              icon: const Icon(Icons.add),
              label: const Text('Add Option'),
              style: OutlinedButton.styleFrom(
                foregroundColor: GardenPalette.emeraldTeal,
              ),
            ),
        ],
      ),
    );
  }
}
