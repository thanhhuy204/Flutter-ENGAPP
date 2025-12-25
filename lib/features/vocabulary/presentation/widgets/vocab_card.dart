import 'package:flutter/material.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/domain/vocab_item.dart';

class VocabCard extends StatelessWidget {
  final VocabItem item;
  final VoidCallback onTap;
  final bool isSelected;

  const VocabCard({
    super.key,
    required this.item,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orangeAccent.withAlpha(50) : Colors.white,
          borderRadius: BorderRadius.circular(24), // Bo góc tròn hơn cho thân thiện
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.orange.withAlpha(60)
                  : Colors.black.withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.withAlpha(30),
            width: 2.5,
          ),
        ),
        child: Column(
          // Đảm bảo các thành phần phân bổ đều
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Phần chứa ảnh: Cố định tỷ lệ để các ảnh không to nhỏ khác nhau
            Expanded(
              flex: 4, // Chiếm 4 phần diện tích
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(15), // Nền nhẹ giúp ảnh nổi bật
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  item.image,
                  // BoxFit.contain giúp ảnh giữ nguyên tỉ lệ và nằm gọn trong khung
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Phần chứa chữ: Cố định chiều cao để hàng chữ luôn thẳng hàng
            Expanded(
              flex: 1, // Chiếm 1 phần diện tích
              child: Center(
                child: Text(
                  item.word.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Nếu chữ quá dài sẽ hiện "..."
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900, // Chữ đậm hơn cho bé dễ nhìn
                    color: Colors.brown,
                    letterSpacing: 1.1,
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