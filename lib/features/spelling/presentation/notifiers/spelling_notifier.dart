import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

import 'package:flutter_kids_matching_game/core/data/global_data_source.dart';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart'; // Import để dùng extension ngôn ngữ
import 'spelling_state.dart';

class SpellingNotifier extends AutoDisposeNotifier<SpellingState> {
  final FlutterTts _tts = FlutterTts();
  late String _currentLangCode;

  @override
  SpellingState build() {
    // 1. Lấy cài đặt ngôn ngữ hiện tại
    final settings = ref.watch(settingsNotifierProvider);
    _currentLangCode = settings.selectedLanguage.languageCode;

    _initTts();

    // 2. Load câu hỏi đầu tiên
    return _loadLevel(0);
  }

  void _initTts() async {
    if (_currentLangCode == 'ja') {
      await _tts.setLanguage("ja-JP");
    } else {
      await _tts.setLanguage("en-US");
    }
    await _tts.setSpeechRate(0.5);
  }

  SpellingState _loadLevel(int index) {
    // Lấy danh sách động vật từ Global Data
    final List<GameItem> data = GlobalDataSource.animals;

    final item = data[index % data.length];

    // Lấy tên theo ngôn ngữ đã chọn (EN hoặc JP)
    String word = item.name(_currentLangCode).toUpperCase();

    // Tách chữ cái và xáo trộn
    List<String> letters = word.split('')..shuffle();

    return SpellingState(
      currentItem: item,
      currentWord: word,
      scrambledLetters: letters,
      userGuess: [],
      isSuccess: false,
    );
  }

  void pickLetter(int index) {
    if (state.isSuccess) return;

    final letter = state.scrambledLetters[index];
    _tts.stop();
    _tts.speak(letter);

    final newUserGuess = [...state.userGuess, letter];
    final newScrambled = List<String>.from(state.scrambledLetters)..removeAt(index);

    _checkResult(newUserGuess, newScrambled);
  }

  void removeLetter(int index) {
    if (state.isSuccess) return;

    final letter = state.userGuess[index];
    final newUserGuess = List<String>.from(state.userGuess)..removeAt(index);
    final newScrambled = [...state.scrambledLetters, letter];

    state = state.copyWith(
      userGuess: newUserGuess,
      scrambledLetters: newScrambled,
      isSuccess: false,
    );
  }

  void _checkResult(List<String> guess, List<String> scrambled) {
    bool success = guess.join('') == state.currentWord;

    state = state.copyWith(
      userGuess: guess,
      scrambledLetters: scrambled,
      isSuccess: success,
    );

    if (success) {
      _tts.speak(state.currentWord);
    }
  }

  void nextLevel() {
    int nextIndex = Random().nextInt(GlobalDataSource.animals.length);
    state = _loadLevel(nextIndex);
  }
}

final spellingProvider = AutoDisposeNotifierProvider<SpellingNotifier, SpellingState>(() {
  return SpellingNotifier();
});