import 'package:flutter/material.dart';
import '../../challenges/jungle_listen_choose.dart';
import '../../challenges/mountain_word_puzzle.dart';
import '../../challenges/desert_fill_blank.dart';
import '../../challenges/ocean_choose_image.dart';
import '../../challenges/island_match_word_image.dart';

class ChallengeScreen extends StatelessWidget {
  final int level;
  final int questionIndex;
  final VoidCallback onCompleted;
  final VoidCallback? onReset;
  const ChallengeScreen({Key? key, required this.level, required this.questionIndex, required this.onCompleted, this.onReset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget challengeWidget;
    // Màu nền thay đổi theo level
    List<Color> bgColors;

    switch (level) {
      case 0: // Jungle
        challengeWidget = JungleListenChoose(
          questionIndex: questionIndex,
          onCompleted: () { onCompleted(); Navigator.pop(context); },
        );
        bgColors = [Colors.green.shade50, Colors.green.shade100];
        break;
      case 1: // Mountain
        challengeWidget = MountainWordPuzzle(
          questionIndex: questionIndex,
          onCompleted: () { onCompleted(); Navigator.pop(context); },
        );
        bgColors = [Colors.brown.shade50, Colors.orange.shade50];
        break;
      case 2: // Desert
        challengeWidget = DesertFillBlank(
          questionIndex: questionIndex,
          onCompleted: () { onCompleted(); Navigator.pop(context); },
        );
        bgColors = [Colors.orange.shade50, Colors.yellow.shade100];
        break;
      case 3: // Ocean
        challengeWidget = OceanChooseImage(
          questionIndex: questionIndex,
          onCompleted: () { onCompleted(); Navigator.pop(context); },
        );
        bgColors = [Colors.blue.shade50, Colors.blue.shade100];
        break;
      case 4: // Island
        challengeWidget = IslandMatchWordImage(
          questionIndex: questionIndex,
          onCompleted: () { onCompleted(); Navigator.pop(context); },
        );
        bgColors = [Colors.indigo.shade50, Colors.purple.shade50];
        break;
      default:
        challengeWidget = const Center(child: Text('No challenge'));
        bgColors = [Colors.white, Colors.white];
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Level ${level + 1} Challenge', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))
        ),
        actions: [
          if (onReset != null)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                onReset!();
              },
            ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: bgColors,
            )
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: challengeWidget,
      ),
    );
  }
}