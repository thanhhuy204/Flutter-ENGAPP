import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart'; // Thêm thư viện âm thanh

class JungleListenChoose extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const JungleListenChoose({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<JungleListenChoose> createState() => _JungleListenChooseState();
}

class _JungleListenChooseState extends State<JungleListenChoose> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer sfxPlayer = AudioPlayer(); // Player cho hiệu ứng

  // KHO CÂU HỎI MỞ RỘNG (Dùng ảnh có sẵn trong assets)
  final List<Map<String, dynamic>> questions = [
    {
      'word': 'Monkey',
      'options': [
        'assets/images/animals/monkey.png',
        'assets/images/animals/lion.png',
        'assets/images/animals/elephant.png',
        'assets/images/animals/zebra.png'
      ],
      'answer': 0,
    },
    {
      'word': 'Tiger',
      'options': [
        'assets/images/animals/giraffe.png',
        'assets/images/animals/tiger.png',
        'assets/images/animals/fox.png',
        'assets/images/animals/deer.png'
      ],
      'answer': 1,
    },
    {
      'word': 'Lion',
      'options': [
        'assets/images/animals/zebra.png',
        'assets/images/animals/lion.png',
        'assets/images/animals/monkey.png',
        'assets/images/animals/parrot.png'
      ],
      'answer': 1,
    },
    {
      'word': 'Elephant',
      'options': [
        'assets/images/animals/tiger.png',
        'assets/images/animals/fox.png',
        'assets/images/animals/elephant.png',
        'assets/images/animals/squirrel.png'
      ],
      'answer': 2,
    },
    {
      'word': 'Giraffe',
      'options': [
        'assets/images/animals/lion.png',
        'assets/images/animals/giraffe.png',
        'assets/images/animals/monkey.png',
        'assets/images/animals/duck.png'
      ],
      'answer': 1,
    },
    // --- THÊM CÂU MỚI ---
    {
      'word': 'Hippo',
      'options': [
        'assets/images/animals/hippopotamus.png',
        'assets/images/animals/rhinoceros.png',
        'assets/images/animals/buffalo.png',
        'assets/images/animals/ox.png'
      ],
      'answer': 0,
    },
    {
      'word': 'Zebra',
      'options': [
        'assets/images/animals/horse.png',
        'assets/images/animals/zebra.png',
        'assets/images/animals/donkey.png', // Nếu chưa có ảnh thì dùng tạm ảnh khác hoặc icon
        'assets/images/animals/deer.png'
      ],
      'answer': 1,
    },
    {
      'word': 'Ostrich',
      'options': [
        'assets/images/animals/chicken.png',
        'assets/images/animals/duck.png',
        'assets/images/animals/ostrich.png',
        'assets/images/animals/owl.png'
      ],
      'answer': 2,
    },
  ];

  bool completed = false;
  int selected = -1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), playSound);
  }

  @override
  void dispose() {
    sfxPlayer.dispose();
    super.dispose();
  }

  void playSound() async {
    final q = questions[widget.questionIndex % questions.length];
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak("${q['word']}!");
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
            const Text('Listen & Find', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 10),
            const Text('Tap the speaker, then pick the animal!', style: TextStyle(fontSize: 16, color: Colors.black54)),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: playSound,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.greenAccent.shade100,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 15, spreadRadius: 5)]
                ),
                child: const Icon(Icons.volume_up_rounded, size: 60, color: Colors.green),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: 320,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: q['options'].length,
                itemBuilder: (context, i) {
                  bool isCorrect = (i == q['answer']);
                  bool isSelected = (selected == i);
                  Color borderColor = Colors.transparent;
                  if (isSelected) {
                    borderColor = isCorrect ? Colors.green : Colors.red;
                  }

                  return GestureDetector(
                    onTap: completed ? null : () {
                      setState(() {
                        selected = i;
                      });
                      if (isCorrect) {
                        _playSFX(true); // Âm thanh đúng
                        setState(() => completed = true);
                        flutterTts.speak("Correct! Good job.");
                      } else {
                        _playSFX(false); // Âm thanh sai
                        flutterTts.speak("Try again.");
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          setState(() => selected = -1);
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor, width: 4),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        q['options'][i],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.pets, size: 50, color: Colors.brown.shade300);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            if (completed)
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
                          backgroundColor: Colors.green,
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