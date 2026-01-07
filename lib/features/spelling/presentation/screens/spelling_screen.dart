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
              child: state.currentItem != null
                  ? Image.asset(
                      state.currentItem!.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_,__,___) => const Icon(Icons.image, size: 100),
                    )
                  : const CircularProgressIndicator(),
            ),

            // Các ô đáp án
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: List.generate(state.currentWord.length, (i) {
                String char = i < state.userGuess.length ? state.userGuess[i] : "";
                return GestureDetector(
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

            // Chữ cái xáo trộn để chọn
            if (!state.isSuccess)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  spacing: 15, runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: state.scrambledLetters.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => notifier.pickLetter(entry.key),
                      child: _LetterTile(char: entry.value),
                    );
                  }).toList(),
                ),
              ),

            if (state.isSuccess)
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: ElevatedButton.icon(
                  onPressed: () => notifier.nextLevel(),
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text("Next Word", style: TextStyle(color: Colors.white, fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

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
        child: Text(char, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
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
        boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4))],
      ),
      child: Center(
        child: Text(char, style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}