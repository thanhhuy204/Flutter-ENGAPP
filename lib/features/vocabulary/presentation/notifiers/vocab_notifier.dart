import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_kids_matching_game/core/data/global_data_source.dart';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart'; // Import Settings
import 'vocab_state.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart'; // This was MISSING in my previous response for VocabNotifier!

class VocabNotifier extends AutoDisposeNotifier<VocabState> {
  final FlutterTts _tts = FlutterTts();
  late String _currentLangCode;

  @override
  VocabState build() {
    // 1. Lấy ngôn ngữ hiện tại từ Settings (en hoặc ja)
    final settings = ref.watch(settingsNotifierProvider);
    _currentLangCode = settings.selectedLanguage.languageCode;

    _initTts();

    // 2. Load toàn bộ dữ liệu (Animals + Fruits + Colors)
    return VocabState(vocabList: GlobalDataSource.getAll());
  }

  Future<void> _initTts() async {
    // Cài đặt giọng đọc theo ngôn ngữ
    if (_currentLangCode == 'ja') {
      await _tts.setLanguage("ja-JP");
    } else {
      await _tts.setLanguage("en-US");
    }
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(1.0);
  }

  Future<void> speakWord(String text) async {
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  void onWordTap(GameItem item, WidgetRef ref) {
    state = state.copyWith(selectedVocab: item);
    // Đọc tên theo ngôn ngữ đang chọn
    speakWord(item.name(_currentLangCode));
  }
}

final vocabNotifierProvider = AutoDisposeNotifierProvider<VocabNotifier, VocabState>(() {
  return VocabNotifier();
});