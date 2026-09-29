import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLastAddedDate(String date) async {
    await _prefs.setString('last_added_date', date);
  }

  static String? getLastAddedDate() {
    return _prefs.getString('last_added_date');
  }

  static Future<void> incrementNotesCount() async {
    int count = _prefs.getInt('notes_count') ?? 0;
    await _prefs.setInt('notes_count', count + 1);
  }

  static int getNotesCount() {
    return _prefs.getInt('notes_count') ?? 0;
  }

  static Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool('is_dark_mode', isDark);
  }

  static bool isDarkMode() {
    return _prefs.getBool('is_dark_mode') ?? false;
  }
}
