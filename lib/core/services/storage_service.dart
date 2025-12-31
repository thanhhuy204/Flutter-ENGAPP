import 'package:get_storage/get_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_kids_matching_game/core/constants/local_storage_keys.dart';

class StorageService {
  late GetStorage _localStorage = GetStorage();

  Future<StorageService> init() async {
    _localStorage = GetStorage();
    await _localStorage.writeIfNull(kSelectedLanguageKey, 'english');
    // await _localStorage.writeIfNull(kSelectedLevelKey, 1); // Xóa dòng này
    await _localStorage.writeIfNull(kSelectedThemeColorKey, 'pink');
    await _localStorage.writeIfNull(kSelectedThemeCodeKey, 0);
    await _localStorage.writeIfNull(kSelectedLocaleKey, 'en');

    return this;
  }

  T read<T>(String key) {
    return _localStorage.read(key);
  }

  void write(String key, dynamic value) async {
    await _localStorage.write(key, value);
  }

  Future<void> reset() async {
    await _localStorage.erase();
    await init();
  }
}

final storageServicesProvider = Provider<StorageService>((ref) {
  final storage = StorageService();
  storage.init();
  return storage;
});