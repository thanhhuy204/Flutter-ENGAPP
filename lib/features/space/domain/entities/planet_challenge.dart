enum SpaceSkill {
  listening,
  missingLetter,
  matching,
  scramble,
  reading,
}

class SpaceQuestion {
  final String targetWord;
  final String hint;
  final String? answer;
  final List<String>? imageOptions;
  final String? correctImage;

  const SpaceQuestion({
    required this.targetWord,
    required this.hint,
    this.answer,
    this.imageOptions,
    this.correctImage,
  });
}

class SpacePlanet {
  final String id;
  final String name;
  final int level;
  final SpaceSkill skill;
  final List<SpaceQuestion> questions;

  const SpacePlanet({
    required this.id,
    required this.name,
    required this.level,
    required this.skill,
    required this.questions,
  });
}

class SpaceData {
  static const List<SpacePlanet> planets = [
    // =========================
    // LEVEL 1 – MERCURY
    // Listening + Choose Image
    // =========================
    SpacePlanet(
      id: 'mercury',
      name: 'Mercury',
      level: 1,
      skill: SpaceSkill.listening,
      questions: [
        SpaceQuestion(
          targetWord: 'lion',
          hint: 'mercury_hint_1',
          correctImage: 'lion',
          imageOptions: ['lion', 'dog', 'cat', 'tiger'],
        ),
        SpaceQuestion(
          targetWord: 'dog',
          hint: 'mercury_hint_2',
          correctImage: 'dog',
          imageOptions: ['wolf', 'dog', 'fox', 'cat'],
        ),
        SpaceQuestion(
          targetWord: 'parrot',
          hint: 'mercury_hint_3',
          correctImage: 'parrot',
          imageOptions: ['parrot', 'duck', 'chicken', 'eagle'],
        ),
      ],
    ),

    // =========================
    // LEVEL 2 - VENUS
    // Missing Letter
    // =========================
    SpacePlanet(
      id: 'venus',
      name: 'Venus',
      level: 2,
      skill: SpaceSkill.missingLetter,
      questions: [
        SpaceQuestion(targetWord: 'APPLE', hint: 'venus_hint_1', answer: 'P'),
        SpaceQuestion(targetWord: 'LEMON', hint: 'venus_hint_2', answer: 'O'),
        SpaceQuestion(targetWord: 'GRAPE', hint: 'venus_hint_3', answer: 'A'),
        SpaceQuestion(targetWord: 'CHERRY', hint: 'venus_hint_4', answer: 'R'),
      ],
    ),

    // =========================
    // LEVEL 3 - EARTH
    // Reading
    // =========================
    SpacePlanet(
      id: 'earth',
      name: 'Earth',
      level: 3,
      skill: SpaceSkill.reading,
      questions: [
        SpaceQuestion(targetWord: 'cat', hint: 'earth_hint_1'),
        SpaceQuestion(targetWord: 'tree', hint: 'earth_hint_2'),
        SpaceQuestion(targetWord: 'water', hint: 'earth_hint_3'),
        SpaceQuestion(targetWord: 'flower', hint: 'earth_hint_4'),
      ],
    ),

    // =========================
    // LEVEL 4 - MARS
    // Scramble
    // =========================
    SpacePlanet(
      id: 'mars',
      name: 'Mars',
      level: 4,
      skill: SpaceSkill.scramble,
      questions: [
        SpaceQuestion(targetWord: 'ELEPHANT', hint: 'mars_hint_1'),
        SpaceQuestion(targetWord: 'TIGER', hint: 'mars_hint_2'),
        SpaceQuestion(targetWord: 'ZEBRA', hint: 'mars_hint_3'),
      ],
    ),

    // =========================
    // LEVEL 5 - JUPITER
    // Listening (tap)
    // =========================
    SpacePlanet(
      id: 'jupiter',
      name: 'Jupiter',
      level: 5,
      skill: SpaceSkill.listening,
      questions: [
        SpaceQuestion(targetWord: 'banana', hint: 'jupiter_hint_1'),
        SpaceQuestion(targetWord: 'orange', hint: 'jupiter_hint_2'),
      ],
    ),

    // =========================
    // FINAL - SUN
    // Matching
    // =========================
    SpacePlanet(
      id: 'sun',
      name: 'Sun',
      level: 6,
      skill: SpaceSkill.matching,
      questions: [
        SpaceQuestion(targetWord: 'sun', hint: 'sun_hint_1'),
        SpaceQuestion(targetWord: 'light', hint: 'sun_hint_2'),
      ],
    ),
  ];
}
