import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class OceanChooseImage extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const OceanChooseImage({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<OceanChooseImage> createState() => _OceanChooseImageState();
}

class _OceanChooseImageState extends State<OceanChooseImage> {
  final AudioPlayer sfxPlayer = AudioPlayer();

  // KHO CÂU HỎI MỞ RỘNG (Câu đố + Từ vựng)
  final List<Map<String, dynamic>> questions = [
    {
      'riddle': 'I have sharp teeth and fins.\nI am a scary hunter in the deep sea.\nWho am I?',
      'answer_index': 0, // Shark
      'options': [
        {'path': 'assets/images/animals/shark.png', 'label': 'Shark'},
        {'path': 'assets/images/animals/dolphin.png', 'label': 'Dolphin'},
        {'path': 'assets/images/animals/fish.png', 'label': 'Fish'},
        {'path': 'assets/images/animals/whale.png', 'label': 'Whale'},
      ]
    },
    {
      'riddle': 'I have 8 long arms.\nI can shoot ink to hide from enemies.\nWho am I?',
      'answer_index': 2, // Octopus
      'options': [
        {'path': 'assets/images/animals/crab.png', 'label': 'Crab'},
        {'path': 'assets/images/animals/fish.png', 'label': 'Fish'},
        {'path': 'assets/images/animals/octopus.png', 'label': 'Octopus'},
        {'path': 'assets/images/animals/turtle.png', 'label': 'Turtle'},
      ]
    },
    {
      'riddle': 'I have a hard shell on my back.\nI have claws and I walk sideways.\nWho am I?',
      'answer_index': 1, // Crab
      'options': [
        {'path': 'assets/images/animals/octopus.png', 'label': 'Octopus'},
        {'path': 'assets/images/animals/crab.png', 'label': 'Crab'},
        {'path': 'assets/images/animals/turtle.png', 'label': 'Turtle'},
        {'path': 'assets/images/animals/shark.png', 'label': 'Shark'},
      ]
    },
    {
      'riddle': 'I am very smart and friendly.\nI love to jump out of the water.\nWho am I?',
      'answer_index': 3, // Dolphin
      'options': [
        {'path': 'assets/images/animals/shark.png', 'label': 'Shark'},
        {'path': 'assets/images/animals/whale.png', 'label': 'Whale'},
        {'path': 'assets/images/animals/fish.png', 'label': 'Fish'},
        {'path': 'assets/images/animals/dolphin.png', 'label': 'Dolphin'},
      ]
    },
    {
      'riddle': 'I am the biggest animal in the ocean.\nI can sing songs under the water.\nWho am I?',
      'answer_index': 0, // Whale
      'options': [
        {'path': 'assets/images/animals/whale.png', 'label': 'Whale'},
        {'path': 'assets/images/animals/shark.png', 'label': 'Shark'},
        {'path': 'assets/images/animals/dolphin.png', 'label': 'Dolphin'},
        {'path': 'assets/images/animals/hippopotamus.png', 'label': 'Hippo'},
      ]
    },
    // --- THÊM CÂU MỚI ---
    {
      'riddle': 'I am a bird but I cannot fly.\nI love to swim in cold water.\nWho am I?',
      'answer_index': 2, // Penguin
      'options': [
        {'path': 'assets/images/animals/duck.png', 'label': 'Duck'},
        {'path': 'assets/images/animals/parrot.png', 'label': 'Parrot'},
        {'path': 'assets/images/animals/penguin.png', 'label': 'Penguin'},
        {'path': 'assets/images/animals/chicken.png', 'label': 'Chicken'},
      ]
    },
    {
      'riddle': 'I have scales and I swim in schools.\nI can breathe underwater.\nWho am I?',
      'answer_index': 1, // Fish
      'options': [
        {'path': 'assets/images/animals/dolphin.png', 'label': 'Dolphin'},
        {'path': 'assets/images/animals/fish.png', 'label': 'Fish'},
        {'path': 'assets/images/animals/crab.png', 'label': 'Crab'},
        {'path': 'assets/images/animals/shark.png', 'label': 'Shark'},
      ]
    },
  ];

  int? selectedIndex;
  bool isCompleted = false;
  bool isWrong = false;

  @override
  void dispose() {
    sfxPlayer.dispose();
    super.dispose();
  }

  void _playSFX(bool isWin) async {
    await sfxPlayer.stop();
    await sfxPlayer.setVolume(1.0);
    await sfxPlayer.play(AssetSource(isWin ? 'audio/win.mp3' : 'audio/lose.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[widget.questionIndex % questions.length];

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ocean Riddle 🌊',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 20),

            // Khung hiển thị câu đố
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5))
                ],
                border: Border.all(color: Colors.blue.shade100, width: 2),
              ),
              child: Column(
                children: [
                  const Icon(Icons.help_outline_rounded, size: 40, color: Colors.orange),
                  const SizedBox(height: 10),
                  Text(
                    q['riddle'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.indigo, height: 1.4, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (isWrong)
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text("Oops! Not quite. Try again!", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
              ),

            // Lưới 4 đáp án
            SizedBox(
              width: 340,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.85,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  bool isCorrectAnswer = index == q['answer_index'];

                  String imagePath = q['options'][index]['path'];
                  String labelText = q['options'][index]['label'];

                  Color borderColor = Colors.transparent;
                  if (isSelected) {
                    borderColor = isCompleted && isCorrectAnswer ? Colors.green : Colors.red;
                  }

                  return GestureDetector(
                    onTap: isCompleted ? null : () {
                      setState(() {
                        selectedIndex = index;
                      });

                      if (isCorrectAnswer) {
                        _playSFX(true); // Win
                        setState(() {
                          isCompleted = true;
                          isWrong = false;
                        });
                      } else {
                        _playSFX(false); // Lose
                        setState(() {
                          isWrong = true;
                        });
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            setState(() {
                              selectedIndex = null;
                              isWrong = false;
                            });
                          }
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: borderColor,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image, size: 50, color: Colors.grey);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            labelText,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (isCompleted)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 8,
                        ),
                        onPressed: widget.onCompleted,
                        icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 28),
                        label: const Text("Next Level", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}