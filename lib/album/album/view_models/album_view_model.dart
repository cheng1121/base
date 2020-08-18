import 'package:base/album/album/album.dart';
import 'package:base/album/bean/album_model.dart';
import 'package:base/album/utils/photo_manager_util.dart';
import 'package:base/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumViewModel extends BaseViewModel {
  final AlbumType type;

  AlbumViewModel(this.type);

  AssetPathEntity selectedGallery;
  static const int pageSize = 500;
  int _current = 0;
  final list = <AlbumModel>[];

  void setCurrent(AssetPathEntity entity, List<AlbumModel> selected) async {
    selectedGallery = entity;
    await refreshAlbum();
  }

  List<AlbumModel> getList() {
    final imgs = <AlbumModel>[];
    for (AlbumModel model in list) {
      if (model.type == 1) {
        imgs.add(model);
      }
    }
    return imgs;
  }

  Future<void> refreshAlbum() async {
    list.clear();
    _current = 0;
    await loadData();
  }

  Future<void> loadAlbum() async {
    if (selectedGallery == null) {
      final assetPath = await PhotoManagerUtil.getAsset(type);
      selectedGallery = assetPath.first;
    }
    await loadData();
  }

  Future<void> loadData() async {
    var data = await selectedGallery.getAssetListPaged(_current, pageSize);
    for (AssetEntity entity in data) {
      final model = AlbumModel(
          type: entity.typeInt, duration: entity.duration, assetEntity: entity);
      list.add(model);
    }
    _current++;
    setIdle();
  }

  AlbumModel getItem(int index) {
    return list[index];
  }
}
