import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/spelling_notifier.dart';

class SpellingScreen extends ConsumerWidget {
  const SpellingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(spellingProvider);
    final notifier = ref.read(spellingProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Spelling Challenge")),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.lightBlue, Colors.white], begin: Alignment.topCenter),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Ảnh minh họa
            Container(
              height: 200,
              padding: const EdgeInsets.all(20),
              child: Image.asset(state.currentVocab.image),
            ),

            // Các ô đáp án bé đang điền
            // Trong spelling_screen.dart, tìm đoạn hiển thị các ô đáp án:

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: List.generate(state.currentVocab.word.length, (i) {
                String char = i < state.userGuess.length ? state.userGuess[i] : "";
                return GestureDetector(
                  // NẾU Ô CÓ CHỮ THÌ CHO PHÉP NHẤN ĐỂ GỠ
                  onTap: char.isNotEmpty ? () => notifier.removeLetter(i) : null,
                  child: _LetterBox(
                      char: char,
                      isFilled: char.isNotEmpty,
                      isSuccess: state.isSuccess
                  ),
                );
              }),
            ),

            const Spacer(),

            // Danh sách chữ cái bị xáo trộn để bé chọn
            if (!state.isSuccess)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  spacing: 15, runSpacing: 15,
                  children: state.scrambledLetters.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => notifier.pickLetter(entry.key),
                      child: _LetterTile(char: entry.value),
                    );
                  }).toList(),
                ),
              ),

            // Nút chuyển màn khi thắng
            if (state.isSuccess)
              ElevatedButton.icon(
                onPressed: () => notifier.nextLevel(),
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Next Word"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(20)),
              ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

// Widget con cho ô chữ cái
class _LetterBox extends StatelessWidget {
  final String char;
  final bool isFilled;
  final bool isSuccess;
  const _LetterBox({required this.char, required this.isFilled, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, height: 60,
      decoration: BoxDecoration(
        color: isSuccess ? Colors.green : (isFilled ? Colors.orange : Colors.white),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.brown, width: 2),
      ),
      child: Center(
        child: Text(char, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}

class _LetterTile extends StatelessWidget {
  final String char;
  const _LetterTile({required this.char});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60, height: 60,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4))],
      ),
      child: Center(
        child: Text(char, style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}