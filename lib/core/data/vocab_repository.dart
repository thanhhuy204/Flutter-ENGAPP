import 'package:flutter_kids_matching_game/core/data/db_helper.dart';
import 'package:flutter_kids_matching_game/core/data/global_data_source.dart';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Repository để quản lý tất cả thao tác với vocabulary database
/// Đây là lớp trung gian giữa UI và Database
/// Tự động fallback sang GlobalDataSource khi trên web
class VocabRepository {
  final DBHelper _dbHelper = DBHelper();
  final bool _useSQLite = !kIsWeb; // Chỉ dùng SQLite trên mobile/desktop

  /// Lấy tất cả từ vựng theo category
  Future<List<GameItem>> getVocabByCategory(String category) async {
    if (!_useSQLite) {
      // Fallback sang GlobalDataSource cho web
      return _getFromGlobalDataSource(category);
    }
    try {
      return await _dbHelper.getWords(category);
    } catch (e) {
      // Nếu SQLite fail, fallback
      return _getFromGlobalDataSource(category);
    }
  }

  List<GameItem> _getFromGlobalDataSource(String category) {
    if (category == 'Animals') return GlobalDataSource.animals;
    if (category == 'Fruits') return GlobalDataSource.fruits;
    if (category == 'Colors') return GlobalDataSource.colors;
    return GlobalDataSource.getAll();
  }

  /// Lấy tất cả categories
  Future<List<String>> getAllCategories() async {
    if (!_useSQLite) {
      return ['Animals', 'Fruits', 'Colors'];
    }
    try {
      return await _dbHelper.getCategories();
    } catch (e) {
      return ['Animals', 'Fruits', 'Colors'];
    }
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
    if (!_useSQLite) {
      // Web: không hỗ trợ thêm từ vựng mới (có thể implement với local storage)
      throw UnsupportedError('Adding vocabulary is not supported on web');
    }
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
    if (!_useSQLite) {
      throw UnsupportedError('Updating vocabulary is not supported on web');
    }
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
    if (!_useSQLite) {
      throw UnsupportedError('Deleting vocabulary is not supported on web');
    }
    await _dbHelper.deleteWord(id);
  }

  /// Tìm kiếm từ vựng
  Future<List<GameItem>> searchVocab(String keyword) async {
    if (!_useSQLite) {
      // Simple search trong GlobalDataSource
      final all = GlobalDataSource.getAll();
      final lowerKeyword = keyword.toLowerCase();
      return all.where((item) => 
        item.nameEn.toLowerCase().contains(lowerKeyword) ||
        item.nameVi.toLowerCase().contains(lowerKeyword) ||
        item.nameJa.toLowerCase().contains(lowerKeyword)
      ).toList();
    }
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

  /// Kiểm tra platform có hỗ trợ SQLite không
  bool get isSQLiteSupported => _useSQLite;
}
