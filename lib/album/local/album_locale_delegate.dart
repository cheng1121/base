

import 'package:base/album/local/album_locale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AlbumLocaleDelegate extends LocalizationsDelegate<AlbumLocale>{
  const AlbumLocaleDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh'].contains(locale.languageCode);
  }

  @override
  Future<AlbumLocale> load(Locale locale) {
    return SynchronousFuture<AlbumLocale>(AlbumLocale(locale));
   }

  @override
  bool shouldReload(LocalizationsDelegate<AlbumLocale> old) {
    return false;
  }


}