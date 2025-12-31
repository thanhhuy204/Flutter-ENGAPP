import '../domain/entities/challenge_question.dart';

class OceanChooseImageData {
  static List<OceanChooseImageQuestion> getQuestions() {
    return [
      OceanChooseImageQuestion(
        riddleTranslations: {
          'en': 'I have sharp teeth and fins.\nI am a scary hunter in the deep sea.\nWho am I?',
          'ja': '鋭い歯とヒレがあります。\n深海の怖いハンターです。\n私は誰でしょう？',
        },
        options: [
          OceanChoiceOption(
            imagePath: 'assets/images/animals/shark.png',
            labelTranslations: {'en': 'Shark', 'ja': 'サメ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/dolphin.png',
            labelTranslations: {'en': 'Dolphin', 'ja': 'イルカ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/fish.png',
            labelTranslations: {'en': 'Fish', 'ja': '魚'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/whale.png',
            labelTranslations: {'en': 'Whale', 'ja': 'クジラ'},
          ),
        ],
        answerIndex: 0,
        translations: {'en': 'Shark', 'ja': 'サメ'},
      ),
      OceanChooseImageQuestion(
        riddleTranslations: {
          'en': 'I have 8 long arms.\nI can shoot ink to hide from enemies.\nWho am I?',
          'ja': '8本の長い腕があります。\n敵から隠れるために墨を吹けます。\n私は誰でしょう？',
        },
        options: [
          OceanChoiceOption(
            imagePath: 'assets/images/animals/crab.png',
            labelTranslations: {'en': 'Crab', 'ja': 'カニ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/fish.png',
            labelTranslations: {'en': 'Fish', 'ja': '魚'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/octopus.png',
            labelTranslations: {'en': 'Octopus', 'ja': 'タコ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/turtle.png',
            labelTranslations: {'en': 'Turtle', 'ja': 'カメ'},
          ),
        ],
        answerIndex: 2,
        translations: {'en': 'Octopus', 'ja': 'タコ'},
      ),
      OceanChooseImageQuestion(
        riddleTranslations: {
          'en': 'I have a hard shell on my back.\nI have claws and I walk sideways.\nWho am I?',
          'ja': '背中に硬い殻があります。\n爪があって、横に歩きます。\n私は誰でしょう？',
        },
        options: [
          OceanChoiceOption(
            imagePath: 'assets/images/animals/octopus.png',
            labelTranslations: {'en': 'Octopus', 'ja': 'タコ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/crab.png',
            labelTranslations: {'en': 'Crab', 'ja': 'カニ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/turtle.png',
            labelTranslations: {'en': 'Turtle', 'ja': 'カメ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/shark.png',
            labelTranslations: {'en': 'Shark', 'ja': 'サメ'},
          ),
        ],
        answerIndex: 1,
        translations: {'en': 'Crab', 'ja': 'カニ'},
      ),
      OceanChooseImageQuestion(
        riddleTranslations: {
          'en': 'I am very smart and friendly.\nI love to jump out of the water.\nWho am I?',
          'ja': 'とても賢くて友好的です。\n水から飛び出すのが大好きです。\n私は誰でしょう？',
        },
        options: [
          OceanChoiceOption(
            imagePath: 'assets/images/animals/shark.png',
            labelTranslations: {'en': 'Shark', 'ja': 'サメ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/whale.png',
            labelTranslations: {'en': 'Whale', 'ja': 'クジラ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/fish.png',
            labelTranslations: {'en': 'Fish', 'ja': '魚'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/dolphin.png',
            labelTranslations: {'en': 'Dolphin', 'ja': 'イルカ'},
          ),
        ],
        answerIndex: 3,
        translations: {'en': 'Dolphin', 'ja': 'イルカ'},
      ),
      OceanChooseImageQuestion(
        riddleTranslations: {
          'en': 'I am the biggest animal in the ocean.\nI can sing songs under the water.\nWho am I?',
          'ja': '海で一番大きな動物です。\n水中で歌を歌えます。\n私は誰でしょう？',
        },
        options: [
          OceanChoiceOption(
            imagePath: 'assets/images/animals/whale.png',
            labelTranslations: {'en': 'Whale', 'ja': 'クジラ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/shark.png',
            labelTranslations: {'en': 'Shark', 'ja': 'サメ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/dolphin.png',
            labelTranslations: {'en': 'Dolphin', 'ja': 'イルカ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/hippopotamus.png',
            labelTranslations: {'en': 'Hippo', 'ja': 'カバ'},
          ),
        ],
        answerIndex: 0,
        translations: {'en': 'Whale', 'ja': 'クジラ'},
      ),
      OceanChooseImageQuestion(
        riddleTranslations: {
          'en': 'I am a bird but I cannot fly.\nI love to swim in cold water.\nWho am I?',
          'ja': '鳥ですが飛べません。\n冷たい水で泳ぐのが大好きです。\n私は誰でしょう？',
        },
        options: [
          OceanChoiceOption(
            imagePath: 'assets/images/animals/duck.png',
            labelTranslations: {'en': 'Duck', 'ja': 'アヒル'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/parrot.png',
            labelTranslations: {'en': 'Parrot', 'ja': 'オウム'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/penguin.png',
            labelTranslations: {'en': 'Penguin', 'ja': 'ペンギン'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/owl.png',
            labelTranslations: {'en': 'Owl', 'ja': 'フクロウ'},
          ),
        ],
        answerIndex: 2,
        translations: {'en': 'Penguin', 'ja': 'ペンギン'},
      ),
      OceanChooseImageQuestion(
        riddleTranslations: {
          'en': 'I have scales and I swim in schools.\nI can breathe underwater.\nWho am I?',
          'ja': 'うろこがあって、群れで泳ぎます。\n水中で息ができます。\n私は誰でしょう？',
        },
        options: [
          OceanChoiceOption(
            imagePath: 'assets/images/animals/dolphin.png',
            labelTranslations: {'en': 'Dolphin', 'ja': 'イルカ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/fish.png',
            labelTranslations: {'en': 'Fish', 'ja': '魚'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/shark.png',
            labelTranslations: {'en': 'Shark', 'ja': 'サメ'},
          ),
          OceanChoiceOption(
            imagePath: 'assets/images/animals/turtle.png',
            labelTranslations: {'en': 'Turtle', 'ja': 'カメ'},
          ),
        ],
        answerIndex: 1,
        translations: {'en': 'Fish', 'ja': '魚'},
      ),
    ];
  }
}
