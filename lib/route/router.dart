import 'package:base/utils/common_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PageAnimStyle {
  ANDROID,
  IOS,
  NO,
  FADE,
  SLIDE,
  SCALE,
  CUSTOM,
}

class RouteArgument {
  final Object argument;
  final PageAnimStyle style;
  final bool maintainState;
  final bool fullscreenDialog;

  ///以下参数仅在style不是Android和Ios时有效
  final AnimatedWidget customAnim;
  final Duration transitionDuration;
  final bool opaque;
  final bool barrierDismissible;
  final Color barrierColor;
  final String barrierLabel;

  static Object getArgument(BuildContext context) {
    return (ModalRoute.of(context).settings.arguments as RouteArgument)
        .argument;
  }

  RouteArgument.argument({@required this.argument})
      : this.style = PageAnimStyle.ANDROID,
        this.maintainState = true,
        this.fullscreenDialog = false,
        this.customAnim = null,
        this.transitionDuration = const Duration(milliseconds: 300),
        this.opaque = true,
        this.barrierDismissible = false,
        this.barrierColor = null,
        this.barrierLabel = null;

  RouteArgument({
    this.argument = const <String, Object>{},
    this.style = PageAnimStyle.ANDROID,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.customAnim,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
  });
}

///author: cheng
///date: 2020/8/11
///time: 9:11 PM
///desc: 封装路由管理页面
///  页面起名时需要使用 moduleName/pageName
///  否则可能会和其他模块中的页面名字冲突导致无法跳转到目标页面
class AppRouter {
  ///所有的组件
  static final List<String> _allModule = <String>[];

  ///整个app的所有页面
  static final Map<String, WidgetBuilder> _allPages = <String, WidgetBuilder>{};

  ///单一组件的所有页面
  static final Map<String, Map<String, WidgetBuilder>> _modulePages =
      <String, Map<String, WidgetBuilder>>{};

  ///注册modulePage
  static bool registerModulePages(
      String moduleName, Map<String, WidgetBuilder> pages) {
    if (!_allModule.contains(moduleName)) {
      Log.i('AppRouter', '该$moduleName 未注册');
      _allModule.add(moduleName);
    } else if (_modulePages.containsKey(moduleName)) {
      Log.i('AppRouter', '$moduleName已存在,请修改module name');
      return false;
    }

    for (String pageName in pages.keys) {
      ///检查页面命名是否符合moduleName/pageName的格式
      if (pageName.split('/')[0] == moduleName) {
        continue;
      } else {
        Log.i('AppRouter', '$pageName页面名字格式错误，页面名字格式应该是moduleName/pageName');
        return false;
      }
    }

    _modulePages[moduleName] = pages;
    _allPages.addAll(pages);
    return true;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String name = settings.name;
    final WidgetBuilder pageBuilder = _allPages[name];
    final RouteArgument argument = settings.arguments ?? RouteArgument();
    if (pageBuilder != null) {
      Route route;
      switch (argument.style) {
        case PageAnimStyle.ANDROID:
          route = MaterialPageRoute(
            settings: settings,
            builder: pageBuilder,
            maintainState: argument.maintainState,
            fullscreenDialog: argument.fullscreenDialog,
          );
          break;
        case PageAnimStyle.IOS:
          route = CupertinoPageRoute(
            settings: settings,
            builder: pageBuilder,
            maintainState: argument.maintainState,
            fullscreenDialog: argument.fullscreenDialog,
          );
          break;
        case PageAnimStyle.NO:
          route = CustomPageRoute(
            builder: pageBuilder,
            settings: settings,
            maintainState: argument.maintainState,
            fullscreenDialog: argument.fullscreenDialog,
            opaque: argument.opaque,
            barrierDismissible: argument.barrierDismissible,
            barrierColor: argument.barrierColor,
            barrierLabel: argument.barrierLabel,
          );
          break;
        case PageAnimStyle.FADE:
          route = CustomPageRoute.fade(
            builder: pageBuilder,
            transitionDuration: argument.transitionDuration,
            settings: settings,
            maintainState: argument.maintainState,
            fullscreenDialog: argument.fullscreenDialog,
            opaque: argument.opaque,
            barrierDismissible: argument.barrierDismissible,
            barrierColor: argument.barrierColor,
            barrierLabel: argument.barrierLabel,
          );
          break;
        case PageAnimStyle.SLIDE:
          route = CustomPageRoute.slide(
            builder: pageBuilder,
            transitionDuration: argument.transitionDuration,
            settings: settings,
            maintainState: argument.maintainState,
            fullscreenDialog: argument.fullscreenDialog,
            opaque: argument.opaque,
            barrierDismissible: argument.barrierDismissible,
            barrierColor: argument.barrierColor,
            barrierLabel: argument.barrierLabel,
          );
          break;
        case PageAnimStyle.SCALE:
          route = CustomPageRoute.scale(
            builder: pageBuilder,
            transitionDuration: argument.transitionDuration,
            settings: settings,
            maintainState: argument.maintainState,
            fullscreenDialog: argument.fullscreenDialog,
            opaque: argument.opaque,
            barrierDismissible: argument.barrierDismissible,
            barrierColor: argument.barrierColor,
            barrierLabel: argument.barrierLabel,
          );
          break;
        case PageAnimStyle.CUSTOM:
          assert(argument.customAnim != null);
          route = CustomPageRoute.custom(
            builder: pageBuilder,
            customAnim: argument.customAnim,
            transitionDuration: argument.transitionDuration,
            settings: settings,
            maintainState: argument.maintainState,
            fullscreenDialog: argument.fullscreenDialog,
            opaque: argument.opaque,
            barrierDismissible: argument.barrierDismissible,
            barrierColor: argument.barrierColor,
            barrierLabel: argument.barrierLabel,
          );
          break;
      }

      return route;
    } else {
      return null;
    }
  }
}

///author: cheng
///date: 2020/8/12
///time: 1:01 PM
///desc: 自定义路由动画
class CustomPageRoute extends PageRoute {
  final WidgetBuilder builder;
  final PageAnimStyle style;

  final AnimatedWidget customAnim;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  CustomPageRoute({
    @required this.builder,
    this.style = PageAnimStyle.NO,
    this.transitionDuration = const Duration(milliseconds: 0),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    this.customAnim,
    RouteSettings settings,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  CustomPageRoute.fade({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    RouteSettings settings,
    bool fullscreenDialog = false,
  })  : style = PageAnimStyle.FADE,
        customAnim = null,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  CustomPageRoute.slide({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    RouteSettings settings,
    bool fullscreenDialog = false,
  })  : style = PageAnimStyle.SLIDE,
        customAnim = null,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  CustomPageRoute.scale({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    RouteSettings settings,
    bool fullscreenDialog = false,
  })  : style = PageAnimStyle.SCALE,
        customAnim = null,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  CustomPageRoute.custom({
    @required this.builder,
    @required this.customAnim,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    RouteSettings settings,
    bool fullscreenDialog = false,
  })  : style = PageAnimStyle.CUSTOM,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    switch (style) {
      case PageAnimStyle.ANDROID:
      case PageAnimStyle.IOS:
      case PageAnimStyle.NO:
        return child;
      case PageAnimStyle.FADE:
        return _fade(animation, child);
      case PageAnimStyle.SLIDE:
        return _slide(animation, child);
      case PageAnimStyle.SCALE:
        return _scale(animation, child);
      case PageAnimStyle.CUSTOM:
        return customAnim;
      default:
        return child;
    }
  }

  Widget _scale(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      )),
      child: child,
    );
  }

  Widget _slide(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0.0, 1.0),
        end: Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      )),
      child: child,
    );
  }

  Widget _fade(Animation<double> anim, Widget child) {
    return FadeTransition(
      opacity: anim,
      child: child,
    );
  }
}
