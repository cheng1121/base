import 'dart:io';

import 'package:base/album/bean/album_model.dart';
import 'package:base/album/bean/argument.dart';
import 'package:base/view_models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumWidgetModel extends BaseViewModel {
  AlbumWidgetModel({
    this.argument,
  });

  final MediaRouteArgument argument;

  ///所有相册
  var allGallery = Map<String, AssetPathEntity>();

  AssetPathEntity selectedGallery;
  static const int pageSize = 500;

  Future<String> getThumbnailPath() async {
    Directory tempDir = await getTemporaryDirectory();
    String thumbnailDirectory = '${tempDir.path}/thumbnail';
    Directory directory = Directory(thumbnailDirectory);

    ///如果目录不存在则创建该目录
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return thumbnailDirectory;
  }

  void initData() async {
    setBusy();
    var requestType = RequestType.image | RequestType.video;
    if (argument.albumType == AlbumType.all) {
      ///不能使用RequestType.all，RequestType.all会报FileNotFoundException导致相册崩溃
      requestType = RequestType.image | RequestType.video;
    } else if (argument.albumType == AlbumType.video) {
      requestType = RequestType.video;
    } else if (argument.albumType == AlbumType.image) {
      requestType = RequestType.image;
    } else if (argument.albumType == AlbumType.audio) {
      requestType = RequestType.audio;
    }
    final assetPathEntity =
        await PhotoManager.getAssetPathList(type: requestType);

    ///所有相册
    for (AssetPathEntity entity in assetPathEntity) {
      allGallery[entity.id] = entity;
    }
//    list.clear();
//    selectedGallery = allGallery.values.first;
//    await refresh(init: true);
  }

  @override
  Future<List<AlbumModel>> loadData({int pageNum}) async {
    var list = <AlbumModel>[];
    var data = await selectedGallery.getAssetListPaged(pageNum, pageSize);
    for (AssetEntity entity in data) {
      ///不添加时长超过15s的视频
      if (entity.typeInt == AssetType.video.index && entity.duration > 15) {
        continue;
      }
      final model = AlbumModel(
          type: entity.typeInt, duration: entity.duration, assetEntity: entity);
      model.globalKey = GlobalKey();
      list.add(model);
    }

    return list;
  }

  void clearAllSelected() {
//    list.forEach((element) => element.selected = false);
  }

//  List<AlbumModel> getAllSeleted() {
//    final selectedList = <AlbumModel>[];
//    for (AlbumModel model in list) {
//      if (model.selected) {
//        selectedList.add(model);
//      }
//    }
//    return selectedList;
//  }
}
