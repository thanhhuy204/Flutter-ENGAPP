import 'package:flutter/material.dart';

class DesertFillBlank extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const DesertFillBlank({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<DesertFillBlank> createState() => _DesertFillBlankState();
}

class _DesertFillBlankState extends State<DesertFillBlank> {
  // CẬP NHẬT: Từ vựng Sa mạc cho trẻ em (Dễ hiểu & Vui nhộn)
  final List<Map<String, String>> questions = [
    {
      'word': 'CAMEL',
      'question': 'C_MEL',
      'answer': 'A',
      'hint': 'I have humps and I can walk on sand.'
    }, // Lạc đà
    {
      'word': 'SUN',
      'question': 'S_N',
      'answer': 'U',
      'hint': 'I am very hot and shine in the sky.'
    }, // Mặt trời
    {
      'word': 'SAND',
      'question': 'S_ND',
      'answer': 'A',
      'hint': 'The desert is full of this yellow dust.'
    }, // Cát
    {
      'word': 'CACTUS',
      'question': 'CA_TUS',
      'answer': 'C',
      'hint': 'I am a green plant with sharp spikes.'
    }, // Xương rồng
    {
      'word': 'SNAKE',
      'question': 'SNA_E',
      'answer': 'K',
      'hint': 'I have no legs and I say "Hiss".'
    }, // Rắn
    {
      'word': 'FOX',
      'question': 'F_X',
      'answer': 'O',
      'hint': 'I am a small animal with very big ears.'
    }, // Cáo sa mạc (Fennec Fox) - Đặc trưng sa mạc
    {
      'word': 'HOT',
      'question': 'H_T',
      'answer': 'O',
      'hint': 'The weather in the desert is very...?'
    }, // Nóng
    {
      'word': 'PALM',
      'question': 'P_LM',
      'answer': 'A',
      'hint': 'A tall tree that grows near water.'
    }, // Cây cọ
    {
      'word': 'WATER',
      'question': 'WA_ER',
      'answer': 'T',
      'hint': 'You must drink me when you are thirsty.'
    }, // Nước
  ];

  String input = '';
  bool completed = false;
  String error = '';
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final q = questions[widget.questionIndex % questions.length];
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Desert Challenge', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.orange.shade200)
              ),
              child: Text(
                'Hint: ${q['hint']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.brown, fontStyle: FontStyle.italic),
              ),
            ),

            const SizedBox(height: 30),
            Text(q['question']!, style: const TextStyle(fontSize: 40, letterSpacing: 8, fontWeight: FontWeight.bold, color: Colors.black87)),

            const SizedBox(height: 30),

            SizedBox(
              width: 100,
              child: TextField(
                controller: _controller,
                enabled: !completed,
                onChanged: (val) {
                  input = val.toUpperCase();
                  if (input == q['answer']) {
                    completed = true;
                    error = '';
                    // Đã tắt tự động chuyển màn hình, chờ bấm nút
                    setState(() {});
                  } else if (input.isNotEmpty) {
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

                    // THÊM NÚT NEXT LEVEL THỦ CÔNG
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Màu cam cho Desert
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 8,
                      ),
                      onPressed: widget.onCompleted,
                      icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 28),
                      label: const Text("Next Level", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
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