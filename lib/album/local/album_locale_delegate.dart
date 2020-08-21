import 'package:base/album/local/album_locale.dart';
import 'package:base/locale/base_locale_delegate.dart';
import 'package:flutter/cupertino.dart';

class AlbumLocaleDelegate extends BaseLocaleDelegate<AlbumLocale> {
  @override
  AlbumLocale appLocale(Locale locale) {
    return AlbumLocale(locale);
  }
}
