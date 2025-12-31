import 'dart:math';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';
import 'package:flutter_kids_matching_game/features/treasure_hunt/domain/challenge_models.dart';
import 'package:flutter_kids_matching_game/features/treasure_hunt/data/treasure_hunt_data.dart';

class ChallengeGenerator {
  final Random _rnd = Random();

  // LEVEL 1: JUNGLE (Lấy từ TreasureHuntData)
  ListenChooseData generateJungleChallenge() {
    // Lấy ngẫu nhiên 1 câu hỏi từ kho Jungle của anh
    final rawData = TreasureHuntData.jungleQuestions[_rnd.nextInt(TreasureHuntData.jungleQuestions.length)];

    final correctItem = GameItem(
      id: rawData['id'],
      image: rawData['image'],
      nameEn: rawData['word_en'],
      nameJa: rawData['word_ja'],
    );

    final List<String> optionPaths = rawData['options'];
    // Tạo danh sách GameItem giả cho các options (chỉ cần ảnh để hiển thị)
    final options = optionPaths.map((path) => GameItem(
        id: 'opt', image: path, nameEn: '', nameJa: ''
    )).toList();

    return ListenChooseData(correctItem, options);
  }

  // LEVEL 2: MOUNTAIN (Lấy từ TreasureHuntData)
  SpellingData generateMountainChallenge(String langCode) {
    final rawData = TreasureHuntData.mountainQuestions[_rnd.nextInt(TreasureHuntData.mountainQuestions.length)];

    return SpellingData(
      GameItem(id: 'mt', image: rawData['image']!, nameEn: rawData['word']!, nameJa: ''),
      wordToSpell: rawData['word']!,
      hintText: langCode == 'ja' ? rawData['hint_ja']! : rawData['hint_en']!,
    );
  }

  // LEVEL 3: DESERT (Lấy từ TreasureHuntData)
  SpellingData generateDesertChallenge(String langCode) {
    final rawData = TreasureHuntData.desertQuestions[_rnd.nextInt(TreasureHuntData.desertQuestions.length)];

    // Gửi từ đã bị đục lỗ qua biến wordToSpell tạm thời (hoặc xử lý ở UI)
    // Ở đây ta giữ nguyên word gốc, UI sẽ đục lỗ dựa trên logic của anh
    return SpellingData(
      GameItem(id: 'dst', image: rawData['image']!, nameEn: rawData['word']!, nameJa: ''),
      wordToSpell: rawData['word']!, // Truyền từ gốc: CAMEL
      hintText: langCode == 'ja' ? rawData['hint_ja']! : rawData['hint_en']!,
    );
  }

  // LEVEL 4: OCEAN (Lấy từ TreasureHuntData)
  FindImageData generateOceanChallenge(String langCode) {
    final rawData = TreasureHuntData.oceanQuestions[_rnd.nextInt(TreasureHuntData.oceanQuestions.length)];
    final List<Map<String, String>> rawOptions = rawData['options'];

    final options = rawOptions.map((opt) => GameItem(
        id: 'ocn', image: opt['path']!, nameEn: opt['label']!, nameJa: ''
    )).toList();

    final correctIndex = rawData['correct_index'] as int;

    return FindImageData(
      options[correctIndex], // Correct Item
      options,
      questionText: langCode == 'ja' ? rawData['riddle_ja'] : rawData['riddle_en'],
    );
  }

  // LEVEL 5: ISLAND (Boss - Tổng hợp)
  IslandData generateIslandChallenge(String langCode) {
    // Boss sẽ lấy ngẫu nhiên 3 câu đố từ Ocean và 2 câu từ Jungle để kiểm tra
    List<FindImageData> rounds = [];

    // Lấy 5 câu Ocean ngẫu nhiên (hoặc lặp lại nếu ít)
    for(int i=0; i<5; i++) {
      rounds.add(generateOceanChallenge(langCode));
    }

    return IslandData(rounds.last.correctItem, rounds: rounds);
  }
}