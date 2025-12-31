import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/treasure_hunt_data.dart';

class OceanChooseImage extends StatefulWidget {
  final int questionIndex;
  final String langCode;
  final VoidCallback onCompleted;
  const OceanChooseImage({Key? key, required this.questionIndex, required this.langCode, required this.onCompleted}) : super(key: key);

  @override
  State<OceanChooseImage> createState() => _OceanChooseImageState();
}

class _OceanChooseImageState extends State<OceanChooseImage> {
  final AudioPlayer sfxPlayer = AudioPlayer();
  bool completed = false;
  int selectedIndex = -1;

  Map<String, dynamic> get q => TreasureHuntData.oceanQuestions[widget.questionIndex % TreasureHuntData.oceanQuestions.length];

  void _onTap(int index) {
    if (completed) return;
    setState(() => selectedIndex = index);
    if (index == q['correct_index']) {
      sfxPlayer.play(AssetSource('audio/win.mp3'));
      setState(() => completed = true);
    } else {
      sfxPlayer.play(AssetSource('audio/lose.mp3'));
      Future.delayed(const Duration(seconds: 1), () => setState(() => selectedIndex = -1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 10)]),
          child: Text(
            widget.langCode == 'ja' ? q['riddle_ja'] : q['riddle_en'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent, height: 1.5),
          ),
        ),
        const SizedBox(height: 40),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.1),
          itemCount: (q['options'] as List).length,
          itemBuilder: (context, i) {
            final item = q['options'][i];
            bool isSelected = selectedIndex == i;
            bool isCorrect = i == q['correct_index'];
            return GestureDetector(
              onTap: () => _onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.transparent, width: 4),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(child: Image.asset(item['path'], fit: BoxFit.contain)),
                    Text(widget.langCode == 'ja' ? item['label_ja'] : item['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
        if (completed)
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ElevatedButton.icon(
              onPressed: widget.onCompleted,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              icon: const Icon(Icons.arrow_forward), label: Text(widget.langCode == 'ja' ? '次のレベル' : 'Next Level'),
            ),
          )
      ],
    );
  }
}