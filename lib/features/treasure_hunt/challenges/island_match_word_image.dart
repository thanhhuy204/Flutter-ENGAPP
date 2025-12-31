import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class IslandMatchWordImage extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const IslandMatchWordImage({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<IslandMatchWordImage> createState() => _IslandMatchWordImageState();
}

class _IslandMatchWordImageState extends State<IslandMatchWordImage> with SingleTickerProviderStateMixin {
  final AudioPlayer bgmPlayer = AudioPlayer();
  final AudioPlayer sfxPlayer = AudioPlayer();
  late AnimationController _shakeController;

  // --- TRẠNG THÁI GAME ---
  int currentRound = 1;
  int maxRounds = 5;
  late int maxHP;
  late int currentHP;
  late String bossImage;

  bool isWrongAnim = false;
  bool isHealingAnim = false;
  bool isRoundVictory = false;
  bool isGameCompleted = false;

  late Map<String, dynamic> currentQuestion;
  final Random _random = Random();

  // Danh sách lưu các index câu hỏi đã xuất hiện để không lặp lại
  List<int> usedQuestionIndices = [];

  // --- KHO CÂU HỎI TIẾNG ANH (Không Toán, Image chỉ hiện ảnh) ---
  final List<Map<String, dynamic>> questionPool = [
    // --- ANIMALS (Động vật) ---
    {'type': 'quiz', 'q': 'Which animal is the King of the Jungle?', 'opts': ['Lion', 'Tiger', 'Cat', 'Dog'], 'a': 'Lion'},
    {'type': 'quiz', 'q': 'Which animal gives us milk?', 'opts': ['Cow', 'Dog', 'Cat', 'Bird'], 'a': 'Cow'},
    {'type': 'quiz', 'q': 'Which bird cannot fly?', 'opts': ['Penguin', 'Parrot', 'Eagle', 'Owl'], 'a': 'Penguin'},
    {'type': 'quiz', 'q': 'I have a long neck. Who am I?', 'opts': ['Giraffe', 'Elephant', 'Hippo', 'Lion'], 'a': 'Giraffe'},
    {'type': 'quiz', 'q': 'I love to eat bananas.', 'opts': ['Monkey', 'Tiger', 'Shark', 'Zebra'], 'a': 'Monkey'},
    {'type': 'quiz', 'q': 'I am big and gray with a long nose.', 'opts': ['Elephant', 'Mouse', 'Cat', 'Ant'], 'a': 'Elephant'},

    // --- COLORS (Màu sắc) ---
    {'type': 'quiz', 'q': 'What color is a strawberry?', 'opts': ['Red', 'Blue', 'Yellow', 'Green'], 'a': 'Red'},
    {'type': 'quiz', 'q': 'What color is the sky?', 'opts': ['Blue', 'Green', 'Red', 'Yellow'], 'a': 'Blue'},
    {'type': 'quiz', 'q': 'What color is a banana?', 'opts': ['Yellow', 'Purple', 'Pink', 'Black'], 'a': 'Yellow'},
    {'type': 'quiz', 'q': 'What color is grass?', 'opts': ['Green', 'Red', 'Blue', 'Orange'], 'a': 'Green'},
    {'type': 'quiz', 'q': 'Color of the night sky?', 'opts': ['Black', 'White', 'Pink', 'Orange'], 'a': 'Black'},

    // --- FRUITS & FOOD (Trái cây & Đồ ăn) ---
    {'type': 'quiz', 'q': 'Which one is a fruit?', 'opts': ['Apple', 'Carrot', 'Potato', 'Onion'], 'a': 'Apple'},
    {'type': 'quiz', 'q': 'I am yellow and sour.', 'opts': ['Lemon', 'Apple', 'Grape', 'Banana'], 'a': 'Lemon'},
    {'type': 'quiz', 'q': 'Rabbits love to eat...', 'opts': ['Carrots', 'Pizza', 'Fish', 'Candy'], 'a': 'Carrots'},

    // --- OPPOSITES & GENERAL (Đối lập & Tổng hợp) ---
    {'type': 'quiz', 'q': 'Opposite of HOT is...', 'opts': ['Cold', 'Warm', 'Fire', 'Sun'], 'a': 'Cold'},
    {'type': 'quiz', 'q': 'Opposite of BIG is...', 'opts': ['Small', 'Tall', 'Fat', 'Huge'], 'a': 'Small'},
    {'type': 'quiz', 'q': 'Opposite of UP is...', 'opts': ['Down', 'Left', 'Right', 'Top'], 'a': 'Down'},
    {'type': 'quiz', 'q': 'Opposite of HAPPY is...', 'opts': ['Sad', 'Funny', 'Good', 'Nice'], 'a': 'Sad'},
    {'type': 'quiz', 'q': 'What do you use to see?', 'opts': ['Eyes', 'Ears', 'Nose', 'Mouth'], 'a': 'Eyes'},
    {'type': 'quiz', 'q': 'What do you use to walk?', 'opts': ['Legs', 'Hands', 'Ears', 'Nose'], 'a': 'Legs'},
    {'type': 'quiz', 'q': 'Fish live in...', 'opts': ['Water', 'Sky', 'Tree', 'Sand'], 'a': 'Water'},

    // --- FILL IN THE BLANK (Điền từ) ---
    {'type': 'fill', 'q': 'Z E _ R A', 'hint': 'Black and white stripes.', 'a': 'B'},
    {'type': 'fill', 'q': 'C _ T', 'hint': 'Says "Meow".', 'a': 'A'},
    {'type': 'fill', 'q': 'S _ A R K', 'hint': 'Dangerous fish.', 'a': 'H'},
    {'type': 'fill', 'q': 'D _ G', 'hint': 'Man\'s best friend.', 'a': 'O'},
    {'type': 'fill', 'q': 'P I _ K', 'hint': 'A lovely color.', 'a': 'N'},
    {'type': 'fill', 'q': 'B L _ E', 'hint': 'Color of the ocean.', 'a': 'U'},
    {'type': 'fill', 'q': 'A P P L _', 'hint': 'A red tasty fruit.', 'a': 'E'},
    {'type': 'fill', 'q': 'P I Z _ A', 'hint': 'Yummy Italian food.', 'a': 'Z'},
    {'type': 'fill', 'q': 'M I _ K', 'hint': 'White drink from cows.', 'a': 'L'},
    {'type': 'fill', 'q': 'B _ O K', 'hint': 'You read this.', 'a': 'O'},
    {'type': 'fill', 'q': 'S _ N', 'hint': 'Shines in the day.', 'a': 'U'},
    {'type': 'fill', 'q': 'M O _ N', 'hint': 'Shines at night.', 'a': 'O'},
    {'type': 'fill', 'q': 'C _ R', 'hint': 'It has 4 wheels.', 'a': 'A'},
    {'type': 'fill', 'q': 'B A _ L', 'hint': 'Round toy.', 'a': 'L'},

    // --- IMAGE CHOICE (Chọn ảnh - KHÔNG HIỆN TÊN) ---
    // Chỉ sử dụng ảnh có sẵn trong thư mục assets
    {
      'type': 'image', 'q': 'Find the TIGER!',
      'opts': [
        {'txt': 'Tiger', 'img': 'assets/images/animals/tiger.png'},
        {'txt': 'Lion', 'img': 'assets/images/animals/lion.png'},
        {'txt': 'Cat', 'img': 'assets/images/animals/cat.png'},
        {'txt': 'Dog', 'img': 'assets/images/animals/dog.png'}
      ],
      'a': 'Tiger'
    },
    {
      'type': 'image', 'q': 'Where is the ELEPHANT?',
      'opts': [
        {'txt': 'Elephant', 'img': 'assets/images/animals/elephant.png'},
        {'txt': 'Hippo', 'img': 'assets/images/animals/hippopotamus.png'},
        {'txt': 'Rhino', 'img': 'assets/images/animals/rhinoceros.png'},
        {'txt': 'Zebra', 'img': 'assets/images/animals/zebra.png'}
      ],
      'a': 'Elephant'
    },
    {
      'type': 'image', 'q': 'Tap the PARROT',
      'opts': [
        {'txt': 'Parrot', 'img': 'assets/images/animals/parrot.png'},
        {'txt': 'Fish', 'img': 'assets/images/animals/fish.png'},
        {'txt': 'Owl', 'img': 'assets/images/animals/owl.png'},
        {'txt': 'Chicken', 'img': 'assets/images/animals/chicken.png'}
      ],
      'a': 'Parrot'
    },
    {
      'type': 'image', 'q': 'Which one lives in water?',
      'opts': [
        {'txt': 'Dolphin', 'img': 'assets/images/animals/dolphin.png'},
        {'txt': 'Cat', 'img': 'assets/images/animals/cat.png'},
        {'txt': 'Monkey', 'img': 'assets/images/animals/monkey.png'},
        {'txt': 'Goat', 'img': 'assets/images/animals/goat.png'}
      ],
      'a': 'Dolphin'
    },
    {
      'type': 'image', 'q': 'Tap the RED fruit',
      'opts': [
        {'txt': 'Apple', 'img': 'assets/images/fruits/apple.png'},
        {'txt': 'Banana', 'img': 'assets/images/fruits/banana.png'},
        {'txt': 'Grape', 'img': 'assets/images/fruits/grapes.png'},
        {'txt': 'Lemon', 'img': 'assets/images/fruits/lemon.png'}
      ],
      'a': 'Apple'
    },
    {
      'type': 'image', 'q': 'Find the YELLOW fruit',
      'opts': [
        {'txt': 'Banana', 'img': 'assets/images/fruits/banana.png'},
        {'txt': 'Cherry', 'img': 'assets/images/fruits/cherry.png'},
        {'txt': 'Blueberry', 'img': 'assets/images/fruits/blueberry.png'},
        {'txt': 'Avocado', 'img': 'assets/images/fruits/avocado.png'}
      ],
      'a': 'Banana'
    },
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _playBGM();
    _startRound(1);
  }

  void _playBGM() async {
    await bgmPlayer.setVolume(0.3);
    await bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await bgmPlayer.play(AssetSource('audio/onepiece.mp3'));
  }

  void _playSFX(bool isWin) async {
    await sfxPlayer.stop();
    await sfxPlayer.setVolume(1.0);
    await sfxPlayer.play(AssetSource(isWin ? 'audio/win.mp3' : 'audio/lose.mp3'));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    bgmPlayer.stop();
    bgmPlayer.dispose();
    sfxPlayer.dispose();
    super.dispose();
  }

  void _startRound(int round) {
    setState(() {
      currentRound = round;
      isRoundVictory = false;
      maxHP = round * 20;
      currentHP = maxHP;
      bossImage = 'assets/images/treasures/treasure_pirateking$round.png';
    });
    _pickUniqueRandomQuestion();
  }

  void _pickUniqueRandomQuestion() {
    setState(() {
      if (usedQuestionIndices.length >= questionPool.length) {
        usedQuestionIndices.clear();
      }

      int randomIndex;
      do {
        randomIndex = _random.nextInt(questionPool.length);
      } while (usedQuestionIndices.contains(randomIndex));

      usedQuestionIndices.add(randomIndex);

      currentQuestion = questionPool[randomIndex];

      if (currentQuestion['type'] == 'quiz') {
        (currentQuestion['opts'] as List).shuffle();
      } else if (currentQuestion['type'] == 'image') {
        (currentQuestion['opts'] as List).shuffle();
      }
    });
  }

  void _handleAnswer(String answer) {
    if (isRoundVictory || isGameCompleted) return;

    bool isCorrect = (answer == currentQuestion['a']);

    if (isCorrect) {
      _playSFX(true);
      setState(() {
        currentHP -= 20;
        if (currentHP < 0) currentHP = 0;
        isWrongAnim = true;
      });
      _shakeController.forward(from: 0).then((_) => setState(() => isWrongAnim = false));

      if (currentHP <= 0) {
        _handleBossDefeated();
      } else {
        Future.delayed(const Duration(seconds: 1), _pickUniqueRandomQuestion);
      }
    } else {
      _playSFX(false);
      setState(() {
        currentHP += 10;
        if (currentHP > maxHP) currentHP = maxHP;
        isHealingAnim = true;
      });
      Future.delayed(const Duration(milliseconds: 800), () => setState(() => isHealingAnim = false));
    }
  }

  void _handleBossDefeated() {
    if (currentRound < maxRounds) {
      setState(() {
        isRoundVictory = true;
      });
    } else {
      setState(() {
        isGameCompleted = true;
      });
      bgmPlayer.stop();
      _playSFX(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text("BOSS BATTLE: ROUND $currentRound",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 20),

            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    double offset = sin(_shakeController.value * 20) * 10;
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.asset(
                      bossImage,
                      fit: BoxFit.contain,
                      errorBuilder: (_,__,___) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.warning, size: 50, color: Colors.red),
                          Text("Missing: $bossImage", textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isHealingAnim)
                  Positioned(
                    right: 20, top: 20,
                    child: Text("+10", style: TextStyle(color: Colors.green.shade800, fontSize: 32, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.white)])),
                  ),
                if (isWrongAnim)
                  Positioned(
                    left: 20, top: 20,
                    child: const Text("-20", style: TextStyle(color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.white)])),
                  )
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: currentHP / maxHP,
                      minHeight: 20,
                      backgroundColor: Colors.grey.shade300,
                      color: currentHP > maxHP/2 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text("HP: $currentHP / $maxHP", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (isGameCompleted)
              _buildFinalVictory()
            else if (isRoundVictory)
              _buildNextRoundButton()
            else
              _buildQuestionPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,4))],
          border: Border.all(color: Colors.indigo.shade200, width: 2)
      ),
      child: Column(
        children: [
          Text(currentQuestion['type'] == 'fill' ? 'Fill the Blank!' : 'Answer Quickly!',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          const SizedBox(height: 10),
          Text(
            currentQuestion['q'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          if (currentQuestion['type'] == 'fill')
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("Hint: ${currentQuestion['hint']}", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.brown)),
            ),
          const SizedBox(height: 20),

          // 1. TRẮC NGHIỆM
          if (currentQuestion['type'] == 'quiz')
            Wrap(
              spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
              children: (currentQuestion['opts'] as List<String>).map((opt) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade50,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    elevation: 2,
                  ),
                  onPressed: () => _handleAnswer(opt),
                  child: Text(opt, style: const TextStyle(fontSize: 18, color: Colors.indigo, fontWeight: FontWeight.bold)),
                );
              }).toList(),
            )
          // 2. ĐIỀN TỪ
          else if (currentQuestion['type'] == 'fill')
            Wrap(
              spacing: 10, runSpacing: 10, alignment: WrapAlignment.center,
              children: "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('').map((char) {
                String ans = currentQuestion['a'];
                if (!"AEOILMNSTRBZHKUDGP".contains(char) && char != ans) return const SizedBox.shrink();
                return ChoiceChip(
                  label: Text(char, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  selected: false,
                  onSelected: (_) => _handleAnswer(char),
                  backgroundColor: Colors.orange.shade100,
                  padding: const EdgeInsets.all(12),
                );
              }).toList(),
            )
          // 3. CHỌN HÌNH ẢNH (Chỉ hiện hình, không hiện chữ)
          else if (currentQuestion['type'] == 'image')
              Wrap(
                spacing: 15, runSpacing: 15, alignment: WrapAlignment.center,
                children: (currentQuestion['opts'] as List).map((opt) {
                  return GestureDetector(
                    onTap: () => _handleAnswer(opt['txt']),
                    child: Container(
                      height: 90, width: 90, // Kích thước ảnh
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))]
                      ),
                      child: Image.asset(
                          opt['img'],
                          fit: BoxFit.contain,
                          errorBuilder: (_,__,___) => const Icon(Icons.image)
                      ),
                    ),
                  );
                }).toList(),
              )
        ],
      ),
    );
  }

  Widget _buildNextRoundButton() {
    return Column(
      children: [
        const Icon(Icons.star, color: Colors.orange, size: 60),
        Text("BOSS $currentRound DEFEATED!", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () {
            _startRound(currentRound + 1);
          },
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          label: const Text("Next Boss", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget _buildFinalVictory() {
    return Column(
      children: [
        const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 80),
        const Text("ISLAND CLEARED!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo)),
        const SizedBox(height: 10),
        const Text("You are the Pirate King now!", style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 10,
          ),
          onPressed: widget.onCompleted,
          icon: const Icon(Icons.check_circle, color: Colors.white, size: 30),
          label: const Text("Claim Treasure", style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}