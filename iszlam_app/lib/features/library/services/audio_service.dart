import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../models/library_item.dart';

// --- STATE ---
class AudioState {
  final bool isPlaying;
  final LibraryItem? currentItem;
  final Duration position;
  final Duration duration;

  const AudioState({
    this.isPlaying = false,
    this.currentItem,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  AudioState copyWith({
    bool? isPlaying,
    LibraryItem? currentItem,
    Duration? position,
    Duration? duration,
  }) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentItem: currentItem ?? this.currentItem,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

// --- NOTIFIER ---
class AudioService extends Notifier<AudioState> {
  final AudioPlayer _player = AudioPlayer();

  @override
  AudioState build() {
    _init();
    ref.onDispose(() {
      _player.dispose();
    });
    return const AudioState();
  }

  void _init() {
    _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      if (playerState.processingState == ProcessingState.ready) {
      }
      state = state.copyWith(isPlaying: isPlaying);
    });

    _player.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    _player.durationStream.listen((dur) {
      if (dur != null) state = state.copyWith(duration: dur);
    });
  }

  Future<void> playItem(LibraryItem item) async {
    if (state.currentItem?.id == item.id) {
       if (state.isPlaying) {
         _player.pause();
       } else {
         _player.play();
       }
       return;
    }

    try {
      state = state.copyWith(currentItem: item, isPlaying: true); 
      await _player.setUrl(item.mediaUrl); 
      _player.play();
    } catch (e) {
      state = state.copyWith(isPlaying: false);
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }
  
  void close() {
    _player.stop();
    state = const AudioState(); 
  }
}

// --- PROVIDER ---
final audioServiceProvider = NotifierProvider<AudioService, AudioState>(AudioService.new);
