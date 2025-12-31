/// Base class for all challenge questions
abstract class ChallengeQuestion {
  final Map<String, String> translations;
  
  const ChallengeQuestion({required this.translations});
  
  String getTranslation(String languageCode) {
    return translations[languageCode] ?? translations['en'] ?? '';
  }
}

/// Desert Fill Blank Question
class DesertFillBlankQuestion extends ChallengeQuestion {
  final String word;
  final String questionPattern;
  final String answer;
  final Map<String, String> hintTranslations;
  
  const DesertFillBlankQuestion({
    required this.word,
    required this.questionPattern,
    required this.answer,
    required this.hintTranslations,
    required super.translations,
  });
  
  String getHint(String languageCode) {
    return hintTranslations[languageCode] ?? hintTranslations['en'] ?? '';
  }
}

/// Mountain Word Puzzle Question
class MountainWordPuzzleQuestion extends ChallengeQuestion {
  final String word;
  final Map<String, String> hintTranslations;
  
  const MountainWordPuzzleQuestion({
    required this.word,
    required this.hintTranslations,
    required super.translations,
  });
  
  String getHint(String languageCode) {
    return hintTranslations[languageCode] ?? hintTranslations['en'] ?? '';
  }
}

/// Jungle Listen Choose Question
class JungleListenChooseQuestion extends ChallengeQuestion {
  final String word;
  final List<String> imagePaths;
  final int answerIndex;
  
  const JungleListenChooseQuestion({
    required this.word,
    required this.imagePaths,
    required this.answerIndex,
    required super.translations,
  });
}

/// Ocean Choose Image Question
class OceanChooseImageQuestion extends ChallengeQuestion {
  final Map<String, String> riddleTranslations;
  final List<OceanChoiceOption> options;
  final int answerIndex;
  
  const OceanChooseImageQuestion({
    required this.riddleTranslations,
    required this.options,
    required this.answerIndex,
    required super.translations,
  });
  
  String getRiddle(String languageCode) {
    return riddleTranslations[languageCode] ?? riddleTranslations['en'] ?? '';
  }
}

class OceanChoiceOption {
  final String imagePath;
  final Map<String, String> labelTranslations;
  
  const OceanChoiceOption({
    required this.imagePath,
    required this.labelTranslations,
  });
  
  String getLabel(String languageCode) {
    return labelTranslations[languageCode] ?? labelTranslations['en'] ?? '';
  }
}

/// Island Quiz Option with Image
class IslandQuizOption {
  final String text;
  final String imagePath;
  
  const IslandQuizOption({
    required this.text,
    required this.imagePath,
  });
}

/// Island Match Word Image Question
class IslandQuizQuestion extends ChallengeQuestion {
  final Map<String, String> questionTranslations;
  final List<IslandQuizOption> options;
  final String answer;
  final String? questionImagePath; // Optional image for the question itself
  
  const IslandQuizQuestion({
    required this.questionTranslations,
    required this.options,
    required this.answer,
    required super.translations,
    this.questionImagePath,
  });
  
  String getQuestion(String languageCode) {
    return questionTranslations[languageCode] ?? questionTranslations['en'] ?? '';
  }
}
