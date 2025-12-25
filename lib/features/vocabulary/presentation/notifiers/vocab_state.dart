import 'package:flutter/foundation.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/domain/vocab_item.dart';

class VocabState {
  final List<VocabItem> vocabList;
  final VocabItem? selectedVocab;

  const VocabState({
    required this.vocabList,
    this.selectedVocab,
  });

  VocabState copyWith({
    List<VocabItem>? vocabList,
    VocabItem? selectedVocab,
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