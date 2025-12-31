class GameItem {
  final String id;
  final String image;    // Đường dẫn ảnh
  final String nameEn;   // Tên Tiếng Anh
  final String nameJa;   // Tên Tiếng Nhật (Katakana/Hiragana)
  final String audioPath; // (Tùy chọn) Đường dẫn âm thanh riêng nếu cần

  const GameItem({
    required this.id,
    required this.image,
    required this.nameEn,
    required this.nameJa,
    this.audioPath = '',
  });

  // Hàm tiện ích: Lấy tên dựa trên mã ngôn ngữ đang chọn
  String name(String langCode) {
    if (langCode == 'ja') return nameJa;
    return nameEn;
  }
}