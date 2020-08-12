import 'package:flutter/foundation.dart';

extension StringExt on String {
  int toInt({ValueSetter<String> onError}) {
    return int.parse(this, onError: onError);
  }

  ///author:cheng
  ///time: 2020-06-21 11:11:34
  ///desc: 检查字符串是否为空
  bool checkNull() {
    return this == null || this.isEmpty || this == 'null';
  }

  ///author:cheng
  ///time: 2020-06-15 11:27:32
  ///desc: 去掉空格后是否为空
  bool checkNullWithSpace() {
    return this == null ||
        this.isEmpty ||
        this.replaceAll('\u0020', '').isEmpty;
  }

  
}
