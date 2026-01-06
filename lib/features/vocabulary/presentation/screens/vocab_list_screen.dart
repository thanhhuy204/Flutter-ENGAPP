import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/notifiers/vocab_notifier.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/widgets/vocab_card.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart'; // This was MISSING in my previous response for VocabNotifier!
class VocabListScreen extends ConsumerWidget {
  const VocabListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vocabNotifierProvider);
    final notifier = ref.read(vocabNotifierProvider.notifier);
    final langCode = ref.watch(settingsNotifierProvider).selectedLanguage.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dictionary"), // Có thể dùng .tr() nếu muốn
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          // 1. Grid
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9, // Chỉnh lại tỷ lệ cho đẹp
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

          // 2. Detail Panel (Nếu có chọn)
          if (state.selectedVocab != null)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, color: Colors.orange, size: 32),
                        onPressed: () => notifier.onWordTap(state.selectedVocab!, ref),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        state.selectedVocab!.name(langCode),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                ],
              ),
            ),
        ],
      ),
    );
  }
}