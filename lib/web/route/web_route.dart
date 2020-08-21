import 'package:base/route/router.dart';
import 'package:base/web/web_view.dart';
import 'package:flutter/cupertino.dart';

class WebRoute {
  static const String moduleName = 'web';
  static const String web = '$moduleName/';

  static final _pages = <String, WidgetBuilder>{
    web: (context) => WebViewPage(),
  };

  static void register() {
    AppRouter.registerModulePages(moduleName, _pages);
  }
}
