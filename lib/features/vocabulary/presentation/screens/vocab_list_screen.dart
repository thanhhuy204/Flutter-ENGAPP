import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/notifiers/vocab_notifier.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/widgets/vocab_card.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart';

class VocabListScreen extends ConsumerWidget {
  const VocabListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vocabNotifierProvider);
    final notifier = ref.read(vocabNotifierProvider.notifier);
    final AppLanguage selectedLang = ref.watch(settingsNotifierProvider).selectedLanguage;
    final String langCode = selectedLang.languageCode;

    final categories = ['All', 'Animals', 'Fruits', 'Colors'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Từ vựng cho bé"),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        elevation: 0,
      ),

      // Nút thêm từ vựng mới - Lưu vĩnh viễn vào bộ nhớ
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWordDialog(context, notifier),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Column(
        children: [
          // --- PHẦN 1: THANH CHỌN THỂ LOẠI ---
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = state.selectedCategory == category;

                return GestureDetector(
                  onTap: () => notifier.setCategory(category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- PHẦN 2: DANH SÁCH TỪ VỰNG (GRID VIEW) ---
          Expanded(
            child: state.vocabList.isEmpty
                ? const Center(child: Text("Chưa có từ vựng nào trong mục này."))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
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

          // --- PHẦN 3: BẢNG CHI TIẾT SONG NGỮ ---
          if (state.selectedVocab != null)
            _buildDetailPanel(state, notifier, langCode, ref),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(state, notifier, langCode, ref) {
    final item = state.selectedVocab!;
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.nameEn.toUpperCase(),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const SizedBox(height: 4),
          Text(
            "(${item.nameVi})", // Hiển thị nghĩa tiếng Việt ngay bên dưới
            style: const TextStyle(fontSize: 20, color: Colors.blueGrey, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 15),
          IconButton.filledTonal(
            icon: const Icon(Icons.volume_up_rounded, size: 35),
            onPressed: () => notifier.onWordTap(item, ref),
            style: IconButton.styleFrom(backgroundColor: Colors.orange.withOpacity(0.1), foregroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }

  // --- PHẦN 4: DIALOG THÊM TỪ VỰNG (CÓ CHỌN CATEGORY) ---
  void _showAddWordDialog(BuildContext context, VocabNotifier notifier) {
    final enController = TextEditingController();
    final viController = TextEditingController();
    String selectedCategory = 'Animals';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Thêm từ vựng mới"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: "Chọn nhóm"),
                  items: ['Animals', 'Fruits', 'Colors'].map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (val) => setDialogState(() => selectedCategory = val!),
                ),
                TextField(
                  controller: enController,
                  decoration: const InputDecoration(labelText: "Tiếng Anh (vd: Apple)"),
                ),
                TextField(
                  controller: viController,
                  decoration: const InputDecoration(labelText: "Tiếng Việt (vd: Quả táo)"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
            ElevatedButton(
              onPressed: () {
                if (enController.text.isNotEmpty && viController.text.isNotEmpty) {
                  notifier.addNewWord(
                    en: enController.text,
                    vi: viController.text,
                    ja: enController.text, // Mặc định tiếng Nhật bằng tiếng Anh nếu không nhập
                    category: selectedCategory,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Lưu vĩnh viễn", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}