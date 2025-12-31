
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/treasure_hunt_data.dart';

class IslandMatchWordImage extends StatefulWidget {
  final int questionIndex;
  final String langCode;
  final VoidCallback onCompleted;
  const IslandMatchWordImage({Key? key, required this.questionIndex, required this.langCode, required this.onCompleted}) : super(key: key);

  @override
  State<IslandMatchWordImage> createState() => _IslandMatchWordImageState();
}

  final AudioPlayer sfxPlayer = AudioPlayer();
  int currentRound = 0;
  int hp = 5;
  bool isGameWon = false;

  List<Map<String, dynamic>> get rounds {
    // For demo: use 5 random ocean questions
    List<Map<String, dynamic>> all = List.generate(5, (i) => TreasureHuntData.oceanQuestions[(widget.questionIndex + i) % TreasureHuntData.oceanQuestions.length]);
    return all;
  }

  void _handleAnswer(bool isCorrect) {
    if (isCorrect) {
      sfxPlayer.play(AssetSource('audio/win.mp3'));
      if (currentRound < rounds.length - 1) {
        setState(() {
          currentRound++;
          hp--;
        });
      } else {
        setState(() {
          hp = 0;
          isGameWon = true;
        });
      }
    } else {
      sfxPlayer.play(AssetSource('audio/lose.mp3'));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ouch! Try again!"), duration: Duration(milliseconds: 500)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isGameWon) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            Text(widget.langCode == 'ja' ? 'クリア！' : "YOU WON!", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.onCompleted,
              child: Text(widget.langCode == 'ja' ? '冒険を終える' : "Finish Adventure", style: const TextStyle(fontSize: 20)),
            )
          ],
        ),
      );
    }

    final roundData = rounds[currentRound];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => Icon(
                Icons.favorite,
                color: index < hp ? Colors.red : Colors.grey,
                size: 30
            )),
          ),
        ),
        const SizedBox(height: 10),
        const Icon(Icons.smart_toy_rounded, size: 80, color: Colors.deepPurple),
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Text(widget.langCode == 'ja' ? roundData['riddle_ja'] : roundData['riddle_en'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const Spacer(),
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: (roundData['options'] as List).length,
          itemBuilder: (context, i) {
            final item = roundData['options'][i];
            return GestureDetector(
              onTap: () => _handleAnswer(i == roundData['correct_index']),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(8),
                child: Image.asset(item['path'], fit: BoxFit.contain),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}