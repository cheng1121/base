import 'package:base/utils/common_util.dart';
import 'package:flutter/foundation.dart';

const String placeHolderStr = '%s';

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

  String replacePlaceHolder(List<String> strs) {
    String str ='';
    final strArrays = this.split(placeHolderStr);
    if (strArrays.length - 1 != strs.length) {
      throw Exception('place holder 数量和字符串数量不匹配');
    }
    for (int i = 0; i < strArrays.length; i++) {
      String s = strArrays[i];
      if(i < strs.length){
        str += '$s${strs[i]}';
      }else{
        str +=s;
      }
    }
    Log.i('replacePlaceHolder','=$str');

    return str;
  }
}
