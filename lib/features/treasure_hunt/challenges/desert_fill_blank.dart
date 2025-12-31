import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import '../data/desert_fill_blank_data.dart';
import '../domain/entities/challenge_question.dart';

class DesertFillBlank extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const DesertFillBlank({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<DesertFillBlank> createState() => _DesertFillBlankState();
}

class _DesertFillBlankState extends State<DesertFillBlank> {
  final AudioPlayer sfxPlayer = AudioPlayer();
  late List<DesertFillBlankQuestion> questions;
  late DesertFillBlankQuestion currentQuestion;
  
  String input = '';
  bool completed = false;
  String error = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    questions = DesertFillBlankData.getQuestions();
    currentQuestion = questions[widget.questionIndex % questions.length];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload current question when language changes
    currentQuestion = questions[widget.questionIndex % questions.length];
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

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'desert_challenge'.tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.orange.shade200)
              ),
              child: Text(
                'Hint: ${currentQuestion.getHint(languageCode)}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.brown, fontStyle: FontStyle.italic),
              ),
            ),

            const SizedBox(height: 30),
            Text(
              currentQuestion.questionPattern,
              style: const TextStyle(fontSize: 40, letterSpacing: 8, fontWeight: FontWeight.bold, color: Colors.black87),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 100,
              child: TextField(
                controller: _controller,
                enabled: !completed,
                onChanged: (val) {
                  input = val.toUpperCase();
                  if (input == currentQuestion.answer) {
                    _playSFX(true); // Win
                    completed = true;
                    error = '';
                    setState(() {});
                  } else if (input.isNotEmpty) {
                    _playSFX(false); // Lose
                    setState(() {
                      error = 'Wrong!';
                    });
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        setState(() {
                          input = '';
                          _controller.clear();
                          error = '';
                        });
                      }
                    });
                  }
                },
                maxLength: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.orange, width: 2)
                  ),
                  hintText: '?',
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 10),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),

            if (completed)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 60),
                    const Text("Correct!", style: TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
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
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}