import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumModel {
  final String path;
  final AssetEntity assetEntity;

  ///视频压缩前的地址
  final String videoOriginal;

  ///1: image  2: video
  final int type;
  final int duration;
  bool selected;
  GlobalKey globalKey;

  AlbumModel({
    @required this.type,
    this.duration,
    this.path,
    this.videoOriginal,
    this.assetEntity,
    this.selected = false,
  });

  Future<String> getPath() async {
    if (assetEntity == null) {
      return path;
    } else {
      return (await assetEntity.file).path;
    }
  }
}
