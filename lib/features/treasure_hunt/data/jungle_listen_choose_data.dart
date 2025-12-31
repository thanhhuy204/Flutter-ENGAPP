import '../domain/entities/challenge_question.dart';

class JungleListenChooseData {
  static List<JungleListenChooseQuestion> getQuestions() {
    return [
      JungleListenChooseQuestion(
        word: 'Monkey',
        imagePaths: [
          'assets/images/animals/monkey.png',
          'assets/images/animals/lion.png',
          'assets/images/animals/elephant.png',
          'assets/images/animals/zebra.png',
        ],
        answerIndex: 0,
        translations: {
          'en': 'Monkey',
          'ja': 'サル',
        },
      ),
      JungleListenChooseQuestion(
        word: 'Tiger',
        imagePaths: [
          'assets/images/animals/giraffe.png',
          'assets/images/animals/tiger.png',
          'assets/images/animals/fox.png',
          'assets/images/animals/deer.png',
        ],
        answerIndex: 1,
        translations: {
          'en': 'Tiger',
          'ja': 'トラ',
        },
      ),
      JungleListenChooseQuestion(
        word: 'Lion',
        imagePaths: [
          'assets/images/animals/zebra.png',
          'assets/images/animals/lion.png',
          'assets/images/animals/monkey.png',
          'assets/images/animals/parrot.png',
        ],
        answerIndex: 1,
        translations: {
          'en': 'Lion',
          'ja': 'ライオン',
        },
      ),
      JungleListenChooseQuestion(
        word: 'Elephant',
        imagePaths: [
          'assets/images/animals/tiger.png',
          'assets/images/animals/fox.png',
          'assets/images/animals/elephant.png',
          'assets/images/animals/squirrel.png',
        ],
        answerIndex: 2,
        translations: {
          'en': 'Elephant',
          'ja': 'ゾウ',
        },
      ),
      JungleListenChooseQuestion(
        word: 'Giraffe',
        imagePaths: [
          'assets/images/animals/lion.png',
          'assets/images/animals/giraffe.png',
          'assets/images/animals/monkey.png',
          'assets/images/animals/duck.png',
        ],
        answerIndex: 1,
        translations: {
          'en': 'Giraffe',
          'ja': 'キリン',
        },
      ),
      JungleListenChooseQuestion(
        word: 'Hippo',
        imagePaths: [
          'assets/images/animals/hippopotamus.png',
          'assets/images/animals/rhinoceros.png',
          'assets/images/animals/buffalo.png',
          'assets/images/animals/ox.png',
        ],
        answerIndex: 0,
        translations: {
          'en': 'Hippo',
          'ja': 'カバ',
        },
      ),
      JungleListenChooseQuestion(
        word: 'Zebra',
        imagePaths: [
          'assets/images/animals/horse.png',
          'assets/images/animals/zebra.png',
          'assets/images/animals/deer.png',
          'assets/images/animals/deer.png',
        ],
        answerIndex: 1,
        translations: {
          'en': 'Zebra',
          'ja': 'シマウマ',
        },
      ),
      JungleListenChooseQuestion(
        word: 'Ostrich',
        imagePaths: [
          'assets/images/animals/chicken.png',
          'assets/images/animals/duck.png',
          'assets/images/animals/ostrich.png',
          'assets/images/animals/owl.png',
        ],
        answerIndex: 2,
        translations: {
          'en': 'Ostrich',
          'ja': 'ダチョウ',
        },
      ),
    ];
  }
}
