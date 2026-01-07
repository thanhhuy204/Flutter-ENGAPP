import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../data/services/space_storage_service.dart';
import 'space_state.dart';

class SpaceNotifier extends AutoDisposeNotifier<SpaceState> {
  final FlutterTts _tts = FlutterTts();
  final _storage = SpaceStorageService();

  @override
  SpaceState build() {
    _tts.setSpeechRate(0.4);

    // Tự động load tiến trình cũ khi Notifier được tạo ra
    _loadProgress();

    return SpaceState(); // Trả về state mặc định trong lúc chờ load
  }

  Future<void> _loadProgress() async {
    final unlocked = await _storage.getUnlockedLevel();
    final index = await _storage.getCurrentIndex();

    // Cập nhật State từ dữ liệu đã lưu
    state = state.copyWith(
      unlockedLevel: unlocked,
      currentPlanetIndex: index,
    );
  }

  void completeLevel(int level) async {
    int newUnlocked = state.unlockedLevel;
    int newIndex = state.currentPlanetIndex;

    if (level == state.unlockedLevel && level < 6) {
      newUnlocked = level + 1;
      newIndex = level;
    } else {
      newIndex = level - 1;
    }

    state = state.copyWith(unlockedLevel: newUnlocked, currentPlanetIndex: newIndex);

    // Ghi đè tiến trình mới vào máy
    await _storage.saveProgress(newUnlocked, newIndex);
  }

  void updatePosition(int index) async {
    state = state.copyWith(currentPlanetIndex: index);
    // Lưu lại vị trí đứng của phi hành gia
    await _storage.saveProgress(state.unlockedLevel, index);
  }

  Future<void> speak(String text, String lang) async {
    await _tts.setLanguage(lang == 'ja' ? 'ja-JP' : 'en-US');
    await _tts.speak(text);
  }
}

final spaceProvider = AutoDisposeNotifierProvider<SpaceNotifier, SpaceState>(() => SpaceNotifier());