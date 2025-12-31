import '../domain/entities/challenge_question.dart';

class DesertFillBlankData {
  static List<DesertFillBlankQuestion> getQuestions() {
    return [
      DesertFillBlankQuestion(
        word: 'CAMEL',
        questionPattern: 'C_MEL',
        answer: 'A',
        hintTranslations: {
          'en': 'I have humps and I can walk on sand.',
          'ja': 'こぶがあって、砂の上を歩けます。',
        },
        translations: {
          'en': 'Camel',
          'ja': 'ラクダ',
        },
      ),
      DesertFillBlankQuestion(
        word: 'SUN',
        questionPattern: 'S_N',
        answer: 'U',
        hintTranslations: {
          'en': 'I am very hot and shine in the sky.',
          'ja': 'とても熱くて、空で輝いています。',
        },
        translations: {
          'en': 'Sun',
          'ja': '太陽',
        },
      ),
      DesertFillBlankQuestion(
        word: 'SAND',
        questionPattern: 'S_ND',
        answer: 'A',
        hintTranslations: {
          'en': 'The desert is full of this yellow dust.',
          'ja': '砂漠はこの黄色い粉でいっぱいです。',
        },
        translations: {
          'en': 'Sand',
          'ja': '砂',
        },
      ),
      DesertFillBlankQuestion(
        word: 'CACTUS',
        questionPattern: 'CA_TUS',
        answer: 'C',
        hintTranslations: {
          'en': 'I am a green plant with sharp spikes.',
          'ja': '鋭いトゲがある緑の植物です。',
        },
        translations: {
          'en': 'Cactus',
          'ja': 'サボテン',
        },
      ),
      DesertFillBlankQuestion(
        word: 'SNAKE',
        questionPattern: 'SNA_E',
        answer: 'K',
        hintTranslations: {
          'en': 'I have no legs and I say "Hiss".',
          'ja': '足がなくて、「シー」と言います。',
        },
        translations: {
          'en': 'Snake',
          'ja': 'ヘビ',
        },
      ),
      DesertFillBlankQuestion(
        word: 'FOX',
        questionPattern: 'F_X',
        answer: 'O',
        hintTranslations: {
          'en': 'I am a small animal with very big ears.',
          'ja': 'とても大きな耳を持つ小さな動物です。',
        },
        translations: {
          'en': 'Fox',
          'ja': 'キツネ',
        },
      ),
      DesertFillBlankQuestion(
        word: 'HOT',
        questionPattern: 'H_T',
        answer: 'O',
        hintTranslations: {
          'en': 'The weather in the desert is very...?',
          'ja': '砂漠の天気はとても...？',
        },
        translations: {
          'en': 'Hot',
          'ja': '暑い',
        },
      ),
      DesertFillBlankQuestion(
        word: 'PALM',
        questionPattern: 'P_LM',
        answer: 'A',
        hintTranslations: {
          'en': 'A tall tree that grows near water.',
          'ja': '水の近くに育つ高い木。',
        },
        translations: {
          'en': 'Palm',
          'ja': 'ヤシの木',
        },
      ),
      DesertFillBlankQuestion(
        word: 'WATER',
        questionPattern: 'WA_ER',
        answer: 'T',
        hintTranslations: {
          'en': 'You must drink me when you are thirsty.',
          'ja': '喉が渇いたら私を飲まなければなりません。',
        },
        translations: {
          'en': 'Water',
          'ja': '水',
        },
      ),
      DesertFillBlankQuestion(
        word: 'OASIS',
        questionPattern: 'OAS_S',
        answer: 'I',
        hintTranslations: {
          'en': 'A place with water in the desert.',
          'ja': '砂漠の中の水がある場所。',
        },
        translations: {
          'en': 'Oasis',
          'ja': 'オアシス',
        },
      ),
      DesertFillBlankQuestion(
        word: 'DRY',
        questionPattern: 'D_Y',
        answer: 'R',
        hintTranslations: {
          'en': 'The desert is not wet, it is...',
          'ja': '砂漠は濡れていない、それは...',
        },
        translations: {
          'en': 'Dry',
          'ja': '乾いた',
        },
      ),
      DesertFillBlankQuestion(
        word: 'DUNE',
        questionPattern: 'D_NE',
        answer: 'U',
        hintTranslations: {
          'en': 'A hill made of sand.',
          'ja': '砂でできた丘。',
        },
        translations: {
          'en': 'Dune',
          'ja': '砂丘',
        },
      ),
      DesertFillBlankQuestion(
        word: 'GOLD',
        questionPattern: 'G_LD',
        answer: 'O',
        hintTranslations: {
          'en': 'A shiny yellow treasure.',
          'ja': '輝く黄色い宝物。',
        },
        translations: {
          'en': 'Gold',
          'ja': '金',
        },
      ),
      DesertFillBlankQuestion(
        word: 'TENT',
        questionPattern: 'TE_T',
        answer: 'N',
        hintTranslations: {
          'en': 'You sleep in this when camping.',
          'ja': 'キャンプの時、この中で寝ます。',
        },
        translations: {
          'en': 'Tent',
          'ja': 'テント',
        },
      ),
      DesertFillBlankQuestion(
        word: 'SKY',
        questionPattern: 'S_Y',
        answer: 'K',
        hintTranslations: {
          'en': 'It is blue and above your head.',
          'ja': '青くて、頭の上にあります。',
        },
        translations: {
          'en': 'Sky',
          'ja': '空',
        },
      ),
    ];
  }
}
