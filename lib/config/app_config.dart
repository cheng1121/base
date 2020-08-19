import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

enum AppChannel {
  none,
  pinto,
  dear,
}

enum MarketChannel {
  none,
  appStore,
  yingyongbao,
  huawei,
  xiaomi,
  vivo,
  oppo,
  baidu,
  ali,
}

class AppConfig extends InheritedWidget {
  final MarketChannel channel;
  final String versionName;
  final int versionCode;
  final String baseUrl;
  final int apiVersion;
  final bool isDev;

  AppConfig(
      {this.channel,
      this.versionName,
      this.versionCode,
      this.baseUrl,
      this.apiVersion = 1,
      this.isDev = false,
      Widget child})
      : super(child: child);

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(aspect: AppConfig);
  }

  static List getApiKey(String apiKey) {
    final time = DateTime.now().millisecondsSinceEpoch;
    String key = '${apiKey}_$time';
    var bytes = utf8.encode(key.toLowerCase());
    return [md5.convert(bytes).toString(), time];
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
