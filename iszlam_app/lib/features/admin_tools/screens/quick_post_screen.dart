import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/voice_transcription_service.dart';
import '../../community/providers/mosque_provider.dart';

class QuickPostScreen extends ConsumerStatefulWidget {
  const QuickPostScreen({super.key});

  @override
  ConsumerState<QuickPostScreen> createState() => _QuickPostScreenState();
}

class _QuickPostScreenState extends ConsumerState<QuickPostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isRecording = false;
  bool _isProcessing = false;

  void _toggleRecording() async {
    if (_isRecording) {
      // Stop recording
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      // Simulate getting file path
      String mockPath = 'path/to/audio';
      
      // Transcribe
      try {
        final text = await ref.read(voiceTranscriptionServiceProvider).transcribeAudio(mockPath);
        _contentController.text = text;
        if (_titleController.text.isEmpty) {
            _titleController.text = "Voice Update";
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
         if (mounted) setState(() => _isProcessing = false);
      }

    } else {
      // Start recording
      setState(() => _isRecording = true);
    }
  }

  Future<void> _submitPost() async {
    final mosqueId = ref.read(selectedMosqueIdProvider);
    if (mosqueId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No mosque selected!')));
      return;
    }

    setState(() => _isProcessing = true);
    try {
      await Supabase.instance.client.from('announcements').insert({
        'mosque_id': mosqueId,
        'title': _titleController.text,
        'content': _contentController.text,
        // 'user_id': ... (get from auth)
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Posted!')));
        context.pop();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Announcement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content (Type or Record)', border: OutlineInputBorder()),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            
            // Voice Button
            GestureDetector(
                onTap: _toggleRecording,
                child: CircleAvatar(
                    radius: 40,
                    backgroundColor: _isRecording ? Colors.red : Theme.of(context).primaryColor,
                    child: Icon(
                        _isRecording ? Icons.stop : Icons.mic, 
                        color: Colors.white, 
                        size: 40
                    ),
                ),
            ),
            const SizedBox(height: 8),
            Text(_isRecording ? 'Listening...' : 'Tap Mic to Dictate'),

            const Spacer(),
            
            _isProcessing 
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _submitPost,
                        child: const Text('Post Announcement'),
                    ),
                ),
          ],
        ),
      ),
    );
  }
}
