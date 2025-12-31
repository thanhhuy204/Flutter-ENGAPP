import '../domain/entities/challenge_question.dart';

class IslandQuizData {
  // Get all questions
  static List<IslandQuizQuestion> getQuestions() {
    return [
      ...getRound1Questions(),
      ...getRound2Questions(),
      ...getRound3Questions(),
      ...getRound4Questions(),
      ...getRound5Questions(),
    ];
  }
  
  // Get questions for specific round
  static List<IslandQuizQuestion> getQuestionsForRound(int round) {
    switch (round) {
      case 1:
        return getRound1Questions();
      case 2:
        return getRound2Questions();
      case 3:
        return getRound3Questions();
      case 4:
        return getRound4Questions();
      case 5:
        return getRound5Questions();
      default:
        return getRound1Questions();
    }
  }

  // ===== ROUND 1: ANIMAL IDENTIFICATION =====
  static List<IslandQuizQuestion> getRound1Questions() {
    return [
      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal is the king of the jungle?',
          'ja': 'ジャングルの王はどの動物ですか？',
        },
        options: [
          IslandQuizOption(text: 'Lion', imagePath: 'assets/images/animals/lion.png'),
          IslandQuizOption(text: 'Tiger', imagePath: 'assets/images/animals/tiger.png'),
          IslandQuizOption(text: 'Bear', imagePath: 'assets/images/animals/gorilla.png'),
          IslandQuizOption(text: 'Wolf', imagePath: 'assets/images/animals/fox.png'),
        ],
        answer: 'Lion',
        translations: {'en': 'Lion', 'ja': 'ライオン'},
      ),
      
      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal has a long neck?',
          'ja': '首が長い動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Giraffe', imagePath: 'assets/images/animals/giraffe.png'),
          IslandQuizOption(text: 'Elephant', imagePath: 'assets/images/animals/elephant.png'),
          IslandQuizOption(text: 'Horse', imagePath: 'assets/images/animals/horse.png'),
          IslandQuizOption(text: 'Zebra', imagePath: 'assets/images/animals/zebra.png'),
        ],
        answer: 'Giraffe',
        translations: {'en': 'Giraffe', 'ja': 'キリン'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal can fly?',
          'ja': '飛べる動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Parrot', imagePath: 'assets/images/animals/parrot.png'),
          IslandQuizOption(text: 'Penguin', imagePath: 'assets/images/animals/penguin.png'),
          IslandQuizOption(text: 'Chicken', imagePath: 'assets/images/animals/chicken.png'),
          IslandQuizOption(text: 'Ostrich', imagePath: 'assets/images/animals/ostrich.png'),
        ],
        answer: 'Parrot',
        translations: {'en': 'Parrot', 'ja': 'オウム'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal lives in water?',
          'ja': '水に住む動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Dolphin', imagePath: 'assets/images/animals/dolphin.png'),
          IslandQuizOption(text: 'Dog', imagePath: 'assets/images/animals/horse.png'),
          IslandQuizOption(text: 'Cat', imagePath: 'assets/images/animals/lion.png'),
          IslandQuizOption(text: 'Bird', imagePath: 'assets/images/animals/parrot.png'),
        ],
        answer: 'Dolphin',
        translations: {'en': 'Dolphin', 'ja': 'イルカ'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal has black and white stripes?',
          'ja': '白黒の縞模様の動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Zebra', imagePath: 'assets/images/animals/zebra.png'),
          IslandQuizOption(text: 'Horse', imagePath: 'assets/images/animals/horse.png'),
          IslandQuizOption(text: 'Deer', imagePath: 'assets/images/animals/deer.png'),
          IslandQuizOption(text: 'Goat', imagePath: 'assets/images/animals/goat.png'),
        ],
        answer: 'Zebra',
        translations: {'en': 'Zebra', 'ja': 'シマウマ'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal is very slow?',
          'ja': 'とても遅い動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Turtle', imagePath: 'assets/images/animals/turtle.png'),
          IslandQuizOption(text: 'Cheetah', imagePath: 'assets/images/animals/cheetah.png'),
          IslandQuizOption(text: 'Horse', imagePath: 'assets/images/animals/horse.png'),
          IslandQuizOption(text: 'Leopard', imagePath: 'assets/images/animals/leopard.png'),
        ],
        answer: 'Turtle',
        translations: {'en': 'Turtle', 'ja': 'カメ'},
      ),
    ];
  }

  // ===== ROUND 2: COLORS =====
  static List<IslandQuizQuestion> getRound2Questions() {
    return [
      IslandQuizQuestion(
        questionTranslations: {
          'en': 'What color is the sky on a sunny day?',
          'ja': '晴れた日の空の色は何色ですか？',
        },
        options: [
          IslandQuizOption(text: 'Blue', imagePath: 'assets/images/colors/Blue.png'),
          IslandQuizOption(text: 'Green', imagePath: 'assets/images/colors/Green.png'),
          IslandQuizOption(text: 'Red', imagePath: 'assets/images/colors/Red.png'),
          IslandQuizOption(text: 'Yellow', imagePath: 'assets/images/colors/Yellow.png'),
        ],
        answer: 'Blue',
        translations: {'en': 'Blue', 'ja': '青'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'What color is grass?',
          'ja': '草の色は何色ですか？',
        },
        options: [
          IslandQuizOption(text: 'Green', imagePath: 'assets/images/colors/Green.png'),
          IslandQuizOption(text: 'Brown', imagePath: 'assets/images/colors/Brown.png'),
          IslandQuizOption(text: 'Yellow', imagePath: 'assets/images/colors/Yellow.png'),
          IslandQuizOption(text: 'Orange', imagePath: 'assets/images/colors/Orange.png'),
        ],
        answer: 'Green',
        translations: {'en': 'Green', 'ja': '緑'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'What color is fire?',
          'ja': '火の色は何色ですか？',
        },
        options: [
          IslandQuizOption(text: 'Red', imagePath: 'assets/images/colors/Red.png'),
          IslandQuizOption(text: 'Blue', imagePath: 'assets/images/colors/Blue.png'),
          IslandQuizOption(text: 'Green', imagePath: 'assets/images/colors/Green.png'),
          IslandQuizOption(text: 'White', imagePath: 'assets/images/colors/White.png'),
        ],
        answer: 'Red',
        translations: {'en': 'Red', 'ja': '赤'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'What color is the sun?',
          'ja': '太陽の色は何色ですか？',
        },
        options: [
          IslandQuizOption(text: 'Yellow', imagePath: 'assets/images/colors/Yellow.png'),
          IslandQuizOption(text: 'Orange', imagePath: 'assets/images/colors/Orange.png'),
          IslandQuizOption(text: 'Red', imagePath: 'assets/images/colors/Red.png'),
          IslandQuizOption(text: 'White', imagePath: 'assets/images/colors/White.png'),
        ],
        answer: 'Yellow',
        translations: {'en': 'Yellow', 'ja': '黄色'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'What color is snow?',
          'ja': '雪の色は何色ですか？',
        },
        options: [
          IslandQuizOption(text: 'White', imagePath: 'assets/images/colors/White.png'),
          IslandQuizOption(text: 'Blue', imagePath: 'assets/images/colors/Blue.png'),
          IslandQuizOption(text: 'Gray', imagePath: 'assets/images/colors/Gray.png'),
          IslandQuizOption(text: 'Silver', imagePath: 'assets/images/colors/Silver.png'),
        ],
        answer: 'White',
        translations: {'en': 'White', 'ja': '白'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'What color is the night?',
          'ja': '夜の色は何色ですか？',
        },
        options: [
          IslandQuizOption(text: 'Black', imagePath: 'assets/images/colors/Black.png'),
          IslandQuizOption(text: 'Blue', imagePath: 'assets/images/colors/Blue.png'),
          IslandQuizOption(text: 'Purple', imagePath: 'assets/images/colors/Purple.png'),
          IslandQuizOption(text: 'Gray', imagePath: 'assets/images/colors/Gray.png'),
        ],
        answer: 'Black',
        translations: {'en': 'Black', 'ja': '黒'},
      ),
    ];
  }

  // ===== ROUND 3: FRUITS =====
  static List<IslandQuizQuestion> getRound3Questions() {
    return [
      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which fruit is yellow and curved?',
          'ja': '黄色くて曲がった果物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Banana', imagePath: 'assets/images/fruits/banana.png'),
          IslandQuizOption(text: 'Lemon', imagePath: 'assets/images/fruits/lemon.png'),
          IslandQuizOption(text: 'Mango', imagePath: 'assets/images/fruits/mango.png'),
          IslandQuizOption(text: 'Pineapple', imagePath: 'assets/images/fruits/pineapple.png'),
        ],
        answer: 'Banana',
        translations: {'en': 'Banana', 'ja': 'バナナ'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which fruit is red and has seeds on the outside?',
          'ja': '赤くて外に種がある果物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Strawberry', imagePath: 'assets/images/fruits/strawberry.png'),
          IslandQuizOption(text: 'Cherry', imagePath: 'assets/images/fruits/cherry.png'),
          IslandQuizOption(text: 'Apple', imagePath: 'assets/images/fruits/apple.png'),
          IslandQuizOption(text: 'Watermelon', imagePath: 'assets/images/fruits/watermelon.png'),
        ],
        answer: 'Strawberry',
        translations: {'en': 'Strawberry', 'ja': 'イチゴ'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which fruit is orange and round?',
          'ja': 'オレンジ色で丸い果物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Orange', imagePath: 'assets/images/fruits/orange.png'),
          IslandQuizOption(text: 'Apple', imagePath: 'assets/images/fruits/apple.png'),
          IslandQuizOption(text: 'Peach', imagePath: 'assets/images/fruits/peach.png'),
          IslandQuizOption(text: 'Lemon', imagePath: 'assets/images/fruits/lemon.png'),
        ],
        answer: 'Orange',
        translations: {'en': 'Orange', 'ja': 'オレンジ'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which fruit is big, green outside and red inside?',
          'ja': '大きくて外が緑、中が赤い果物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Watermelon', imagePath: 'assets/images/fruits/watermelon.png'),
          IslandQuizOption(text: 'Apple', imagePath: 'assets/images/fruits/apple.png'),
          IslandQuizOption(text: 'Guava', imagePath: 'assets/images/fruits/guava.png'),
          IslandQuizOption(text: 'Avocado', imagePath: 'assets/images/fruits/avocado.png'),
        ],
        answer: 'Watermelon',
        translations: {'en': 'Watermelon', 'ja': 'スイカ'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which fruit has a crown on top?',
          'ja': '上に王冠がある果物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Pineapple', imagePath: 'assets/images/fruits/pineapple.png'),
          IslandQuizOption(text: 'Strawberry', imagePath: 'assets/images/fruits/strawberry.png'),
          IslandQuizOption(text: 'Mango', imagePath: 'assets/images/fruits/mango.png'),
          IslandQuizOption(text: 'Papaya', imagePath: 'assets/images/fruits/papaya.png'),
        ],
        answer: 'Pineapple',
        translations: {'en': 'Pineapple', 'ja': 'パイナップル'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which fruit is sour and yellow?',
          'ja': '酸っぱくて黄色い果物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Lemon', imagePath: 'assets/images/fruits/lemon.png'),
          IslandQuizOption(text: 'Banana', imagePath: 'assets/images/fruits/banana.png'),
          IslandQuizOption(text: 'Mango', imagePath: 'assets/images/fruits/mango.png'),
          IslandQuizOption(text: 'Peach', imagePath: 'assets/images/fruits/peach.png'),
        ],
        answer: 'Lemon',
        translations: {'en': 'Lemon', 'ja': 'レモン'},
      ),
    ];
  }

  // ===== ROUND 4: MIXED ANIMALS & NATURE =====
  static List<IslandQuizQuestion> getRound4Questions() {
    return [
      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal has 8 legs?',
          'ja': '8本足の動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Octopus', imagePath: 'assets/images/animals/octopus.png'),
          IslandQuizOption(text: 'Crab', imagePath: 'assets/images/animals/crab.png'),
          IslandQuizOption(text: 'Turtle', imagePath: 'assets/images/animals/turtle.png'),
          IslandQuizOption(text: 'Fish', imagePath: 'assets/images/animals/fish.png'),
        ],
        answer: 'Octopus',
        translations: {'en': 'Octopus', 'ja': 'タコ'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which fruit is hairy outside?',
          'ja': '外が毛深い果物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Coconut', imagePath: 'assets/images/fruits/coconut.png'),
          IslandQuizOption(text: 'Mango', imagePath: 'assets/images/fruits/mango.png'),
          IslandQuizOption(text: 'Papaya', imagePath: 'assets/images/fruits/papaya.png'),
          IslandQuizOption(text: 'Pineapple', imagePath: 'assets/images/fruits/pineapple.png'),
        ],
        answer: 'Coconut',
        translations: {'en': 'Coconut', 'ja': 'ココナッツ'},
      ),
    ];
  }

  // ===== ROUND 5: FINAL BOSS - HARDEST QUESTIONS =====
  static List<IslandQuizQuestion> getRound5Questions() {
    return [
      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal roars the loudest?',
          'ja': '一番大きく吠える動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Lion', imagePath: 'assets/images/animals/lion.png'),
          IslandQuizOption(text: 'Tiger', imagePath: 'assets/images/animals/tiger.png'),
          IslandQuizOption(text: 'Bear', imagePath: 'assets/images/animals/gorilla.png'),
          IslandQuizOption(text: 'Elephant', imagePath: 'assets/images/animals/elephant.png'),
        ],
        answer: 'Lion',
        translations: {'en': 'Lion', 'ja': 'ライオン'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal has the longest nose?',
          'ja': '一番長い鼻を持つ動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Elephant', imagePath: 'assets/images/animals/elephant.png'),
          IslandQuizOption(text: 'Rhinoceros', imagePath: 'assets/images/animals/rhinoceros.png'),
          IslandQuizOption(text: 'Hippopotamus', imagePath: 'assets/images/animals/hippopotamus.png'),
          IslandQuizOption(text: 'Buffalo', imagePath: 'assets/images/animals/buffalo.png'),
        ],
        answer: 'Elephant',
        translations: {'en': 'Elephant', 'ja': 'ゾウ'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal has spots on its body?',
          'ja': '体に斑点がある動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Leopard', imagePath: 'assets/images/animals/leopard.png'),
          IslandQuizOption(text: 'Tiger', imagePath: 'assets/images/animals/tiger.png'),
          IslandQuizOption(text: 'Zebra', imagePath: 'assets/images/animals/zebra.png'),
          IslandQuizOption(text: 'Lion', imagePath: 'assets/images/animals/lion.png'),
        ],
        answer: 'Leopard',
        translations: {'en': 'Leopard', 'ja': 'ヒョウ'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal lives in the desert?',
          'ja': '砂漠に住む動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Camel', imagePath: 'assets/images/animals/camel.png'),
          IslandQuizOption(text: 'Horse', imagePath: 'assets/images/animals/horse.png'),
          IslandQuizOption(text: 'Cow', imagePath: 'assets/images/animals/ox.png'),
          IslandQuizOption(text: 'Goat', imagePath: 'assets/images/animals/goat.png'),
        ],
        answer: 'Camel',
        translations: {'en': 'Camel', 'ja': 'ラクダ'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which bird cannot fly but can swim?',
          'ja': '飛べないが泳げる鳥はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Penguin', imagePath: 'assets/images/animals/penguin.png'),
          IslandQuizOption(text: 'Duck', imagePath: 'assets/images/animals/duck.png'),
          IslandQuizOption(text: 'Ostrich', imagePath: 'assets/images/animals/ostrich.png'),
          IslandQuizOption(text: 'Chicken', imagePath: 'assets/images/animals/chicken.png'),
        ],
        answer: 'Penguin',
        translations: {'en': 'Penguin', 'ja': 'ペンギン'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal jumps the highest?',
          'ja': '一番高くジャンプする動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Kangaroo', imagePath: 'assets/images/animals/kangaroo.png'),
          IslandQuizOption(text: 'Deer', imagePath: 'assets/images/animals/deer.png'),
          IslandQuizOption(text: 'Horse', imagePath: 'assets/images/animals/horse.png'),
          IslandQuizOption(text: 'Goat', imagePath: 'assets/images/animals/goat.png'),
        ],
        answer: 'Kangaroo',
        translations: {'en': 'Kangaroo', 'ja': 'カンガルー'},
      ),

      IslandQuizQuestion(
        questionTranslations: {
          'en': 'Which animal is fastest on land?',
          'ja': '陸で一番速い動物はどれですか？',
        },
        options: [
          IslandQuizOption(text: 'Cheetah', imagePath: 'assets/images/animals/cheetah.png'),
          IslandQuizOption(text: 'Lion', imagePath: 'assets/images/animals/lion.png'),
          IslandQuizOption(text: 'Tiger', imagePath: 'assets/images/animals/tiger.png'),
          IslandQuizOption(text: 'Leopard', imagePath: 'assets/images/animals/leopard.png'),
        ],
        answer: 'Cheetah',
        translations: {'en': 'Cheetah', 'ja': 'チーター'},
      ),
    ];
  }
}
