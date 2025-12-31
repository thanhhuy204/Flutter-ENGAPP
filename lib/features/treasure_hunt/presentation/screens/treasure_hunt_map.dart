import 'package:flutter/material.dart';
import 'challenge_screen.dart';

class TreasureHuntMap extends StatefulWidget {
  const TreasureHuntMap({Key? key}) : super(key: key);

  @override
  State<TreasureHuntMap> createState() => _TreasureHuntMapState();
}

class _TreasureHuntMapState extends State<TreasureHuntMap> {
  int currentLevel = 0;
  final int totalLevels = 5;

  late List<List<int>> usedQuestionIndexes;
  late List<int> currentQuestionIndexes;

  // Cập nhật tọa độ cho cân đối hơn trên map
  final List<Offset> levelPositions = [
    const Offset(0.37, 0.18), // Level 1
    const Offset(0.75, 0.32), // Level 2
    const Offset(0.50, 0.55), // Level 3
    const Offset(0.25, 0.80), // Level 4
    const Offset(0.75, 0.85), // Level 5
  ];

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    currentLevel = 0;
    usedQuestionIndexes = List.generate(totalLevels, (_) => []);
    currentQuestionIndexes = List.generate(totalLevels, (_) => -1);
    setState(() {});
  }

  void showCongratulationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 YOU WIN!', textAlign: TextAlign.center, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You found the ultimate treasure!', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Image.asset('assets/images/treasures/treasure_chest.png', width: 120, height: 120, fit: BoxFit.contain,
                errorBuilder: (_,__,___) => const Icon(Icons.emoji_events, size: 80, color: Colors.amber)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: const Text('Play Again', style: TextStyle(fontSize: 18)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Exit', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.blue[50],
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: AspectRatio(
              aspectRatio: 0.65,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/treasures/treasure_map.png',
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.amber[100],
                        child: const Center(child: Text('Missing Map Image')),
                      ),
                    ),
                  ),

                  ...List.generate(totalLevels, (index) {
                    final pos = levelPositions[index];
                    bool isLocked = index > currentLevel;
                    return Positioned(
                      left: size.width * pos.dx - (isLocked ? 40 : 60),
                      top: size.height * pos.dy - (isLocked ? 40 : 60),
                      child: GestureDetector(
                        onTap: isLocked ? null : () {
                          if (index == currentLevel) {
                            final used = usedQuestionIndexes[index];
                            final available = List.generate(5, (i) => i)..removeWhere((i) => used.contains(i));
                            if (available.isEmpty) {
                              usedQuestionIndexes[index] = [];
                              currentQuestionIndexes[index] = 0;
                            } else {
                              final qIdx = (available..shuffle()).first;
                              usedQuestionIndexes[index].add(qIdx);
                              currentQuestionIndexes[index] = qIdx;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChallengeScreen(
                                  level: index,
                                  questionIndex: currentQuestionIndexes[index],
                                  onCompleted: () {
                                    setState(() {
                                      if (currentLevel < totalLevels - 1) {
                                        currentLevel++;
                                      } else {
                                        Future.delayed(const Duration(milliseconds: 500), showCongratulationDialog);
                                      }
                                    });
                                  },
                                  onReset: resetGame,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: isLocked ? 80 : 120,
                          height: isLocked ? 80 : 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLocked ? Colors.black26 : Colors.transparent,
                          ),
                          child: isLocked ? const Icon(Icons.lock, color: Colors.white70) : null,
                        ),
                      ),
                    );
                  }),

                  // Character Animation - CHẬM LẠI (2 Seconds)
                  AnimatedPositioned(
                    duration: const Duration(seconds: 2), // Tăng thời gian lên 2s cho mượt
                    curve: Curves.easeInOutCubic, // Dùng curve này cho chuyển động tự nhiên hơn
                    left: size.width * levelPositions[currentLevel].dx - 40,
                    top: size.height * levelPositions[currentLevel].dy - 70,
                    child: IgnorePointer(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(
                          'assets/images/treasures/chick_character.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_,__,___) => const Icon(Icons.pets, size: 60, color: Colors.yellowAccent),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 40,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.deepOrange, size: 28),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}