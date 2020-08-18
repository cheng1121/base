import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageUtil {
  ///返回iamges目录中的图片路径
  static wrapAssets(String name) {
    return 'assets/common_imgs/$name';
  }

  /// 获取Asset目录中的图片
  static images(String name, {String package}) =>
      AssetImage(wrapAssets(name), package: package);

  static baseImgs(String name) => images(name, package: 'base');
}

class CommonImg {
  static const String changeCamera = 'change_camera.png';
  static const String man = 'man.png';
  static const String video = 'video.png';
  static const String women = 'women.png';
}
