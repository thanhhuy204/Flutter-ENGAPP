import 'package:flutter_kids_matching_game/core/data/db_helper.dart';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';

/// Repository để quản lý tất cả thao tác với vocabulary database
/// Đây là lớp trung gian giữa UI và Database
class VocabRepository {
  final DBHelper _dbHelper = DBHelper();

  /// Lấy tất cả từ vựng theo category
  Future<List<GameItem>> getVocabByCategory(String category) async {
    return await _dbHelper.getWords(category);
  }

  /// Lấy tất cả categories
  Future<List<String>> getAllCategories() async {
    return await _dbHelper.getCategories();
  }

  /// Thêm từ vựng mới
  Future<void> addVocab({
    required String id,
    required String nameEn,
    required String nameVi,
    required String nameJa,
    required String category,
    String? imagePath,
  }) async {
    final item = GameItem(
      id: id,
      image: imagePath ?? 'assets/images/logos/logo1.png',
      nameEn: nameEn,
      nameJa: nameJa,
      nameVi: nameVi,
    );
    await _dbHelper.insertWord(item, category, imagePath: imagePath);
  }

  /// Cập nhật từ vựng
  Future<void> updateVocab({
    required String id,
    String? image,
    String? nameEn,
    String? nameJa,
    String? nameVi,
  }) async {
    await _dbHelper.updateWord(
      id,
      image: image,
      nameEn: nameEn,
      nameJa: nameJa,
      nameVi: nameVi,
    );
  }

  /// Xóa từ vựng
  Future<void> deleteVocab(String id) async {
    await _dbHelper.deleteWord(id);
  }

  /// Tìm kiếm từ vựng
  Future<List<GameItem>> searchVocab(String keyword) async {
    return await _dbHelper.searchWords(keyword);
  }

  /// Lấy số lượng từ vựng theo category
  Future<int> getVocabCount(String category) async {
    final list = await getVocabByCategory(category);
    return list.length;
  }

  /// Kiểm tra xem database đã có dữ liệu chưa
  Future<bool> isDatabaseInitialized() async {
    final all = await getVocabByCategory('All');
    return all.isNotEmpty;
  }
}
