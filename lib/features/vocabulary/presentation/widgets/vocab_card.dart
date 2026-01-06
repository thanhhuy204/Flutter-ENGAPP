import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Thêm Riverpod
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart'; // Lấy Settings
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart'; // This was MISSING in my previous response for VocabNotifier!
class VocabCard extends ConsumerWidget {
  final GameItem item;
  final VoidCallback onTap;
  final bool isSelected;

  const VocabCard({
    super.key,
    required this.item,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy ngôn ngữ hiện tại để hiển thị đúng tên (English/Japanese)
    final langCode = ref.watch(settingsNotifierProvider).selectedLanguage.languageCode;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orangeAccent.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.orange.withOpacity(0.4)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.withOpacity(0.3),
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  item.image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (_,__,___) => const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  item.name(langCode).toUpperCase(), // Hiển thị tên theo ngôn ngữ
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.orange[800] : Colors.brown,
                    fontFamily: 'Fredoka', // Dùng font đẹp nếu có
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}