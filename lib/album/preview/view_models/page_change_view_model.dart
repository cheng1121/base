import 'package:base/album/bean/album_model.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/album/local/album_locale.dart';
import 'package:base/album/preview/view_models/selected_border_view_model.dart';
import 'package:base/utils/common_util.dart';
import 'package:base/view_models/base_view_model.dart';
import 'package:flutter/cupertino.dart';

class PageChangeViewModel extends BaseViewModel {
  final double screenWidth;

  PageChangeViewModel(this.pageSelectedModel, this.screenWidth)
      : scrollController = ScrollController();

  AlbumModel pageSelectedModel;
  AlbumModel lastModel;
  ScrollController scrollController;

  double offset = 0;

  List<AlbumModel> get selected => ImageSelectedEvent.getInstance().selected;

  int get maxCount =>
      ImageSelectedEvent.getInstance().albumRouteArguments.maxCount;

  void init() {
    _moveItem();
  }

  void setPageChange(AlbumModel model) {
    lastModel = pageSelectedModel;
    pageSelectedModel = model;
    _moveItem();
  }

  void _moveItem() {
    final index = ImageSelectedEvent.getInstance().getIndex(pageSelectedModel);
    final lastIndex = ImageSelectedEvent.getInstance()
        .getIndex(lastModel ?? pageSelectedModel);

    ///当前屏幕宽度可展示的最大数量
    int count = screenWidth ~/ 70;
    if (index > -1 && lastIndex > -1 && selected.length > count) {
      final current = selected[index];
      final last = selected[lastIndex];
      if (current.addIndex > count) {
        ///向右滑动
        int diff = current.addIndex - count;
        offset = diff * 70.0;
      } else if (current.addIndex < last.addIndex && current.addIndex < count) {
        ///向左滑动
        offset = (current.addIndex - 1) * 70.0;
      }
    }
    Future.delayed(Duration.zero, () {
      scrollController.animateTo(offset,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
    });
  }

  ///author: cheng
  ///date: 2020/8/15
  ///time: 9:36 PM
  ///desc: 判断当前pageView展示的图片是否是，selected中的图片
  int _showBorderIndex() {
    return ImageSelectedEvent.getInstance().getIndex(pageSelectedModel);
  }

  void onSelectedTap(
      AlbumLocale locale, SelectedBorderViewModel borderViewModel) {
    int index = _showBorderIndex();
    if (index > -1) {
      ///已选中
      ImageSelectedEvent.getInstance().remove(pageSelectedModel);
    } else if (selected.length == maxCount) {
      ///未选中，判断是否等于最大值
      showAppToast('${locale.maxHint(maxCount)}');
      return;
    } else if (selected.length < maxCount) {
      ImageSelectedEvent.getInstance().add(pageSelectedModel);
    }
    borderViewModel.viewChange(pageSelectedModel);
    _moveItem();
  }
}
