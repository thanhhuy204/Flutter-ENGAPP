import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_kids_matching_game/core/services/storage_service.dart';
import 'package:flutter_kids_matching_game/core/constants/local_storage_keys.dart';
import 'package:flutter_kids_matching_game/features/settings/domain/repositories/settings_repository.dart';

class LocalSettingsRepository implements SettingsRepository {
  final StorageService _storage;

  LocalSettingsRepository(this._storage);

  Future<void> init() async => await _storage.init();

  @override
  Future<void> setSelectedLanguage(String languageName) async {
    _storage.write(kSelectedLanguageKey, languageName);
  }

  // Đã xóa setSelectedLevel

  @override
  Future<void> setSelectedThemeColor(String themeColorName) async {
    _storage.write(kSelectedThemeColorKey, themeColorName);
  }

  @override
  Future<void> setSelectedThemeCode(int themeColorCode) async {
    _storage.write(kSelectedThemeCodeKey, themeColorCode);
  }

  @override
  Future<void> setSelectedLocale(String localeCode) async {
    _storage.write(kSelectedLocaleKey, localeCode);
  }

  @override
  Future<void> resetSettings() async {
    await _storage.reset();
  }

  @override
  String getSelectedLanguage() {
    return _storage.read(kSelectedLanguageKey);
  }

  @override
  String getSelectedLocale() {
    return _storage.read(kSelectedLocaleKey);
  }

  @override
  int getSelectedThemeCode() {
    return _storage.read(kSelectedThemeCodeKey);
  }

  @override
  String getSelectedThemeColor() {
    return _storage.read((kSelectedThemeColorKey));
  }
}

final localSettingsRepositoryProvider = Provider<LocalSettingsRepository>((ref) {
  final storage = ref.watch(storageServicesProvider);
  return LocalSettingsRepository(storage);
});