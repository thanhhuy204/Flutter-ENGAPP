import 'package:shared_preferences/shared_preferences.dart';

class SpaceStorageService {
  static const String _keyUnlockedLevel = 'space_unlocked_level';
  static const String _keyCurrentIndex = 'space_current_index';

  // Lưu cả Level đã mở và Vị trí phi hành gia
  Future<void> saveProgress(int unlockedLevel, int currentIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUnlockedLevel, unlockedLevel);
    await prefs.setInt(_keyCurrentIndex, currentIndex);
  }

  // Đọc Level đã mở (Mặc định là level 1 nếu chưa có dữ liệu)
  Future<int> getUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUnlockedLevel) ?? 1;
  }

  // Đọc vị trí hành tinh đang đứng (Mặc định là 0 - Mercury)
  Future<int> getCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCurrentIndex) ?? 0;
  }
}