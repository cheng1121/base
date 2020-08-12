import 'dart:async';
import 'dart:typed_data';

import 'package:base/album/album_item.dart';
import 'package:base/album/bean/album_model.dart';
import 'package:base/album/bean/argument.dart';
import 'package:base/album/viewmodels/album_widget_model.dart';
import 'package:base/album/viewmodels/cover_widget_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatefulWidget {
  final MediaRouteArgument argument;

  AlbumPage({this.argument});

  @override
  State<StatefulWidget> createState() {
    return _AlbumPageState();
  }
}

///相册页面
class _AlbumPageState extends State<AlbumPage> {
  MediaRouteArgument get argument => widget.argument;
  StreamController<int> _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _streamController.add(0);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlbumWidgetModel>(
      create: (context) => AlbumWidgetModel(argument: argument)..initData(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
//            leading: Back(),
            title: Text(
              '相册',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            centerTitle: true,
            actions: <Widget>[
              StreamBuilder<int>(
                builder: (context, snapshot) {
                  return _Build2Preview(
                    count: snapshot.data ?? 0,
                  );
                },
                stream: _streamController.stream,
              ),
            ],
          ),
          body: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              color: Colors.white,
              child: _buildBody(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    final model = context.watch<AlbumWidgetModel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: _buildList(model),
        ),
        StreamBuilder<int>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            return _AlbumBottom(
              count: snapshot.data ?? 0,
              allGallery: model.allGallery,
              onComplete: () {
                _complete(context);
              },
              onGalleryTap: (gallery) {
//                  final albumWidgetModel = context.read<AlbumWidgetModel>();
//                  albumWidgetModel.selectedGallery = gallery;
//                  albumWidgetModel.list.clear();
//                  _streamController.add(0);
//                  albumWidgetModel.refresh(init: true);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildList(AlbumWidgetModel model) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2),
        padding: EdgeInsets.only(bottom: 2),
        itemCount: 10,
        itemBuilder: (context, index) {
          final item = null;
          return AlbumItem(
            item: item,
            onSelected: () {
              return onSelected(context, item);
            },
          );
        });
  }

  bool onSelected(BuildContext context, AlbumModel item) {
//    final model = context.read<AlbumWidgetModel>();
//    final selectedList = model.getAllSeleted();
//
//    ///清空所有选中，使用GlobalKey刷新条目
//    void clearAllSelected() {
//      model.clearAllSelected();
//      for (AlbumModel m in selectedList) {
//        final checkState = m.globalKey.currentState;
//        if (checkState is BuildCheckedState) {
//          checkState.selected = false;
//          checkState.setState(() {});
//        }
//      }
//    }
//
//    ///是否已选视频  result > -1表示存在视频
//    final hasVideo =
//        selectedList.indexWhere((element) => element.type == 2) > -1;
//    final hasImage =
//        selectedList.indexWhere((element) => element.type == 1) > -1;
//
//    ///是否小于最多可选
//    final isLess = selectedList.length < model.argument.maxImage;
//
//    ///是否已达最多可选
//    final isEq = selectedList.length == model.argument.maxImage;
//    bool isChecked = false;
//    if (item.selected) {
//      ///选中时，取消选中
//      item.selected = false;
//      isChecked = false;
//    } else if (model.argument.maxImage == 1) {
//      clearAllSelected();
//      item.selected = true;
//      isChecked = true;
//    } else if (isLess && hasVideo && item.type == 1) {
//      ///表示已选中视频,当前选中的是图片
//      showAppToast('不能同时选择图片和短视频');
//      isChecked = false;
//    } else if (isLess && hasVideo && item.type == 2) {
//      ///已选中短视频，当前选中的也是短视频
//      clearAllSelected();
//      item.selected = true;
//      isChecked = true;
//    } else if (isLess && hasImage && item.type == 1) {
//      ///已选图片，本次选中图片
//      item.selected = true;
//      isChecked = true;
//    } else if (isLess && hasImage && item.type == 2) {
//      ///已选图片，本次选中视频
//      showAppToast('不能同时选择图片和短视频');
//      isChecked = false;
//    } else if (isLess) {
//      item.selected = true;
//      isChecked = true;
//    } else if (isEq) {
//      showAppToast('最多选择${model.argument.maxImage}张图片');
//      isChecked = false;
//    }
//    int count = model.getAllSeleted().length;
//    _streamController.add(count);
//    return isChecked;
  }

  void _complete(BuildContext context) async {
//    final albumWidgetModel = context.read<AlbumWidgetModel>();
//    final selectedList = albumWidgetModel.getAllSeleted();
//    if (albumWidgetModel.argument.cropped) {
//      final assetEntity = selectedList.first.assetEntity;
//
//      ///跳转到裁剪页面
//      String path = (await assetEntity.file).path;
//      final size =
//          Size(assetEntity.width.toDouble(), assetEntity.height.toDouble());
//      AppPage.replacePage(context, RouteName.imageCrop,
//          arguments: [path, albumWidgetModel.argument.croppedSize, size, true]);
//    } else if (albumWidgetModel.argument.userAlbum) {
//      ///跳转到用户相册
//      final list = <UserAlbumModel>[];
//      for (AlbumModel model in selectedList) {
//        final path = (await model.assetEntity.file).path;
//        final userAlbumModel =
//            UserAlbumModel.init(type: PhotoType.values[model.type], path: path);
//        list.add(userAlbumModel);
//      }
//
//      AppPage.replacePage(context, RouteName.userAlbumPreview,
//          arguments: [-1, true, list]);
//    } else {
//      ///退出当前
//      if (selectedList.first.type == 2) {
//        final model = selectedList.first;
//        showLoading(context, true, msg: '短视频正在处理中');
//        final original = await model.getPath();
//
//        ///压缩视频
//        final videoPath = await FFmpegUtil.compress(original);
//        showLoading(context, false);
//        selectedList.clear();
//        selectedList
//            .add(AlbumModel(path: videoPath, type: 2, videoOriginal: original));
//      }
//
//      bus.emit(EventName.album, selectedList);
//      AppPage.pop(context);
//    }
  }
}

class _Build2Preview extends StatelessWidget {
  final int count;

  const _Build2Preview({Key key, this.count = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: count == 0
          ? null
          : () {
//              final list = context.read<AlbumWidgetModel>().getAllSeleted();
//              AppPage.nextPage(context, RouteName.album_preview,
//                  arguments: list);
            },
      child: Text('预览' + (count == 0 ? '' : '($count)'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          )),
    );
  }
}

class _AlbumBottom extends StatelessWidget {
  final Map<String, AssetPathEntity> allGallery;
  final VoidCallback onComplete;
  final ValueSetter<AssetPathEntity> onGalleryTap;
  final int count;

  const _AlbumBottom(
      {Key key,
      @required this.allGallery,
      this.onComplete,
      this.onGalleryTap,
      this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;

    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 40,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  _showDialog(context);
                },
                child: Text(
                  '相册',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              FlatButton(
                disabledColor: Colors.transparent,
                onPressed: count == 0 ? null : onComplete,
                child: Text(
                  '完成' +
                      (count == 0
                          ? ''
                          : '$count/${context.watch<AlbumWidgetModel>().argument.maxImage}'),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: paddingBottom,
          color: Colors.white,
        ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
//    showModalBottomSheet(
//        context: context,
//        builder: (ctx) {
//          return ProviderWidget<AlbumCoverWidgetModel>(
//            model: AlbumCoverWidgetModel(allGallery),
//            onModelReady: (model) {
//              model.getAllCover();
//            },
//            builder: (context, model, child) {
//              return NormalViewState(
//                model: model,
//                child: ListView(
//                  children: model.allGallery.values.map((gallery) {
//                    return _buildDialogItem(ctx, model, gallery);
//                  }).toList(),
//                ),
//              );
//            },
//          );
//        });
  }

  Widget _buildDialogItem(BuildContext context, AlbumCoverWidgetModel model,
      AssetPathEntity assetPathEntity) {
    final assetEntity = model.allGalleryCover[assetPathEntity.id];
    return GestureDetector(
      onTap: () {
        if (onGalleryTap != null) {
          onGalleryTap(assetPathEntity);
        }
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.only(left: 20),
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 60,
              child: FutureBuilder<Uint8List>(
                  future: assetEntity?.thumbDataWithSize(60, 60),
                  builder: (context, snapshot) {
                    if (snapshot.data != null &&
                        snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    if (snapshot.data == null) {
                      return Container(
                        color: Colors.grey.shade200,
                      );
                    }
                    return Stack(
                      children: <Widget>[
                        Image.memory(
                          snapshot.data,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Offstage(
                            offstage: assetEntity.type == AssetType.image,
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.black38,
                              child: Icon(
                                Icons.ondemand_video,
                                color: Colors.white,
                                size: 30,
                              ),
                            )),
                      ],
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                '${assetPathEntity.name}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
