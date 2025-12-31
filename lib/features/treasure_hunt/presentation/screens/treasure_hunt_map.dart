import 'package:flutter/material.dart';
// --- SỬA ĐƯỜNG DẪN IMPORT Ở ĐÂY ---
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

  // Tọa độ các điểm trên bản đồ
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

  void _openLevel(int levelIndex) {
    // Logic chọn câu hỏi ngẫu nhiên (giữ nguyên logic cũ của anh để tính index)
    // Dù ChallengeGenerator đã random, nhưng việc truyền index vẫn hữu ích cho Island Boss
    int qIndex = currentQuestionIndexes[levelIndex];
    if (qIndex == -1) {
      qIndex = DateTime.now().millisecond; // Random seed đơn giản
      currentQuestionIndexes[levelIndex] = qIndex;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeScreen(
          level: levelIndex,
          questionIndex: qIndex,
          onCompleted: () {
            setState(() {
              if (currentLevel < totalLevels - 1) {
                currentLevel++; // Mở khóa màn tiếp theo
              } else {
                // Đã thắng toàn bộ game -> Reset hoặc hiện thông báo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("YOU ARE THE PIRATE KING! GAME CLEARED!")),
                );
                resetGame();
              }
            });
          },
          onReset: resetGame, // Truyền hàm reset vào để nút Refresh hoạt động
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/treasures/treasure_map.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Vẽ đường nối các level (nét đứt)
            CustomPaint(
              size: Size.infinite,
              painter: PathPainter(levelPositions, currentLevel),
            ),

            // Vẽ các điểm Level (Nút tròn)
            ...List.generate(totalLevels, (index) {
              bool isUnlocked = index <= currentLevel;
              bool isCurrent = index == currentLevel;

              return Positioned(
                left: size.width * levelPositions[index].dx - 30,
                top: size.height * levelPositions[index].dy - 30,
                child: GestureDetector(
                  onTap: isUnlocked ? () => _openLevel(index) : null,
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isUnlocked ? (isCurrent ? Colors.yellowAccent : Colors.orange) : Colors.grey,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            if (isUnlocked)
                              BoxShadow(color: Colors.orange.withOpacity(0.6), blurRadius: 15, spreadRadius: 2)
                          ],
                        ),
                        child: Icon(
                          isUnlocked ? (index == 4 ? Icons.star : Icons.lock_open) : Icons.lock,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                          child: const Text("START", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                ),
              );
            }),

            // Vẽ nhân vật di chuyển đến level hiện tại
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOutBack,
              left: size.width * levelPositions[currentLevel].dx - 40,
              top: size.height * levelPositions[currentLevel].dy - 80, // Đứng trên nút một chút
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/treasures/chick_character.png', // Đảm bảo anh có ảnh này
                  width: 80,
                  height: 80,
                  errorBuilder: (_,__,___) => const Icon(Icons.location_on, size: 60, color: Colors.redAccent),
                ),
              ),
            ),

            // Nút Back
            Positioned(
              top: 40,
              left: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Giữ nguyên class vẽ đường đi
class PathPainter extends CustomPainter {
  final List<Offset> points;
  final int currentLevel;
  PathPainter(this.points, this.currentLevel);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Vẽ nét đứt
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = Offset(points[i].dx * size.width, points[i].dy * size.height);
      final p2 = Offset(points[i+1].dx * size.width, points[i+1].dy * size.height);

      // Nếu đường này đã đi qua (level cao hơn) thì vẽ đậm hơn
      if (i < currentLevel) {
        paint.color = Colors.orangeAccent;
        paint.strokeWidth = 6;
        canvas.drawLine(p1, p2, paint);
      } else {
        paint.color = Colors.brown.withOpacity(0.4);
        paint.strokeWidth = 4;
        _drawDashedLine(canvas, p1, p2, paint);
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    var max = (p1 - p2).distance;
    var dashWidth = 10.0;
    var dashSpace = 5.0;
    var startY = 0.0;
    while (startY < max) {
      // Tính toán điểm vẽ nét đứt
      // (Logic đơn giản hóa để vẽ đường thẳng đứt quãng)
      double t1 = startY / max;
      double t2 = (startY + dashWidth) / max;
      var newP1 = Offset.lerp(p1, p2, t1)!;
      var newP2 = Offset.lerp(p1, p2, t2)!;
      canvas.drawLine(newP1, newP2, paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}