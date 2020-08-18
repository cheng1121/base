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
  int addIndex = -1;

  AlbumModel({
    @required this.type,
    this.duration,
    this.path,
    this.videoOriginal,
    this.assetEntity,
  });

  AlbumModel.withPath({
    this.path,
    this.videoOriginal,
    this.type = 1,
    this.duration = 0,
  }) : this.assetEntity = null;

  Future<String> getPath() async {
    if (assetEntity == null) {
      return path;
    } else {
      return (await assetEntity.file).path;
    }
  }

  AlbumModel copyWith({
    String path,
    AssetEntity assetEntity,
    String videoOriginal,
    int type,
    int duration,
    int addIndex,
  }) {
    return AlbumModel(
      path: path ?? this.path,
      assetEntity: assetEntity ?? this.assetEntity,
      videoOriginal: videoOriginal ?? this.videoOriginal,
      type: type ?? this.type,
      duration: duration ?? this.duration,
    );
  }
}
