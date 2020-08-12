import 'package:base/route/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPage {
  ///把当前显示的页面替换为将要跳转到的页面  当前页面将执行dispose方法
  static replacePage(BuildContext context, String routeName,
      {RouteArgument argument}) {
    return Navigator.of(context).pushReplacementNamed(routeName,
        arguments: argument ?? RouteArgument());
  }

  ///跳转到下一个页面，保留当前页面不销毁
  static nextPage(BuildContext context, String routeName,
      {RouteArgument argument}) {
    return Navigator.of(context)
        .pushNamed(routeName, arguments: argument ?? RouteArgument());
  }

  ///退出当前页面
  static pop<T>(BuildContext context, {T result, bool rootNavigator = false}) {
    Navigator.of(context, rootNavigator: rootNavigator).pop(result);
  }

  ///退出所有页面并进入指定页面
  static pushAndPopUtil(
    BuildContext context,
    String routeName, {
    RoutePredicate predicate,
    RouteArgument argument,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, predicate ?? (Route<dynamic> route) => false,
        arguments: argument ?? RouteArgument());
  }

  ///退出所有页面，直到指定页面
  static popUtil(BuildContext context, RoutePredicate predicate) {
    return Navigator.of(context).popUntil(predicate);
  }

  ///退出app
  static popApp() {
    return SystemNavigator.pop();
  }
}
