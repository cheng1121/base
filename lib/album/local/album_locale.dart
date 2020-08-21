import 'package:base/locale/base_locale.dart';
import 'package:flutter/material.dart';
import 'package:base/extensions/string_extensions.dart';

class AlbumLocale extends BaseLocale {
  AlbumLocale(Locale locale) : super(locale);

  ///author: cheng
  ///date: 2020/8/16
  ///time: 2:28 PM
  ///desc: 如果未设置国际化则默认值是 中文
  static AlbumLocale of(BuildContext context) {
    final result = Localizations.of<AlbumLocale>(context, AlbumLocale);
    if (result != null) {
      return result;
    }
    return AlbumLocale(Locale('zh'));
  }

   Map<String, Map<String, String>> _localeValues = {
    'zh': {
      'album': '相册',
      'preview': '预览',
      'complete': '完成',
      'choose': '选择',
      'maxHint': '最多选择$placeHolderStr张图片',
      'conflictHint': '不能同时选择图片和短视频',
      'photoHint': '轻触拍照',
      'cameraHint': '长按摄像',
      'allHint': '轻触拍照，长按摄像',
      'videoProcessingHint': '短视频正在处理中',
    }
  };

  String get album => _localeValues[locale.languageCode]['album'] ?? '相册';

  String get preview => _localeValues[locale.languageCode]['preview'] ?? '预览';

  String get complete => _localeValues[locale.languageCode]['complete'] ?? '完成';

  String get choose => _localeValues[locale.languageCode]['choose'] ?? '选择';

  String maxHint(int max) {
    return (_localeValues[locale.languageCode]['maxHint'] ??
            '最多选择$placeHolderStr张图片')
        .replacePlaceHolder([max.toString()]);
  }

  String get conflictHint =>
      _localeValues[locale.languageCode]['conflictHint'] ?? '不能同时选择图片和短视频';

  String get photoHint =>
      _localeValues[locale.languageCode]['photoHint'] ?? '轻触拍照';

  String get cameraHint =>
      _localeValues[locale.languageCode]['cameraHint'] ?? '长按摄像';

  String get allHint =>
      _localeValues[locale.languageCode]['allHint'] ?? '轻触拍照，长按摄像';

  String get videoProcessingHint =>
      _localeValues[locale.languageCode]['videoProcessingHint'] ?? '轻触拍照，长按摄像';
}
