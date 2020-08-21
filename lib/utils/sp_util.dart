import 'package:shared_preferences/shared_preferences.dart';

class Sp {
  SharedPreferences _sharedPreferences;

  Sp._() {
    _init();
  }

  static Sp _sp = Sp._();

  factory Sp.instance() => _sp;

  void _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}
