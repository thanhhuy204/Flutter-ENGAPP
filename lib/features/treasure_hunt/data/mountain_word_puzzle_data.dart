import '../domain/entities/challenge_question.dart';

class MountainWordPuzzleData {
  static List<MountainWordPuzzleQuestion> getQuestions() {
    return [
      MountainWordPuzzleQuestion(
        word: 'GOAT',
        hintTranslations: {
          'en': 'I have horns and climb steep rocks.',
          'ja': '角があって、急な岩を登ります。',
        },
        translations: {
          'en': 'Goat',
          'ja': 'ヤギ',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'BEAR',
        hintTranslations: {
          'en': 'I am big, furry and sleep in a cave.',
          'ja': '大きくて、毛むくじゃらで、洞窟で寝ます。',
        },
        translations: {
          'en': 'Bear',
          'ja': 'クマ',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'WOLF',
        hintTranslations: {
          'en': 'I look like a dog and howl at the moon.',
          'ja': '犬のように見えて、月に向かって遠吠えします。',
        },
        translations: {
          'en': 'Wolf',
          'ja': 'オオカミ',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'EAGLE',
        hintTranslations: {
          'en': 'I am a bird that flies high over mountains.',
          'ja': '山の上を高く飛ぶ鳥です。',
        },
        translations: {
          'en': 'Eagle',
          'ja': 'ワシ',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'FOX',
        hintTranslations: {
          'en': 'I have a bushy tail and live in the wild.',
          'ja': 'ふさふさの尻尾があって、野生に住んでいます。',
        },
        translations: {
          'en': 'Fox',
          'ja': 'キツネ',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'OWL',
        hintTranslations: {
          'en': 'I have big eyes and hoot at night.',
          'ja': '大きな目があって、夜に鳴きます。',
        },
        translations: {
          'en': 'Owl',
          'ja': 'フクロウ',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'ROCK',
        hintTranslations: {
          'en': 'I am hard and gray. Mountains are made of me.',
          'ja': '硬くて灰色です。山は私でできています。',
        },
        translations: {
          'en': 'Rock',
          'ja': '岩',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'SNOW',
        hintTranslations: {
          'en': 'I am white, cold and fall on peaks.',
          'ja': '白くて、冷たくて、山頂に降ります。',
        },
        translations: {
          'en': 'Snow',
          'ja': '雪',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'CAVE',
        hintTranslations: {
          'en': 'I am a dark hole in the mountain side.',
          'ja': '山の側面にある暗い穴です。',
        },
        translations: {
          'en': 'Cave',
          'ja': '洞窟',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'PINE',
        hintTranslations: {
          'en': 'I am a tall tree that stays green all year.',
          'ja': '一年中緑のままの高い木です。',
        },
        translations: {
          'en': 'Pine',
          'ja': '松',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'HILL',
        hintTranslations: {
          'en': 'I am smaller than a mountain.',
          'ja': '山より小さいです。',
        },
        translations: {
          'en': 'Hill',
          'ja': '丘',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'COLD',
        hintTranslations: {
          'en': 'The opposite of hot. Mountains are...',
          'ja': '暑いの反対。山は...',
        },
        translations: {
          'en': 'Cold',
          'ja': '寒い',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'HIGH',
        hintTranslations: {
          'en': 'Mountains are very...?',
          'ja': '山はとても...？',
        },
        translations: {
          'en': 'High',
          'ja': '高い',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'DEER',
        hintTranslations: {
          'en': 'I look like Bambi.',
          'ja': 'バンビのように見えます。',
        },
        translations: {
          'en': 'Deer',
          'ja': 'シカ',
        },
      ),
      MountainWordPuzzleQuestion(
        word: 'WIND',
        hintTranslations: {
          'en': 'I blow strongly on the mountain top.',
          'ja': '山頂で強く吹きます。',
        },
        translations: {
          'en': 'Wind',
          'ja': '風',
        },
      ),
    ];
  }
}
