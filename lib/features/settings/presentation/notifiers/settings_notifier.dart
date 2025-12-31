import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_state.dart';
import 'package:flutter_kids_matching_game/features/settings/data/local_settings_repository_impl.dart';

class SettingsNotifier extends Notifier<SettingsState> {
  late final LocalSettingsRepository _repository;

  @override
  SettingsState build() {
    _repository = ref.read(localSettingsRepositoryProvider);

    return SettingsState(
      selectedLanguage: AppLanguage.values.byName(_repository.getSelectedLanguage()),
      // selectedLevel: ... // Xóa dòng này
      selectedThemeColor: ThemeColor.values.byName(_repository.getSelectedThemeColor()),
      selectedLocale: Locale(_repository.getSelectedLocale()),
    );
  }

  Future<void> setLanguage(AppLanguage language) async {
    await _repository.setSelectedLanguage(language.actualName);
    await _repository.setSelectedLocale(language.languageCode);
    state = state.copyWith(
        selectedLanguage: language,
        selectedLocale: Locale(language.languageCode));
  }

  // Đã xóa setLevel, getCurrentLevel, getNextGameLevel

  Future<void> setThemeColor(ThemeColor color) async {
    await _repository.setSelectedThemeColor(color.name);
    await _repository.setSelectedThemeCode(color.code);
    state = state.copyWith(selectedThemeColor: color);
  }

  Future<void> resetSettings() async {
    await _repository.resetSettings();
    state = const SettingsState(
      selectedLanguage: AppLanguage.english,
      // selectedLevel: GameLevel.level1, // Xóa
      selectedThemeColor: ThemeColor.pink,
      selectedLocale: Locale('en', 'US'),
    );
  }
}

final settingsNotifierProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});