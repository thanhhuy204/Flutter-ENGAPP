import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'space_state.dart';

class SpaceNotifier extends AutoDisposeNotifier<SpaceState> {
  final FlutterTts _tts = FlutterTts();

  @override
  SpaceState build() {
    _tts.setSpeechRate(0.4);
    return SpaceState();
  }

  void completeLevel(int level) {
    if (level == state.unlockedLevel && level < 6) {
      state = state.copyWith(unlockedLevel: level + 1, currentPlanetIndex: level);
    } else {
      state = state.copyWith(currentPlanetIndex: level - 1);
    }
  }

  void updatePosition(int index) {
    state = state.copyWith(currentPlanetIndex: index);
  }

  Future<void> speak(String text, String lang) async {
    await _tts.setLanguage(lang == 'ja' ? 'ja-JP' : 'en-US');
    await _tts.speak(text);
  }
}

final spaceProvider = AutoDisposeNotifierProvider<SpaceNotifier, SpaceState>(() => SpaceNotifier());