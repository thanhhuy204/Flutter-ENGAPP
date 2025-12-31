import 'package:flutter/foundation.dart';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart'; // Import Model mới

class VocabState {
  final List<GameItem> vocabList; // Dùng GameItem
  final GameItem? selectedVocab;  // Dùng GameItem

  const VocabState({
    required this.vocabList,
    this.selectedVocab,
  });

  VocabState copyWith({
    List<GameItem>? vocabList,
    GameItem? selectedVocab,
  }) {
    return VocabState(
      vocabList: vocabList ?? this.vocabList,
      selectedVocab: selectedVocab ?? this.selectedVocab,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VocabState &&
        listEquals(other.vocabList, vocabList) &&
        other.selectedVocab == selectedVocab;
  }

  @override
  int get hashCode => vocabList.hashCode ^ selectedVocab.hashCode;
}