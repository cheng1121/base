import 'dart:typed_data';


import '../bean/album_model.dart';
import 'lru_map.dart';

class ImageLruCache {
  static final int maxSize = 500;
  static LruMap<_ImageCacheEntity, Uint8List> _lruMap = LruMap();

  ImageLruCache();

  static Uint8List getData(AlbumModel model, [int size = 64]) {
    return _lruMap[_ImageCacheEntity(model, size)];
  }

  static putData(AlbumModel entity, Uint8List data, [int size]) {
    _lruMap[_ImageCacheEntity(entity, size)] = data;
    if (_lruMap.length > maxSize) {
      ///当已经存储够500张图片时，把第一张删除
      _lruMap.remove(_lruMap.keys.first);
    }
  }

  static clearCache() {
    _lruMap.clear();
  }
}

class _ImageCacheEntity {
  AlbumModel entity;
  int size;

  _ImageCacheEntity(this.entity, this.size);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ImageCacheEntity &&
          runtimeType == other.runtimeType &&
          entity == other.entity &&
          size == other.size;

  @override
  int get hashCode => entity.hashCode ^ size.hashCode;
}
