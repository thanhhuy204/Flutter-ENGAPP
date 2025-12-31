abstract class SettingsRepository {
  String getSelectedLanguage();
  // int getSelectedLevel(); // Xóa
  // int getNextGameLevel(); // Xóa
  int getSelectedThemeCode();
  String getSelectedThemeColor();
  String getSelectedLocale();
  void resetSettings();

  void setSelectedLanguage(String languageName);
  // void setSelectedLevel(int gameLevel); // Xóa
  void setSelectedThemeCode(int themeColorName);
  void setSelectedThemeColor(String themeColorCode);
  void setSelectedLocale(String localeCode);
}