import 'package:base/locale/base_locale.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class BaseLocaleDelegate<T extends BaseLocale>
    extends LocalizationsDelegate<T> {
  const BaseLocaleDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh'].contains(locale.languageCode);
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
