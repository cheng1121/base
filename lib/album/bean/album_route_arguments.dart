import 'package:base/album/album/album.dart';
import 'package:flutter/material.dart';

class AlbumRouteArguments {
  final int maxCount;
  final AlbumType albumType;
  final String backPageName;
  final Size croppedSize;
  final bool toCorp;

  AlbumRouteArguments(
      {this.maxCount = 9,
      this.albumType = AlbumType.all,
      this.croppedSize = const Size.square(200),
      this.toCorp = false,
      @required this.backPageName});

  Map<String, Object> toMap() {
    final map = <String, Object>{};
    void addIfNotNull(String key, Object value) {
      if (value != null) {
        map[key] = value;
      }
    }

    addIfNotNull('backPageName', this.backPageName);
    addIfNotNull('maxCount', maxCount);
    addIfNotNull('albumType', albumType);
    addIfNotNull('croppedSize', croppedSize);
    addIfNotNull('toCorp', toCorp);
    return map;
  }
}
