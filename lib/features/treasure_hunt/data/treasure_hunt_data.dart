// Dữ liệu cho tất cả minigame Treasure Hunt
// Đã thêm trường tiếng Nhật song song với tiếng Anh

class TreasureHuntData {
  // --- JUNGLE (Nghe & Chọn) ---
  static const List<Map<String, dynamic>> jungleQuestions = [
    {
      'word': 'Monkey',
      'word_ja': 'サル',
      'options': [
        'assets/images/animals/monkey.png',
        'assets/images/animals/lion.png',
        'assets/images/animals/elephant.png',
        'assets/images/animals/zebra.png',
      ],
      'answer': 0,
    },
    {
      'word': 'Tiger',
      'word_ja': 'トラ',
      'options': [
        'assets/images/animals/giraffe.png',
        'assets/images/animals/tiger.png',
        'assets/images/animals/fox.png',
        'assets/images/animals/deer.png',
      ],
      'answer': 1,
    },
    {
      'word': 'Lion',
      'word_ja': 'ライオン',
      'options': [
        'assets/images/animals/zebra.png',
        'assets/images/animals/lion.png',
        'assets/images/animals/monkey.png',
        'assets/images/animals/parrot.png',
      ],
      'answer': 1,
    },
    {
      'word': 'Elephant',
      'word_ja': 'ゾウ',
      'options': [
        'assets/images/animals/tiger.png',
        'assets/images/animals/fox.png',
        'assets/images/animals/elephant.png',
        'assets/images/animals/squirrel.png',
      ],
      'answer': 2,
    },
    {
      'word': 'Giraffe',
      'word_ja': 'キリン',
      'options': [
        'assets/images/animals/lion.png',
        'assets/images/animals/giraffe.png',
        'assets/images/animals/monkey.png',
        'assets/images/animals/duck.png',
      ],
      'answer': 1,
    },
    {
      'word': 'Hippo',
      'word_ja': 'カバ',
      'options': [
        'assets/images/animals/hippopotamus.png',
        'assets/images/animals/rhinoceros.png',
        'assets/images/animals/buffalo.png',
        'assets/images/animals/ox.png',
      ],
      'answer': 0,
    },
    {
      'word': 'Zebra',
      'word_ja': 'シマウマ',
      'options': [
        'assets/images/animals/horse.png',
        'assets/images/animals/zebra.png',
        'assets/images/animals/donkey.png',
        'assets/images/animals/deer.png',
      ],
      'answer': 1,
    },
    {
      'word': 'Ostrich',
      'word_ja': 'ダチョウ',
      'options': [
        'assets/images/animals/chicken.png',
        'assets/images/animals/duck.png',
        'assets/images/animals/ostrich.png',
        'assets/images/animals/owl.png',
      ],
      'answer': 2,
    },
  ];

  // --- MOUNTAIN (Sắp xếp từ) ---
  static const List<Map<String, String>> mountainQuestions = [
    {'word': 'GOAT', 'word_ja': 'ヤギ', 'hint': 'I have horns and climb steep rocks.', 'hint_ja': '私は角があり、険しい岩を登ります。'},
    {'word': 'BEAR', 'word_ja': 'クマ', 'hint': 'I am big, furry and sleep in a cave.', 'hint_ja': '私は大きくて毛皮があり、洞窟で眠ります。'},
    {'word': 'WOLF', 'word_ja': 'オオカミ', 'hint': 'I look like a dog and howl at the moon.', 'hint_ja': '私は犬に似ていて、月に向かって吠えます。'},
    {'word': 'EAGLE', 'word_ja': 'ワシ', 'hint': 'I am a bird that flies high over mountains.', 'hint_ja': '私は山の上空を高く飛ぶ鳥です。'},
    {'word': 'FOX', 'word_ja': 'キツネ', 'hint': 'I have a bushy tail and live in the wild.', 'hint_ja': '私はふさふさした尻尾を持ち、野生に住んでいます。'},
    {'word': 'OWL', 'word_ja': 'フクロウ', 'hint': 'I have big eyes and hoot at night.', 'hint_ja': '私は大きな目を持ち、夜にホーホーと鳴きます。'},
    {'word': 'ROCK', 'word_ja': '岩', 'hint': 'I am hard and gray. Mountains are made of me.', 'hint_ja': '私は硬くて灰色です。山は私でできています。'},
    {'word': 'SNOW', 'word_ja': '雪', 'hint': 'I am white, cold and fall on peaks.', 'hint_ja': '私は白くて冷たく、山頂に降ります。'},
    {'word': 'CAVE', 'word_ja': '洞窟', 'hint': 'I am a dark hole in the mountain side.', 'hint_ja': '私は山の側面にある暗い穴です。'},
    {'word': 'PINE', 'word_ja': 'マツ', 'hint': 'I am a tall tree that stays green all year.', 'hint_ja': '私は一年中緑の高い木です。'},
    {'word': 'HILL', 'word_ja': '丘', 'hint': 'I am smaller than a mountain.', 'hint_ja': '私は山より小さいです。'},
    {'word': 'COLD', 'word_ja': '寒い', 'hint': 'The opposite of hot. Mountains are...', 'hint_ja': '「熱い」の反対。山は...'},
    {'word': 'HIGH', 'word_ja': '高い', 'hint': 'Mountains are very...?', 'hint_ja': '山はとても...？'},
    {'word': 'DEER', 'word_ja': 'シカ', 'hint': 'I look like Bambi.', 'hint_ja': '私はバンビのようです。'},
    {'word': 'WIND', 'word_ja': '風', 'hint': 'I blow strongly on the mountain top.', 'hint_ja': '私は山頂で強く吹きます。'},
  ];

  // --- DESERT (Điền từ khuyết) ---
  static const List<Map<String, String>> desertQuestions = [
    {'word': 'CAMEL', 'word_ja': 'ラクダ', 'question': 'C_MEL', 'question_ja': 'C_MEL', 'answer': 'A', 'hint': 'I have humps and I can walk on sand.', 'hint_ja': '私にはコブがあり、砂の上を歩けます。'},
    {'word': 'SUN', 'word_ja': '太陽', 'question': 'S_N', 'question_ja': 'S_N', 'answer': 'U', 'hint': 'I am very hot and shine in the sky.', 'hint_ja': '私はとても熱く、空で輝いています。'},
    {'word': 'SAND', 'word_ja': '砂', 'question': 'S_ND', 'question_ja': 'S_ND', 'answer': 'A', 'hint': 'The desert is full of this yellow dust.', 'hint_ja': '砂漠はこの黄色い粉でいっぱいです。'},
    {'word': 'CACTUS', 'word_ja': 'サボテン', 'question': 'CA_TUS', 'question_ja': 'CA_TUS', 'answer': 'C', 'hint': 'I am a green plant with sharp spikes.', 'hint_ja': '私は鋭いトゲのある緑色の植物です。'},
    {'word': 'SNAKE', 'word_ja': 'ヘビ', 'question': 'SNA_E', 'question_ja': 'SNA_E', 'answer': 'K', 'hint': 'I have no legs and I say "Hiss".', 'hint_ja': '私には足がなく、「シュー」と音を立てます。'},
    {'word': 'FOX', 'word_ja': 'キツネ', 'question': 'F_X', 'question_ja': 'F_X', 'answer': 'O', 'hint': 'I am a small animal with very big ears.', 'hint_ja': '私はとても大きな耳を持つ小さな動物です。'},
    {'word': 'HOT', 'word_ja': '暑い', 'question': 'H_T', 'question_ja': 'H_T', 'answer': 'O', 'hint': 'The weather in the desert is very...?', 'hint_ja': '砂漠の天気はとても...？'},
    {'word': 'PALM', 'word_ja': 'ヤシ', 'question': 'P_LM', 'question_ja': 'P_LM', 'answer': 'A', 'hint': 'A tall tree that grows near water.', 'hint_ja': '水の近くに生える高い木です。'},
    {'word': 'WATER', 'word_ja': '水', 'question': 'WA_ER', 'question_ja': 'WA_ER', 'answer': 'T', 'hint': 'You must drink me when you are thirsty.', 'hint_ja': '喉が渇いたときに私を飲まなければなりません。'},
    {'word': 'OASIS', 'word_ja': 'オアシス', 'question': 'OAS_S', 'question_ja': 'OAS_S', 'answer': 'I', 'hint': 'A place with water in the desert.', 'hint_ja': '砂漠の中の水のある場所です。'},
    {'word': 'DRY', 'word_ja': '乾燥', 'question': 'D_Y', 'question_ja': 'D_Y', 'answer': 'R', 'hint': 'The desert is not wet, it is...', 'hint_ja': '砂漠は濡れていません、それは...です。'},
    {'word': 'DUNE', 'word_ja': '砂丘', 'question': 'D_NE', 'question_ja': 'D_NE', 'answer': 'U', 'hint': 'A hill made of sand.', 'hint_ja': '砂でできた丘です。'},
    {'word': 'GOLD', 'word_ja': '金', 'question': 'G_LD', 'question_ja': 'G_LD', 'answer': 'O', 'hint': 'A shiny yellow treasure.', 'hint_ja': '輝く黄色い宝物です。'},
    {'word': 'TENT', 'word_ja': 'テント', 'question': 'TE_T', 'question_ja': 'TE_T', 'answer': 'N', 'hint': 'You sleep in this when camping.', 'hint_ja': 'キャンプのときにこれで寝ます。'},
    {'word': 'SKY', 'word_ja': '空', 'question': 'S_Y', 'question_ja': 'S_Y', 'answer': 'K', 'hint': 'It is blue and above your head.', 'hint_ja': 'それは青くてあなたの頭の上にあります。'},
  ];

  // --- OCEAN (Câu đố Riddle) ---
  static const List<Map<String, dynamic>> oceanQuestions = [
    {
      'riddle': 'I have sharp teeth and fins.\nI am a scary hunter in the deep sea.\nWho am I?',
      'riddle_ja': '私には鋭い歯とヒレがあります。\n私は深海の怖いハンターです。\n私は誰でしょう？',
      'answer_index': 0,
      'options': [
        {'image': 'assets/images/animals/shark.png', 'label': 'Shark', 'label_ja': 'サメ'},
        {'image': 'assets/images/animals/dolphin.png', 'label': 'Dolphin', 'label_ja': 'イルカ'},
        {'image': 'assets/images/animals/fish.png', 'label': 'Fish', 'label_ja': '魚'},
        {'image': 'assets/images/animals/whale.png', 'label': 'Whale', 'label_ja': 'クジラ'},
      ]
    },
    {
      'riddle': 'I have 8 long arms.\nI can shoot ink to hide from enemies.\nWho am I?',
      'riddle_ja': '私には8本の長い腕があります。\n敵から隠れるために墨を吐きます。\n私は誰でしょう？',
      'answer_index': 2,
      'options': [
        {'image': 'assets/images/animals/crab.png', 'label': 'Crab', 'label_ja': 'カニ'},
        {'image': 'assets/images/animals/fish.png', 'label': 'Fish', 'label_ja': '魚'},
        {'image': 'assets/images/animals/octopus.png', 'label': 'Octopus', 'label_ja': 'タコ'},
        {'image': 'assets/images/animals/turtle.png', 'label': 'Turtle', 'label_ja': 'カメ'},
      ]
    },
    {
      'riddle': 'I have a hard shell on my back.\nI have claws and I walk sideways.\nWho am I?',
      'riddle_ja': '私は背中に硬い殻があります。\nハサミがあり、横に歩きます。\n私は誰でしょう？',
      'answer_index': 1,
      'options': [
        {'image': 'assets/images/animals/octopus.png', 'label': 'Octopus', 'label_ja': 'タコ'},
        {'image': 'assets/images/animals/crab.png', 'label': 'Crab', 'label_ja': 'カニ'},
        {'image': 'assets/images/animals/turtle.png', 'label': 'Turtle', 'label_ja': 'カメ'},
        {'image': 'assets/images/animals/shark.png', 'label': 'Shark', 'label_ja': 'サメ'},
      ]
    },
    {
      'riddle': 'I am very smart and friendly.\nI love to jump out of the water.\nWho am I?',
      'riddle_ja': '私はとても賢くてフレンドリーです。\n水からジャンプするのが大好きです。\n私は誰でしょう？',
      'answer_index': 3,
      'options': [
        {'image': 'assets/images/animals/shark.png', 'label': 'Shark', 'label_ja': 'サメ'},
        {'image': 'assets/images/animals/whale.png', 'label': 'Whale', 'label_ja': 'クジラ'},
        {'image': 'assets/images/animals/fish.png', 'label': 'Fish', 'label_ja': '魚'},
        {'image': 'assets/images/animals/dolphin.png', 'label': 'Dolphin', 'label_ja': 'イルカ'},
      ]
    },
    {
      'riddle': 'I am the biggest animal in the ocean.\nI can sing songs under the water.\nWho am I?',
      'riddle_ja': '私は海で一番大きな動物です。\n水中で歌を歌うことができます。\n私は誰でしょう？',
      'answer_index': 0,
      'options': [
        {'image': 'assets/images/animals/whale.png', 'label': 'Whale', 'label_ja': 'クジラ'},
        {'image': 'assets/images/animals/shark.png', 'label': 'Shark', 'label_ja': 'サメ'},
        {'image': 'assets/images/animals/dolphin.png', 'label': 'Dolphin', 'label_ja': 'イルカ'},
        {'image': 'assets/images/animals/hippopotamus.png', 'label': 'Hippo', 'label_ja': 'カバ'},
      ]
    },
  ];
}