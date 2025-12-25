import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import để đọc chữ
import 'package:flutter_kids_matching_game/features/vocabulary/data/vocab_data.dart';
import 'spelling_state.dart';

class SpellingNotifier extends AutoDisposeNotifier<SpellingState> {
  final FlutterTts _tts = FlutterTts();

  @override
  SpellingState build() {
    _initTts();
    return _loadLevel(0);
  }

  void _initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.6); // Đọc chậm một chút cho bé nghe rõ
  }

  SpellingState _loadLevel(int index) {
    final vocab = VocabData.animals[index];
    List<String> letters = vocab.word.toUpperCase().split('')..shuffle();

    return SpellingState(
      currentVocab: vocab,
      scrambledLetters: letters,
      userGuess: [],
      isSuccess: false,
    );
  }

  // 1. KHI BÉ CHỌN CHỮ
  void pickLetter(int index) {
    if (state.isSuccess) return;

    final letter = state.scrambledLetters[index];

    // Đọc âm thanh của chữ cái vừa nhấn
    // TỐI ƯU TỐC ĐỘ: Không dùng await ở đây để giao diện không bị đợi
    // Dừng ngay lập tức bất kỳ âm thanh nào đang phát để đọc chữ mới
    _tts.stop().then((_) {
      _tts.speak(letter);
    });

    final newUserGuess = [...state.userGuess, letter];
    final newScrambled = List<String>.from(state.scrambledLetters)..removeAt(index);

    _checkResult(newUserGuess, newScrambled);
  }

  // 2. KHI BÉ MUỐN GỠ CHỮ (TRẢ LẠI)
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
    final targetWord = state.currentVocab.word.toUpperCase();
    bool success = guess.join('') == targetWord;

    state = state.copyWith(
      userGuess: guess,
      scrambledLetters: scrambled,
      isSuccess: success,
    );

    if (success) {
      // Khi thắng, máy đọc cả từ để bé ghi nhớ
      _tts.speak(state.currentVocab.word);
    }
  }

  void nextLevel() {
    final allVocabs = VocabData.animals;
    int nextIndex = allVocabs.indexOf(state.currentVocab) + 1;
    if (nextIndex >= allVocabs.length) nextIndex = 0;
    state = _loadLevel(nextIndex);
  }
}

final spellingProvider = AutoDisposeNotifierProvider<SpellingNotifier, SpellingState>(() {
  return SpellingNotifier();
});