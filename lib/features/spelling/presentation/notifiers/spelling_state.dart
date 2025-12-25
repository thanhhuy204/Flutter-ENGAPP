import 'package:flutter_kids_matching_game/features/vocabulary/domain/vocab_item.dart';

class SpellingState {
  final VocabItem currentVocab;   // Từ vựng hiện tại đang học
  final List<String> scrambledLetters; // Các chữ cái bị xáo trộn
  final List<String> userGuess;   // Các chữ cái bé đã nhấn chọn
  final bool isSuccess;           // Đã hoàn thành đúng chưa

  SpellingState({
    required this.currentVocab,
    required this.scrambledLetters,
    required this.userGuess,
    this.isSuccess = false,
  });

  SpellingState copyWith({
    VocabItem? currentVocab,
    List<String>? scrambledLetters,
    List<String>? userGuess,
    bool? isSuccess,
  }) {
    return SpellingState(
      currentVocab: currentVocab ?? this.currentVocab,
      scrambledLetters: scrambledLetters ?? this.scrambledLetters,
      userGuess: userGuess ?? this.userGuess,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}