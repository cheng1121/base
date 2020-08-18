import 'dart:typed_data';

import 'package:base/album/album/widgets/album_item_checked.dart';
import 'package:base/album/album/widgets/album_item_flag.dart';
import 'package:base/album/bean/album_model.dart';
import 'package:base/album/cache/image_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumItem extends StatelessWidget {
  final AlbumModel item;
  final int index;

  const AlbumItem({Key key, this.item, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: <Widget>[
          _BuildImage(
            model: item,
          ),
          AlbumItemFlag(
            type: item.type,
            duration: item.duration,
          ),
          AlbumItemChecked(
            index: index,
          ),
        ],
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
