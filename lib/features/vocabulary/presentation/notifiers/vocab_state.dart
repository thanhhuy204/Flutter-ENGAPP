import 'package:flutter/foundation.dart';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart'; // Import Model mới

class VocabState {
  final List<GameItem> vocabList;
  final GameItem? selectedVocab;
  final String selectedCategory; // Thêm dòng này: 'Animals', 'Fruits', 'Colors' hoặc 'All'

  const VocabState({
    required this.vocabList,
    this.selectedVocab,
    this.selectedCategory = 'All', // Mặc định là hiện tất cả
  });

  VocabState copyWith({
    List<GameItem>? vocabList,
    GameItem? selectedVocab,
    String? selectedCategory,
  }) {
    return VocabState(
      vocabList: vocabList ?? this.vocabList,
      selectedVocab: selectedVocab ?? this.selectedVocab,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}