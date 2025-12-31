
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/treasure_hunt_data.dart';

class DesertFillBlank extends StatefulWidget {
  final int questionIndex;
  final String langCode;
  final VoidCallback onCompleted;
  const DesertFillBlank({Key? key, required this.questionIndex, required this.langCode, required this.onCompleted}) : super(key: key);

  @override
  State<DesertFillBlank> createState() => _DesertFillBlankState();
}

class _DesertFillBlankState extends State<DesertFillBlank> {
  final AudioPlayer sfxPlayer = AudioPlayer();
  late String questionWord;
  late String missingChar;
  List<String> options = [];
  bool completed = false;
  String? selectedChar;

  Map<String, String> get q => TreasureHuntData.desertQuestions[widget.questionIndex % TreasureHuntData.desertQuestions.length];

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  @override
  void dispose() {
    sfxPlayer.dispose();
    super.dispose();
  }

  void _setupGame() {
    questionWord = q['question']!;
    missingChar = q['answer']!;
    options = [missingChar];
    String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final rand = Random();
    while (options.length < 4) {
      String randomChar = alphabet[rand.nextInt(alphabet.length)];
      if (!options.contains(randomChar)) options.add(randomChar);
    }
    options.shuffle();
  }

  void _checkAnswer(String char) {
    setState(() => selectedChar = char);
    if (char == missingChar) {
      sfxPlayer.play(AssetSource('audio/win.mp3'));
      setState(() {
        completed = true;
      });
    } else {
      sfxPlayer.play(AssetSource('audio/lose.mp3'));
      Future.delayed(const Duration(milliseconds: 500), () => setState(() => selectedChar = null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            q['image'] != null && q['image']!.contains('assets')
                ? Image.asset(q['image']!, height: 160)
                : const Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            Text(questionWord.split('').join(' '), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 4, color: Colors.deepOrange)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(q[widget.langCode == 'ja' ? 'hint_ja' : 'hint_en']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.black87, fontStyle: FontStyle.italic)),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 15,
              children: options.map((char) {
                bool isSelected = selectedChar == char;
                Color btnColor = isSelected ? (char == missingChar ? Colors.green : Colors.red) : Colors.white;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: btnColor, padding: const EdgeInsets.all(20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: completed ? null : () => _checkAnswer(char),
                  child: Text(char, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                );
              }).toList(),
            ),
            if (completed)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: ElevatedButton.icon(
                  onPressed: widget.onCompleted,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(widget.langCode == 'ja' ? '次のレベル' : 'Next Level'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}