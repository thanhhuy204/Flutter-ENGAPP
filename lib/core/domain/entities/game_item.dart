class GameItem {
  final String id;
  final String image;
  final String nameEn;
  final String nameJa;
  final String nameVi;

  const GameItem({
    required this.id,
    required this.image,
    required this.nameEn,
    required this.nameJa,
    required this.nameVi,
  });

  // Chuyển từ Object sang Map để lưu vào máy
  Map<String, dynamic> toJson() => {
    'id': id, 'image': image, 'nameEn': nameEn, 'nameJa': nameJa, 'nameVi': nameVi,
  };

  // Chuyển từ Map (đã lưu) ngược lại thành Object
  factory GameItem.fromJson(Map<String, dynamic> json) => GameItem(
    id: json['id'], image: json['image'], nameEn: json['nameEn'], nameJa: json['nameJa'], nameVi: json['nameVi'],
  );

  String name(String langCode) {
    if (langCode == 'vi') return nameVi;
    if (langCode == 'ja') return nameJa;
    return nameEn;
  }
}