import 'dart:typed_data';

import 'package:base/album/bean/album_model.dart';
import 'package:base/album/cache/image_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnAlbumItemSelected = bool Function();

class AlbumItem extends StatelessWidget {
  final OnAlbumItemSelected onSelected;
  final AlbumModel item;

  const AlbumItem({Key key, this.onSelected, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: <Widget>[
          _BuildImage(
            model: item,
          ),
          Offstage(
            offstage: item.type == 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              color: Colors.black26,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    Icons.videocam,
                    size: 24,
                    color: Colors.white,
                  ),
                  Text(
                    _castTime(item.duration),
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          BuildChecked(
            key: item.globalKey,
            selected: item.selected,
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }

  String _castTime(int second) {
    if (second > 3600) {
      int h = second ~/ 3600;

      int m = (second - 3600 * h) ~/ 60;
      int s = second - 60 * m;

      return '$h:$m:$s';
    } else if (second > 60) {
      //大于60s
      return '${second ~/ 60}:${second % 60}';
    } else {
      return '0:${second > 9 ? second : '0$second'}';
    }
  }
}

class BuildChecked extends StatefulWidget {
  final bool selected;
  final OnAlbumItemSelected onSelected;

  const BuildChecked({Key key, this.selected, this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BuildCheckedState();
  }
}

class BuildCheckedState extends State<BuildChecked> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bool result = widget.onSelected();
        setState(() {
          if (result) {
            selected = true;
          } else {
            selected = false;
          }
        });
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.topRight,
        child: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.white,
            ),
            child: Container(
              padding: EdgeInsets.only(top: 10, right: 10),
              child: selected
                  ? Container(
                      width: 20,
                      height: 20,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            width: 13,
                            height: 13,
                          ),
                          Icon(
                            Icons.check_box,
                            color: Colors.green,
                            size: 20,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
            )),
      ),
    );
  }
}

class _BuildImage extends StatelessWidget {
  final AlbumModel model;

  const _BuildImage({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thumb = ImageLruCache.getData(model);
    if (thumb != null) {
      return _buildItem(thumb);
    }
    return FutureBuilder<Uint8List>(
      future: model.assetEntity.thumbDataWithSize(150, 150),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          ImageLruCache.putData(model, snapshot.data);
          return _buildItem(snapshot.data);
        } else {
          return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            alignment: Alignment.center,
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }

  Widget _buildItem(Uint8List data) {
    return Image.memory(
      data,
      width: double.maxFinite,
      height: double.maxFinite,
      fit: BoxFit.cover,
    );
  }
}
