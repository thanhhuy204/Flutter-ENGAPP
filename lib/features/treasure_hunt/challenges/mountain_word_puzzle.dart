import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import '../data/mountain_word_puzzle_data.dart';
import '../domain/entities/challenge_question.dart';

class MountainWordPuzzle extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const MountainWordPuzzle({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<MountainWordPuzzle> createState() => _MountainWordPuzzleState();
}

class _MountainWordPuzzleState extends State<MountainWordPuzzle> {
  final AudioPlayer sfxPlayer = AudioPlayer();
  late List<MountainWordPuzzleQuestion> questions;
  late MountainWordPuzzleQuestion currentQuestion;

  List<String> letters = [];
  List<String> answer = [];
  List<bool> used = [];
  bool completed = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    questions = MountainWordPuzzleData.getQuestions();
    currentQuestion = questions[widget.questionIndex % questions.length];
    _initializeLetters();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentQuestion = questions[widget.questionIndex % questions.length];
  }

  void _initializeLetters() {
    letters = currentQuestion.word.split('');
    letters.shuffle();
    answer.clear();
    used = List.filled(letters.length, false);
  }

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

  void checkAnswer() {
    if (answer.join() == currentQuestion.word) {
      _playSFX(true); // Âm thanh thắng
      setState(() {
        completed = true;
        error = '';
      });
    } else if (answer.length == currentQuestion.word.length) {
      _playSFX(false); // Âm thanh thua
      error = 'Try again!';
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
          setState(() {
            answer.clear();
            used = List.filled(letters.length, false);
            error = '';
          });
        }
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'spelling_challenge'.tr(),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: Text(
                  currentQuestion.getHint(languageCode),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.brown, fontStyle: FontStyle.italic)
              ),
            ),

            const SizedBox(height: 40),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: List.generate(currentQuestion.word.length, (index) {
                String char = index < answer.length ? answer[index] : '';
                return GestureDetector(
                  onTap: completed ? null : () {
                    if (index < answer.length) {
                      setState(() {
                        String removed = answer.removeAt(index);
                        for (int j = 0; j < letters.length; j++) {
                          if (letters[j] == removed && used[j]) {
                            used[j] = false;
                            break;
                          }
                        }
                      });
                    }
                  },
                  child: Container(
                    width: 55,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: char.isNotEmpty ? Colors.deepOrangeAccent : Colors.white,
                        border: Border.all(color: Colors.deepOrange, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(2,2), blurRadius: 4)]
                    ),
                    child: Text(char, style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 30,
              child: Text(error, style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: List.generate(letters.length, (i) => SizedBox(
                  width: 65,
                  height: 65,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: used[i] ? Colors.grey.shade300 : Colors.amber,
                      foregroundColor: used[i] ? Colors.grey : Colors.white,
                      elevation: used[i] ? 0 : 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: completed || used[i] ? null : () {
                      setState(() {
                        answer.add(letters[i]);
                        used[i] = true;
                        checkAnswer();
                      });
                    },
                    child: Text(letters[i], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                )),
              ),
            ),

            if (completed)
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: Column(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 70),
                    const Text("Excellent!", style: TextStyle(fontSize: 28, color: Colors.green, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
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
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}