import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';

class SpellingState {
  final GameItem currentItem;     // Dùng GameItem chuẩn
  final String currentWord;       // Từ vựng hiện tại (đã được lấy theo EN/JP)
  final List<String> scrambledLetters;
  final List<String> userGuess;
  final bool isSuccess;

  SpellingState({
    required this.currentItem,
    required this.currentWord,
    required this.scrambledLetters,
    required this.userGuess,
    this.isSuccess = false,
  });

  SpellingState copyWith({
    GameItem? currentItem,
    String? currentWord,
    List<String>? scrambledLetters,
    List<String>? userGuess,
    bool? isSuccess,
  }) {
    return SpellingState(
      currentItem: currentItem ?? this.currentItem,
      currentWord: currentWord ?? this.currentWord,
      scrambledLetters: scrambledLetters ?? this.scrambledLetters,
      userGuess: userGuess ?? this.userGuess,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}