import 'dart:math';

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

  SpaceQuestion({
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

  SpacePlanet({
    required this.id,
    required this.name,
    required this.level,
    required this.skill,
    required this.questions,
  });
}

class SpaceData {
  /// 🧠 TỪ DÙNG CHUNG CHO EN & JA
  static final List<String> _missingLetterWords = [
    'apple', 'banana', 'cherry', 'tiger', 'monkey', 'lion', 'zebra', 'grape', 'orange', 'pear', 'watermelon',
    'leopard', 'kangaroo', 'mouse', 'ox', 'fox', 'octopus', 'penguin', 'turtle', 'wolf', 'mango', 'peach', 'strawberry',
  ];

  static final List<Map<String, dynamic>> _earthVocabulary = [
    {'word': 'eagle', 'folder': 'animals'},
    {'word': 'elephant', 'folder': 'animals'},
    {'word': 'fish', 'folder': 'animals'},
    {'word': 'duck', 'folder': 'animals'},
    {'word': 'crab', 'folder': 'animals'},
    {'word': 'lion', 'folder': 'animals'},
    {'word': 'dog', 'folder': 'animals'},
    {'word': 'fox', 'folder': 'animals'},
    {'word': 'wolf', 'folder': 'animals'},
    {'word': 'leopard', 'folder': 'animals'},
    {'word': 'penguin', 'folder': 'animals'},
    {'word': 'tiger', 'folder': 'animals'},
    {'word': 'turtle', 'folder': 'animals'},
    {'word': 'apple', 'folder': 'fruits'},
    {'word': 'banana', 'folder': 'fruits'},
    {'word': 'grape', 'folder': 'fruits'},
    {'word': 'watermelon', 'folder': 'fruits'},
    {'word': 'strawberry', 'folder': 'fruits'},
    {'word': 'mango', 'folder': 'fruits'},
    {'word': 'orange', 'folder': 'fruits'},
    {'word': 'lemon', 'folder': 'fruits'},
    {'word': 'pear', 'folder': 'fruits'},
    {'word': 'peach', 'folder': 'fruits'},
    {'word': 'pineapple', 'folder': 'fruits'},
    {'word': 'Red', 'folder': 'colors'},
    {'word': 'Blue', 'folder': 'colors'},
    {'word': 'Green', 'folder': 'colors'},
    {'word': 'Yellow', 'folder': 'colors'},
    {'word': 'White', 'folder': 'colors'},
    {'word': 'Silver', 'folder': 'colors'},
    {'word': 'Pink', 'folder': 'colors'},
  ];

  // 🧩 DỮ LIỆU CÂU ĐỐ CHO LEVEL 4 (MARS)
  static final List<Map<String, String>> _scramblePool = [
    {'word': 'FOX', 'hint': 'I have a bushy tail and live in the wild.'},
    {'word': 'DOG', 'hint': 'I am man\'s best friend and I bark.'},
    {'word': 'CAT', 'hint': 'I like to catch mice and say "Meow".'},
    {'word': 'LION', 'hint': 'I am the king of the jungle.'},
    {'word': 'FISH', 'hint': 'I live underwater and have fins.'},
    {'word': 'BIRD', 'hint': 'I have wings and can fly high.'},
    {'word': 'APPLE', 'hint': 'I am a crunchy fruit, often red or green.'},
    {'word': 'DUCK', 'hint': 'I say "Quack" and love to swim.'},
    {'word': 'CRAB', 'hint': 'I walk sideways on the beach.'},
    {'word': 'GRAPE', 'hint': 'I am a small, round fruit used to make wine.'},
    {'word': 'LEMON', 'hint': 'I am a yellow fruit and very sour.'},
  ];

  // 🌩️ DỮ LIỆU CHO LEVEL 5 (JUPITER) - Tập trung vào các từ đã học ở level trước để kiểm tra trí nhớ
  static final List<String> _jupiterPool = [
    'TIGER', 'MONKEY', 'ZEBRA', 'ORANGE', 'PINEAPPLE',
    'BANANA', 'TURTLE', 'PENGUIN', 'LEMON', 'APPLE',
    'EAGLE', 'SHARK', 'PEAR', 'WATERMELON', 'PEACH',
    'CRAB', 'STRAWBERRY', 'MOUSE', 'OCTOPUS', 'PARROT', 'PENGUIN',
    'SHEEP',
  ];

  static Map<String, String> get _wordFolderMap {
    final Map<String, String> map = {};

    // Đưa tất cả từ trong _earthVocabulary vào map
    for (var item in _earthVocabulary) {
      map[item['word']] = item['folder'];
    }

    // Thêm các từ từ các level khác nếu cần (ví dụ level 1 mặc định là animals)
    // map['parrot'] = 'animals';

    return map;
  }

  // 🆕 Hàm lấy đường dẫn ảnh hoàn chỉnh
  static String getImagePath(String word) {
    // Nếu từ có trong map thì lấy folder tương ứng, không thì mặc định là 'animals'
    final folder = _wordFolderMap[word] ?? 'animals';
    return 'assets/images/$folder/$word.png';
  }

  /// 🎲 RANDOM 5 CÂU
  static List<SpaceQuestion> _buildLevel2Questions() {
    final rand = Random();
    final words = [..._missingLetterWords]..shuffle();

    return words.take(5).map((word) {
      final index = rand.nextInt(word.length);
      final missingChar = word[index];

      return SpaceQuestion(
        targetWord: word,
        hint: word, // key localization
        answer: missingChar,
      );
    }).toList();
  }

  static List<SpaceQuestion> _buildLevel3Questions() {
    final rand = Random();
    final items = [..._earthVocabulary]..shuffle();

    return items.take(7).map((item) {
      final word = item['word'] as String;
      final folder = item['folder'] as String;

      // Tạo list options: 1 đúng + 3 sai
      final options = <String>{word};
      while (options.length < 4) {
        options.add(_earthVocabulary[rand.nextInt(_earthVocabulary.length)]['word']);
      }

      final shuffledOptions = options.toList()..shuffle();

      return SpaceQuestion(
        targetWord: word,
        hint: folder, // Dùng hint để chứa tên folder ảnh
        correctImage: word,
        imageOptions: shuffledOptions,
      );
    }).toList();
  }

  static List<SpaceQuestion> _buildLevel4Questions() {
    final pool = [..._scramblePool]..shuffle();
    return pool.take(8).map((item) {
      return SpaceQuestion(
        targetWord: item['word']!,
        hint: item['hint']!, // Đây là câu đố hiển thị trong ô trắng
      );
    }).toList();
  }

  static List<SpaceQuestion> _buildLevel5Questions() {
    final pool = [..._jupiterPool]..shuffle();
    return pool.take(8).map((word) {
      return SpaceQuestion(
        targetWord: word,
        hint: 'jupiter_dictation', // Dùng để xác định logic ẩn/hiện
        correctImage: word.toLowerCase(),
      );
    }).toList();
  }

  static List<SpaceQuestion> _buildLevel6Questions() {
    final rand = Random();
    List<SpaceQuestion> questions = [];

    // Round 1: Listening (Câu 0-4)
    final r1 = [..._missingLetterWords]..shuffle();
    questions.addAll(r1.take(5).map((w) => SpaceQuestion(
      targetWord: w,
      hint: 'SUN_ROUND_1', // Đánh dấu Round 1
      correctImage: w,
      imageOptions: _generateOptions(w),
    )));

    // Round 2: Missing Letter (Câu 5-9)
    final r2 = [..._missingLetterWords]..shuffle();
    questions.addAll(r2.take(5).map((w) {
      final char = w[rand.nextInt(w.length)];
      return SpaceQuestion(targetWord: w, answer: char, hint: 'SUN_ROUND_2');
    }));

    // Round 3: Reading (Câu 10-14)
    final r3 = [..._earthVocabulary]..shuffle();
    questions.addAll(r3.take(5).map((item) => SpaceQuestion(
      targetWord: item['word'],
      hint: 'SUN_ROUND_3',
      correctImage: item['word'],
      imageOptions: _generateOptions(item['word']),
    )));

    // Round 4: Scramble (Câu 15-19)
    final r4 = [..._scramblePool]..shuffle();
    questions.addAll(r4.take(5).map((item) => SpaceQuestion(
      targetWord: item['word']!,
      hint: item['hint']!, // Hint là câu đố, code sẽ nhận diện qua index
    )));

    return questions;
  }

  static List<String> _generateOptions(String correct) {
    final options = <String>{correct};
    final allWords = _earthVocabulary.map((e) => e['word'] as String).toList();
    while (options.length < 4) {
      options.add(allWords[Random().nextInt(allWords.length)]);
    }
    return options.toList()..shuffle();
  }

  /// 🌍 PLANETS
  static final List<SpacePlanet> planets = [
    // =========================
    // LEVEL 1 – MERCURY
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
    // LEVEL 2 – VENUS ✅ RANDOM
    // Missing Letter
    // =========================
    SpacePlanet(
      id: 'venus',
      name: 'Venus',
      level: 2,
      skill: SpaceSkill.missingLetter,
      questions: _buildLevel2Questions(),
    ),

    // =========================
    // LEVEL 3 – EARTH
    // =========================
    SpacePlanet(
      id: 'earth',
      name: 'Earth',
      level: 3,
      skill: SpaceSkill.reading,
      questions: _buildLevel3Questions(),
    ),

    // LEVEL 4 – MARS ✅ RANDOM 8 CÂU
    // Skill: Scramble (Spelling Challenge)
    // =========================
    SpacePlanet(
      id: 'mars',
      name: 'Mars',
      level: 4,
      skill: SpaceSkill.scramble,
      questions: _buildLevel4Questions(),
    ),

    // =========================
    // LEVEL 5 – JUPITER
    // =========================
    SpacePlanet(
      id: 'jupiter',
      name: 'Jupiter',
      level: 5,
      skill: SpaceSkill.listening, // Tận dụng skill listening nhưng kết hợp bàn phím
      questions: _buildLevel5Questions(),
    ),

    // =========================
    // FINAL – SUN
    // =========================
    SpacePlanet(
      id: 'sun',
      name: 'Sun',
      level: 6,
      skill: SpaceSkill.matching, // Skill chính dùng để nhận diện Battle Mode
      questions: _buildLevel6Questions(),
    ),
  ];
}
