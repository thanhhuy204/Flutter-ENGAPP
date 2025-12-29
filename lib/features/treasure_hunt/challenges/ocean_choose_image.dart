import 'package:flutter/material.dart';

class OceanChooseImage extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const OceanChooseImage({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<OceanChooseImage> createState() => _OceanChooseImageState();
}

class _OceanChooseImageState extends State<OceanChooseImage> {
  // LEVEL 4: OCEAN RIDDLES (Đố vui Đại Dương - Khó hơn)
  // Bé phải đọc hiểu câu đố để tìm ra con vật đúng.
  final List<Map<String, dynamic>> questions = [
    {
      'riddle': 'I have sharp teeth and fins.\nI am a scary hunter in the deep sea.\nWho am I?',
      'answer_index': 0, // Shark is at index 0
      'options': [
        'assets/images/animals/shark.png',
        'assets/images/animals/dolphin.png',
        'assets/images/animals/fish.png',
        'assets/images/animals/whale.png',
      ]
    },
    {
      'riddle': 'I have 8 long arms.\nI can shoot ink to hide from enemies.\nWho am I?',
      'answer_index': 2, // Octopus is at index 2
      'options': [
        'assets/images/animals/crab.png',
        'assets/images/animals/fish.png',
        'assets/images/animals/octopus.png',
        'assets/images/animals/turtle.png',
      ]
    },
    {
      'riddle': 'I have a hard shell on my back.\nI have claws and I walk sideways.\nWho am I?',
      'answer_index': 1, // Crab is at index 1
      'options': [
        'assets/images/animals/octopus.png',
        'assets/images/animals/crab.png',
        'assets/images/animals/turtle.png',
        'assets/images/animals/shark.png',
      ]
    },
    {
      'riddle': 'I am very smart and friendly.\nI love to jump out of the water.\nWho am I?',
      'answer_index': 3, // Dolphin is at index 3
      'options': [
        'assets/images/animals/shark.png',
        'assets/images/animals/whale.png',
        'assets/images/animals/fish.png',
        'assets/images/animals/dolphin.png',
      ]
    },
    {
      'riddle': 'I am the biggest animal in the ocean.\nI can sing songs under the water.\nWho am I?',
      'answer_index': 0, // Whale is at index 0
      'options': [
        'assets/images/animals/whale.png',
        'assets/images/animals/shark.png',
        'assets/images/animals/dolphin.png',
        'assets/images/animals/hippopotamus.png',
      ]
    },
  ];

  int? selectedIndex;
  bool isCompleted = false;
  bool isWrong = false;

  @override
  Widget build(BuildContext context) {
    final q = questions[widget.questionIndex % questions.length];

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ocean Riddle 🌊',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 20),

            // Khung hiển thị câu đố (Riddle Box)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5))
                ],
                border: Border.all(color: Colors.blue.shade100, width: 2),
              ),
              child: Column(
                children: [
                  const Icon(Icons.help_outline_rounded, size: 40, color: Colors.orange),
                  const SizedBox(height: 10),
                  Text(
                    q['riddle'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, color: Colors.indigo, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            if (isWrong)
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text("Oops! Not quite. Try again!", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
              ),

            // Lưới 4 đáp án hình ảnh
            SizedBox(
              width: 320,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  bool isCorrectAnswer = index == q['answer_index'];

                  // Logic màu sắc viền:
                  // - Nếu đã chọn và đúng: Xanh lá
                  // - Nếu đã chọn mà sai: Đỏ
                  // - Chưa chọn: Trong suốt hoặc Xám nhạt
                  Color borderColor = Colors.transparent;
                  if (isSelected) {
                    borderColor = isCompleted && isCorrectAnswer ? Colors.green : Colors.red;
                  }

                  return GestureDetector(
                    onTap: isCompleted ? null : () {
                      setState(() {
                        selectedIndex = index;
                      });

                      if (isCorrectAnswer) {
                        setState(() {
                          isCompleted = true;
                          isWrong = false;
                        });
                        // Không tự chuyển màn, chờ bấm nút
                      } else {
                        setState(() {
                          isWrong = true;
                        });
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            setState(() {
                              selectedIndex = null;
                              isWrong = false;
                            });
                          }
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: borderColor,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
                          ]
                      ),
                      child: Image.asset(
                        q['options'][index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image, size: 50, color: Colors.grey);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // NÚT CHUYỂN LEVEL THỦ CÔNG
            if (isCompleted)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // Màu xanh biển cho Ocean
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 8,
                        ),
                        onPressed: widget.onCompleted,
                        icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 28),
                        label: const Text("Next Level", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}