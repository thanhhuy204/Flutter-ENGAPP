import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/notifiers/vocab_notifier.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/widgets/vocab_card.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart';
import 'package:flutter_kids_matching_game/core/services/image_service.dart';

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

      // Nút thêm từ vựng mới - Lưu vĩnh viễn vào bộ nhớ (chỉ trên mobile/desktop)
      floatingActionButton: kIsWeb ? null : FloatingActionButton(
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

  // --- PHẦN 4: DIALOG THÊM TỪ VỰNG (CÓ CHỌN CATEGORY VÀ HÌNH ẢNH) ---
  void _showAddWordDialog(BuildContext context, VocabNotifier notifier) {
    final enController = TextEditingController();
    final viController = TextEditingController();
    final jaController = TextEditingController();
    String selectedCategory = 'Animals';
    String? selectedImagePath;
    final imageService = ImageService();

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
                // Chọn và hiển thị hình ảnh
                GestureDetector(
                  onTap: () async {
                    // Hiển thị dialog chọn nguồn hình ảnh
                    final source = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Chọn hình ảnh'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Từ thư viện'),
                              onTap: () => Navigator.pop(context, 'gallery'),
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Chụp ảnh'),
                              onTap: () => Navigator.pop(context, 'camera'),
                            ),
                          ],
                        ),
                      ),
                    );

                    if (source != null) {
                      String? imagePath;
                      if (source == 'gallery') {
                        imagePath = await imageService.pickImageFromGallery();
                      } else {
                        imagePath = await imageService.pickImageFromCamera();
                      }

                      if (imagePath != null) {
                        setDialogState(() => selectedImagePath = imagePath);
                      }
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: selectedImagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.file(
                              File(selectedImagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text('Chọn hình ảnh', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

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
                TextField(
                  controller: jaController,
                  decoration: const InputDecoration(labelText: "Tiếng Nhật (vd: リンゴ) - Tùy chọn"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
            ElevatedButton(
              onPressed: () async {
                if (enController.text.isNotEmpty && viController.text.isNotEmpty) {
                  await notifier.addNewWord(
                    en: enController.text.trim(),
                    vi: viController.text.trim(),
                    ja: jaController.text.trim().isEmpty ? enController.text.trim() : jaController.text.trim(),
                    category: selectedCategory,
                    imagePath: selectedImagePath,
                  );
                  if (context.mounted) Navigator.pop(context);
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