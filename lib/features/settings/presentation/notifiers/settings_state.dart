import 'dart:ui';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart';

class SettingsState {
  final AppLanguage selectedLanguage;
  // final GameLevel selectedLevel; // Xóa
  final ThemeColor selectedThemeColor;
  final Locale selectedLocale;

  const SettingsState({
    required this.selectedLanguage,
    // required this.selectedLevel, // Xóa
    required this.selectedThemeColor,
    required this.selectedLocale,
  });

  SettingsState copyWith({
    AppLanguage? selectedLanguage,
    // GameLevel? selectedLevel, // Xóa
    ThemeColor? selectedThemeColor,
    Locale? selectedLocale,
  }) {
    return SettingsState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      // selectedLevel: selectedLevel ?? this.selectedLevel, // Xóa
      selectedThemeColor: selectedThemeColor ?? this.selectedThemeColor,
      selectedLocale: selectedLocale ?? this.selectedLocale,
    );
  }

  @override
  bool operator ==(covariant SettingsState other) {
    if (identical(this, other)) return true;

    return other.selectedLanguage.languageCode == selectedLanguage.languageCode &&
        // other.selectedLevel.actualName == selectedLevel.actualName && // Xóa
        other.selectedThemeColor.code == selectedThemeColor.code &&
        other.selectedLocale.languageCode == selectedLocale.languageCode;
  }

  @override
  int get hashCode {
    return selectedLanguage.hashCode ^
    // selectedLevel.hashCode ^ // Xóa
    selectedThemeColor.hashCode ^
    selectedLocale.hashCode;
  }
}