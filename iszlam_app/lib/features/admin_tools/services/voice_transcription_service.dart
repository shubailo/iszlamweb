import 'package:flutter_riverpod/flutter_riverpod.dart';

final voiceTranscriptionServiceProvider = Provider((ref) => VoiceTranscriptionService());

class VoiceTranscriptionService {
  // STUB: Integrate OpenAI Whisper API
  // For MVP, we will simulate a transcription

  Future<String> transcribeAudio(String audioPath) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Return mock text
    return "Assalamu alaykum. Jumuah prayer will be at 1:30 PM today. Please arrive early.";
  }
}
