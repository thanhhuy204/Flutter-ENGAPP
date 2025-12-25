import 'package:flutter_kids_matching_game/features/vocabulary/domain/vocab_item.dart';

class SpellingLevel {
  final VocabItem vocab;        // Dữ liệu từ vựng gốc (từ, ảnh, nghĩa)
  final int difficulty;         // Độ khó (ví dụ: 1 = dễ, 2 = có thêm chữ cái thừa)
  final List<String> hints;     // Gợi ý cho bé nếu gặp khó khăn

  SpellingLevel({
    required this.vocab,
    this.difficulty = 1,
    this.hints = const [],
  });

  // Getter giúp lấy tên từ vựng nhanh hơn
  String get word => vocab.word.toUpperCase();
  String get image => vocab.image;
}