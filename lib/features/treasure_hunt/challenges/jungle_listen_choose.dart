import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import '../data/jungle_listen_choose_data.dart';
import '../domain/entities/challenge_question.dart';

class JungleListenChoose extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const JungleListenChoose({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<JungleListenChoose> createState() => _JungleListenChooseState();
}

class _JungleListenChooseState extends State<JungleListenChoose> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer sfxPlayer = AudioPlayer();
  late List<JungleListenChooseQuestion> questions;
  late JungleListenChooseQuestion currentQuestion;

  bool completed = false;
  int selected = -1;

  @override
  void initState() {
    super.initState();
    questions = JungleListenChooseData.getQuestions();
    currentQuestion = questions[widget.questionIndex % questions.length];
    Future.delayed(const Duration(milliseconds: 500), playSound);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentQuestion = questions[widget.questionIndex % questions.length];
  }

  @override
  void dispose() {
    sfxPlayer.dispose();
    super.dispose();
  }

  void playSound() async {
    final languageCode = context.locale.languageCode;
    await flutterTts.setLanguage(languageCode == 'ja' ? 'ja-JP' : 'en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(currentQuestion.getTranslation(languageCode));
  }

  void _playSFX(bool isWin) async {
    await sfxPlayer.stop();
    await sfxPlayer.setVolume(1.0);
    await sfxPlayer.play(AssetSource(isWin ? 'audio/win.mp3' : 'audio/lose.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'listen_and_find'.tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
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
                itemCount: currentQuestion.imagePaths.length,
                itemBuilder: (context, i) {
                  bool isCorrect = (i == currentQuestion.answerIndex);
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
                        currentQuestion.imagePaths[i],
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
                        label: Text(
                          'next'.tr(),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
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