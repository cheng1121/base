import 'package:connectivity/connectivity.dart';

///author: cheng
///time:2020/8/11
///desc: 检查网络状态工具类
class CheckNetwork {
  static Future<bool> checkConnect() async {
    final result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}
