import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appSettingsController = AppSettingsController();

class AppSettingsController extends ChangeNotifier {
  static const _themeKey = 'settings_theme_mode';
  static const _languageKey = 'settings_language_code';

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('vi');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  String get themeLabel {
    return switch (_themeMode) {
      ThemeMode.light => _locale.languageCode == 'en' ? 'Light' : 'Sáng',
      ThemeMode.dark => _locale.languageCode == 'en' ? 'Dark' : 'Tối',
      ThemeMode.system =>
        _locale.languageCode == 'en' ? 'System' : 'Theo hệ thống',
    };
  }

  String get languageLabel =>
      _locale.languageCode == 'en' ? 'English' : 'Tiếng Việt';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = _themeModeFromString(prefs.getString(_themeKey));
    _locale = Locale(prefs.getString(_languageKey) ?? 'vi');
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale.languageCode == locale.languageCode) return;

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    notifyListeners();
  }

  ThemeMode _themeModeFromString(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
