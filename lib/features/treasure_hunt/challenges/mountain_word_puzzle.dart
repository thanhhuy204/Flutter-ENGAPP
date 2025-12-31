
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/treasure_hunt_data.dart';

class MountainWordPuzzle extends StatefulWidget {
  final int questionIndex;
  final String langCode;
  final VoidCallback onCompleted;
  const MountainWordPuzzle({Key? key, required this.questionIndex, required this.langCode, required this.onCompleted}) : super(key: key);

  @override
  State<MountainWordPuzzle> createState() => _MountainWordPuzzleState();
}

class _MountainWordPuzzleState extends State<MountainWordPuzzle> {
  final AudioPlayer sfxPlayer = AudioPlayer();
  List<String> letters = [];
  List<String> answer = [];
  List<bool> used = [];
  bool completed = false;
  String error = '';

  Map<String, String> get q => TreasureHuntData.mountainQuestions[widget.questionIndex % TreasureHuntData.mountainQuestions.length];

  @override
  void initState() {
    super.initState();
    letters = q['word']!.split('');
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
    if (answer.join() == q['word']) {
      _playSFX(true);
      setState(() {
        completed = true;
        error = '';
      });
    } else if (answer.length == q['word']!.length) {
      _playSFX(false);
      error = widget.langCode == 'ja' ? 'もう一度！' : 'Try again!';
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
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.langCode == 'ja' ? 'スペリングチャレンジ！' : 'Spelling Challenge!', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
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
                  q[widget.langCode == 'ja' ? 'hint_ja' : 'hint_en']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.brown, fontStyle: FontStyle.italic)
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: List.generate(q['word']!.length, (index) {
                String char = index < answer.length ? answer[index] : '';
                return Container(
                  width: 50, height: 50, alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.brown), borderRadius: BorderRadius.circular(8)),
                  child: Text(char, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                spacing: 10,
                children: List.generate(letters.length, (i) {
                  return ElevatedButton(
                    onPressed: used[i] ? null : () {
                      setState(() { answer.add(letters[i]); used[i] = true; checkAnswer(); });
                    },
                    child: Text(letters[i], style: const TextStyle(fontSize: 24)),
                  );
                }),
              ),
            ),
            if (completed)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: widget.onCompleted,
                  child: Text(widget.langCode == 'ja' ? '次のチャレンジ' : 'Next Challenge'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}