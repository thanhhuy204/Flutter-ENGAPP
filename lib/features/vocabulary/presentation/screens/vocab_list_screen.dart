import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/notifiers/vocab_notifier.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/widgets/vocab_card.dart';

class VocabListScreen extends ConsumerWidget {
  const VocabListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vocabNotifierProvider);
    final notifier = ref.read(vocabNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Học Từ Vựng"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          // 1. Grid hiển thị danh sách từ vựng
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: state.vocabList.length,
              itemBuilder: (context, index) {
                final item = state.vocabList[index];
                return VocabCard(
                  item: item,
                  isSelected: state.selectedVocab == item,
                  onTap: () => notifier.onWordTap(item, ref),
                );
              },
            ),
          ),

          // 2. Khu vực hiển thị câu ví dụ (Chỉ hiện khi có từ được chọn)
          if (state.selectedVocab != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.volume_up, color: Colors.orange),
                      const SizedBox(width: 10),
                      Text(
                        state.selectedVocab!.word,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    state.selectedVocab!.exampleSentence,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "( ${state.selectedVocab!.translation} )",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}