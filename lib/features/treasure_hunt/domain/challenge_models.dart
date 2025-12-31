import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';

// Khuôn mẫu chung
abstract class ChallengeData {
  final GameItem correctItem;
  ChallengeData(this.correctItem);
}

// 1. Dữ liệu cho Jungle (Nghe & Chọn)
class ListenChooseData extends ChallengeData {
  final List<GameItem> options;
  ListenChooseData(super.correctItem, this.options);
}

// 2. Dữ liệu cho Mountain & Desert (Đánh vần / Điền từ)
class SpellingData extends ChallengeData {
  final String wordToSpell; // Luôn là Tiếng Anh
  final String hintText;    // Gợi ý (Tiếng Nhật hoặc Anh)
  SpellingData(super.correctItem, {required this.wordToSpell, required this.hintText});
}

// 3. Dữ liệu cho Ocean (Tìm hình theo câu hỏi)
class FindImageData extends ChallengeData {
  final String questionText;
  final List<GameItem> options;
  FindImageData(super.correctItem, this.options, {required this.questionText});
}

// 4. Dữ liệu cho Island (Boss - Gồm nhiều câu hỏi của Ocean gộp lại) -> ĐÂY LÀ CLASS ANH ĐANG THIẾU
class IslandData extends ChallengeData {
  final List<FindImageData> rounds; // Boss có nhiều hiệp đấu
  IslandData(super.correctItem, {required this.rounds});
}