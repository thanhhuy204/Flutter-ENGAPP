import 'package:flutter/material.dart';

class IslandMatchWordImage extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const IslandMatchWordImage({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<IslandMatchWordImage> createState() => _IslandMatchWordImageState();
}

class _IslandMatchWordImageState extends State<IslandMatchWordImage> {
  // LEVEL 5: SENTENCE BUILDER (Sắp xếp câu - Mức độ Khó nhất)
  // Sử dụng danh sách asset anh đã có: elephant, giraffe, zebra, tiger, lion...
  final List<Map<String, dynamic>> questions = [
    {
      'image': 'assets/images/animals/parrot.png',
      'correct_sentence': ['The', 'parrot', 'is', 'colorful'],
      'scrambled': ['is', 'parrot', 'The', 'colorful'],
    },
    {
      'image': 'assets/images/animals/fish.png',
      'correct_sentence': ['Fish', 'swim', 'in', 'water'],
      'scrambled': ['water', 'swim', 'Fish', 'in'],
    },
    {
      'image': 'assets/images/animals/monkey.png',
      'correct_sentence': ['Monkeys', 'like', 'eating', 'bananas'],
      'scrambled': ['like', 'Monkeys', 'bananas', 'eating'],
    },
    {
      'image': 'assets/images/animals/lion.png',
      'correct_sentence': ['The', 'lion', 'is', 'strong'],
      'scrambled': ['strong', 'is', 'lion', 'The'],
    },
    {
      'image': 'assets/images/animals/elephant.png',
      'correct_sentence': ['The', 'elephant', 'is', 'big'],
      'scrambled': ['big', 'elephant', 'is', 'The'],
    },
    {
      'image': 'assets/images/animals/giraffe.png',
      'correct_sentence': ['The', 'giraffe', 'is', 'tall'],
      'scrambled': ['tall', 'giraffe', 'The', 'is'],
    },
    {
      'image': 'assets/images/animals/zebra.png',
      'correct_sentence': ['The', 'zebra', 'is', 'black', 'and', 'white'],
      'scrambled': ['white', 'and', 'zebra', 'The', 'black', 'is'],
    },
    {
      'image': 'assets/images/animals/tiger.png',
      'correct_sentence': ['The', 'tiger', 'runs', 'fast'],
      'scrambled': ['fast', 'The', 'tiger', 'runs'],
    },
  ];

  late List<String> currentScrambled;
  List<String> userSentence = [];
  bool isCompleted = false;
  bool isWrong = false;

  @override
  void initState() {
    super.initState();
    final q = questions[widget.questionIndex % questions.length];
    currentScrambled = List<String>.from(q['scrambled']);
    currentScrambled.shuffle(); // Xáo trộn ngẫu nhiên mỗi lần chơi
  }

  void _checkSentence() {
    final q = questions[widget.questionIndex % questions.length];
    final correct = q['correct_sentence'] as List<String>;

    // Kiểm tra độ dài và thứ tự từ
    if (userSentence.length == correct.length) {
      bool match = true;
      for (int i = 0; i < correct.length; i++) {
        if (userSentence[i] != correct[i]) match = false;
      }

      if (match) {
        setState(() {
          isCompleted = true;
          isWrong = false;
        });
        // Không tự động chuyển màn, chờ bé bấm nút "Finish Game"
      } else {
        setState(() => isWrong = true);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => isWrong = false);
        });
      }
    }
  }

  void _onWordTap(String word, bool isFromBank) {
    if (isCompleted) return;
    setState(() {
      if (isFromBank) {
        // Chuyển từ ngân hàng từ vựng lên dòng câu trả lời
        currentScrambled.remove(word);
        userSentence.add(word);

        // Tự động kiểm tra khi đã điền đủ số lượng từ
        final q = questions[widget.questionIndex % questions.length];
        if (userSentence.length == (q['correct_sentence'] as List).length) {
          _checkSentence();
        }
      } else {
        // Trả từ từ dòng câu trả lời về ngân hàng
        userSentence.remove(word);
        currentScrambled.add(word);
        isWrong = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[widget.questionIndex % questions.length];

    return Center(
      child: SingleChildScrollView( // Thêm cuộn để tránh lỗi tràn màn hình
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Make a Sentence!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 10),

            // Ảnh minh họa
            Container(
              height: 140, // Tăng kích thước ảnh chút cho rõ
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
              ),
              child: Image.asset(
                  q['image'],
                  fit: BoxFit.contain,
                  errorBuilder: (_,__,___) => const Icon(Icons.image, size: 80, color: Colors.grey)
              ),
            ),

            const SizedBox(height: 30),

            // KHU VỰC TRẢ LỜI (Dòng kẻ chứa từ)
            Container(
              constraints: const BoxConstraints(minHeight: 80), // Chiều cao tối thiểu
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: isWrong ? Colors.red.shade50 : Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: isWrong ? Colors.red : Colors.indigo.shade200, width: 2)
              ),
              child: Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: userSentence.map((word) {
                    return GestureDetector(
                      onTap: () => _onWordTap(word, false),
                      child: Chip(
                        label: Text(word, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        backgroundColor: Colors.indigo,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            if (isWrong)
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text("Oops! Wrong order.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
              ),

            const SizedBox(height: 30),

            // NGÂN HÀNG TỪ VỰNG (Các nút bấm bên dưới)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: currentScrambled.map((word) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.indigo, width: 1.5)),
                    elevation: 3,
                  ),
                  onPressed: () => _onWordTap(word, true),
                  child: Text(word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                );
              }).toList(),
            ),

            // NÚT HOÀN THÀNH GAME (Hiện khi thắng)
            if (isCompleted)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    const Text("🌟 PERFECT! 🌟", style: TextStyle(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 10,
                      ),
                      onPressed: widget.onCompleted, // Gọi hàm để hiện bảng chiến thắng chung cuộc
                      icon: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 32),
                      label: const Text("Finish Game", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
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