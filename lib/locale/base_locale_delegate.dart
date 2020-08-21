import 'package:base/locale/base_locale.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class BaseLocaleDelegate<T extends BaseLocale>
    extends LocalizationsDelegate<T> {
  const BaseLocaleDelegate();

  static final supportLanguageCode = <Locale>[
    const Locale.fromSubtags(languageCode: 'zh')
  ];

  @override
  bool isSupported(Locale locale) {
    return supportLanguageCode.indexWhere(
            (element) => element.languageCode == locale.languageCode) >
        -1;
  }

  @override
  bool shouldReload(LocalizationsDelegate<T> old) {
    return false;
  }

  @override
  Future<T> load(Locale locale) {
    return SynchronousFuture<T>(moduleLocale(locale));
  }

  T moduleLocale(Locale locale);
}
