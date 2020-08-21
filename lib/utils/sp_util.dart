import 'package:shared_preferences/shared_preferences.dart';

class Sp {
  SharedPreferences _sharedPreferences;

  Sp._();

  static Sp _sp = Sp._();

  factory Sp.instance() => _sp;

  Future<void> _init() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future<bool> setString(String key, String value) async {
    await _init();
    return _sharedPreferences.setString(key, value);
  }

  Future<String> getString(String key) async {
    await _init();
    return _sharedPreferences.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    await _init();
    return _sharedPreferences.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    await _init();
    return _sharedPreferences.getBool(key);
  }

  Future<bool> setInt(String key, int value) async {
    await _init();
    return _sharedPreferences.setInt(key, value);
  }

  Future<int> getInt(String key) async {
    await _init();
    return _sharedPreferences.getInt(key);
  }

  Future<bool> setDouble(String key, double value) async {
    await _init();
    return _sharedPreferences.setDouble(key, value);
  }

  Future<double> getDouble(String key) async {
    await _init();
    return _sharedPreferences.getDouble(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    await _init();
    return _sharedPreferences.setStringList(key, value);
  }

  Future<List<String>> getStringList(String key) async {
    await _init();
    return _sharedPreferences.getStringList(key);
  }

  Future<bool> containsKey(String key) async {
    await _init();
    return _sharedPreferences.containsKey(key);
  }

  Future get(String key) async {
    await _init();
    return _sharedPreferences.get(key);
  }

  Future<Set<String>> getKeys() async {
    await _init();
    return _sharedPreferences.getKeys();
  }

  Future<bool> clear() async {
    await _init();
    return _sharedPreferences.clear();
  }

  Future<bool> remove(String key) async {
    await _init();
    return _sharedPreferences.remove(key);
  }
}
