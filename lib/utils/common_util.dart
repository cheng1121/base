import 'package:oktoast/oktoast.dart';

///author: cheng
///date: 2020/8/11
///time: 10:05 PM
///desc: log输出只有在debug模式时输出log
class Log {
  ///判断是不是release模式
  static const bool openLog = const bool.fromEnvironment('dart.vm.product');

  static i(String tag, String info) {
    if (!openLog) {
      print('${DateTime.now()}|||$tag||||$info');
    }
  }
}

void showAppToast(String msg) {
  showToast(msg, radius: 180);
}
