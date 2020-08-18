import 'package:base/album/bean/album_model.dart';
import 'package:base/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class PreviewPageViewModel extends BaseViewModel {
  final List<AlbumModel> list;

  PreviewPageViewModel(this.list);

  int pageIndex = 1;
  PageController pageController = PageController();

  void onPageChange(int index) {
    pageIndex = index + 1;
    setIdle();
  }

  void onItemTap(AlbumModel model) {
    int index = list.indexWhere((element) {
      if (element.assetEntity == null) {
        return element.path == model.path;
      }
      return element.assetEntity.id == model.assetEntity.id;
    });
    if (index > -1) {
      pageController.jumpToPage(index);
    }
  }

  int getType() {
    return list.first.type;
  }
}
