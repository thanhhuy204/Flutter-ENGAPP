import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// App supported languages enum constant
enum AppLanguage {
  english,
  japanese,
  vietnamese,
}

extension AppLanguageExtension on AppLanguage {
  String get translatedName {
    switch (this) {
      case AppLanguage.english:
        return 'english'.tr();
      case AppLanguage.japanese:
        return 'japanese'.tr();
      case AppLanguage.vietnamese:
        return 'vietnamese'.tr(); // ✅ SỬA: dùng key + .tr()
    }
  }

  String get actualName {
    switch (this) {
      case AppLanguage.english:
        return 'english';
      case AppLanguage.japanese:
        return 'japanese';
      case AppLanguage.vietnamese:
        return 'vietnamese';
    }
  }

  String get languageCode {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.japanese:
        return 'ja';
      case AppLanguage.vietnamese:
        return 'vi';
    }
  }

  Locale get locale {
    switch (this) {
      case AppLanguage.english:
        return const Locale('en', 'US');
      case AppLanguage.japanese:
        return const Locale('ja', 'JP');
      case AppLanguage.vietnamese:
        return const Locale('vi', 'VN'); // ✅ nên để VN cho đồng bộ
    }
  }
}

/// App theme color enum constant
enum ThemeColor { pink, purple, orange, green, red, gray }

extension ThemeColorExtension on ThemeColor {
  String get translatedName {
    switch (this) {
      case ThemeColor.pink:
        return 'pink'.tr();
      case ThemeColor.purple:
        return 'purple'.tr();
      case ThemeColor.orange:
        return 'orange_color'.tr();
      case ThemeColor.green:
        return 'green'.tr();
      case ThemeColor.red:
        return 'red'.tr();
      case ThemeColor.gray:
        return 'gray'.tr();
    }
  }

  String get actualName {
    switch (this) {
      case ThemeColor.pink:
        return 'pink';
      case ThemeColor.purple:
        return 'purple';
      case ThemeColor.orange:
        return 'orange';
      case ThemeColor.green:
        return 'green';
      case ThemeColor.red:
        return 'red';
      case ThemeColor.gray:
        return 'gray';
    }
  }

  Color get color {
    switch (this) {
      case ThemeColor.pink:
        return Colors.pink;
      case ThemeColor.purple:
        return Colors.deepPurple;
      case ThemeColor.orange:
        return Colors.deepOrange;
      case ThemeColor.green:
        return Colors.green;
      case ThemeColor.red:
        return Colors.red;
      case ThemeColor.gray:
        return Colors.black54;
    }
  }

  int get code {
    switch (this) {
      case ThemeColor.pink:
        return 0;
      case ThemeColor.purple:
        return 1;
      case ThemeColor.orange:
        return 2;
      case ThemeColor.green:
        return 3;
      case ThemeColor.red:
        return 4;
      case ThemeColor.gray:
        return 5;
    }
  }

  static ThemeColor fromCode(int code) {
    return ThemeColor.values.firstWhere((color) => color.code == code);
  }
}
