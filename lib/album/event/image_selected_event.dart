import 'dart:async';
import 'package:base/album/bean/album_model.dart';
import 'package:base/album/bean/album_route_arguments.dart';
import 'package:base/album/local/album_locale.dart';
import 'package:base/utils/common_util.dart';

class ImageSelectedEvent {
  ImageSelectedEvent._internal()
      : _streamController = StreamController<List<AlbumModel>>.broadcast();

  static final ImageSelectedEvent _instance = ImageSelectedEvent._internal();

  factory ImageSelectedEvent.getInstance() => _instance;
  StreamController<List<AlbumModel>> _streamController;

  Stream<List<AlbumModel>> get stream => _streamController.stream;
  List<AlbumModel> _selected = [];

  AlbumRouteArguments albumRouteArguments;

  List<AlbumModel> get selected => _selected;

  int getIndex(AlbumModel model) {
    int index = selected.indexWhere((element) {
      if (element.assetEntity == null) {
        return element.path == model.path;
      }
      return element.assetEntity.id == model.assetEntity.id;
    });

    return index;
  }

  void remove(AlbumModel model) {
    _selected.removeWhere(
        (element) => element.assetEntity.id == model.assetEntity.id);

    ///移除后重新设置编号
    for (int i = 0; i < _selected.length; i++) {
      final model = _selected[i];
      if (model.addIndex - (i + 1) > 0) {
        model.addIndex--;
      }
    }
    addStream(_selected);
  }

  void clear() {
    _selected.clear();
    addStream(_selected);
  }

  void add(AlbumModel item) {
    _selected.add(item);

    ///设置添加编号
    item.addIndex = _selected.length;
    addStream(_selected);
  }

  bool hasVideo() {
    return _selected.indexWhere((element) => element.type == 2) > -1;
  }

  bool hasImage() {
    return _selected.indexWhere((element) => element.type == 1) > -1;
  }

  ///是否小于最多可选
  bool isLess() {
    return _selected.length < albumRouteArguments.maxCount;
  }

  ///是否已达最多可选
  bool isMax() {
    return _selected.length == albumRouteArguments.maxCount;
  }

  void onTap(int index, AlbumModel item, AlbumLocale locale) {
    final index = ImageSelectedEvent.getInstance().getIndex(item);
    if (index > -1) {
      ///选中时，取消选中
      remove(item);
    } else if (albumRouteArguments.maxCount == 1) {
      clear();
      add(item);
    } else if (isLess() && hasVideo() && item.type == 1) {
      ///表示已选中视频,当前选中的是图片
      showAppToast('${locale.conflictHint}');
      return;
    } else if (isLess() && hasVideo() && item.type == 2) {
      ///已选中短视频，当前选中的也是短视频
//      viewModel.clearAllSelected();
      clear();
      add(item);
    } else if (isLess() && hasImage() && item.type == 1) {
      ///已选图片，本次选中图片
      add(item);
    } else if (isLess() && hasImage() && item.type == 2) {
      ///已选图片，本次选中视频
      showAppToast('${locale.conflictHint}');
      return;
    } else if (isLess()) {
      add(item);
    } else if (isMax()) {
      showAppToast('${locale.maxHint(albumRouteArguments.maxCount)}');
      return;
    }
  }

  void addStream(List<AlbumModel> list) {
    _streamController.add(list);
  }

  void close() {
    _streamController.close();
    _selected.clear();
  }
}
