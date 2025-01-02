import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Các hằng số static cho key
  static const String ID = 'id';
  static const String EMAIL = 'email';
  static const String PHONE_NUMBER = 'phone_number';
  static const String ACCESS_TOKEN = 'access_token';
  static const String REFRESH_TOKEN = 'refresh_token';
  static const String NAME = 'name';
  static const String IS_LOGGED_IN = 'is_logged_in';
  static const String REMAINING_TIME = 'remaining_time';

  // Hàm lưu giá trị String vào SharedPreferences
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Hàm lấy giá trị String từ SharedPreferences
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Hàm lưu giá trị int vào SharedPreferences
  Future<void> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  // Hàm lấy giá trị int từ SharedPreferences
  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Hàm lưu giá trị bool vào SharedPreferences
  Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Hàm lấy giá trị bool từ SharedPreferences
  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Hàm lưu giá trị double vào SharedPreferences
  Future<void> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  // Hàm lấy giá trị double từ SharedPreferences
  Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  // Hàm xóa giá trị khỏi SharedPreferences
  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Hàm xóa tất cả dữ liệu khỏi SharedPreferences
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
