import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumAllBottomSheet extends StatelessWidget {
  final List<AssetPathEntity> list;
  final ValueSetter<AssetPathEntity> onTap;
  final String selectedId;

  const AlbumAllBottomSheet({Key key, this.list, this.onTap, this.selectedId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = list[index];
        return GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap(item);
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
                _AlbumCover(
                  item: item,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    '${item.name}（${item.assetCount}）',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      item.id == selectedId
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: item.id == selectedId ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: list.length,
    );
  }
}

class _AlbumCover extends StatefulWidget {
  final AssetPathEntity item;

  const _AlbumCover({Key key, this.item}) : super(key: key);

  @override
  _AlbumCoverState createState() => _AlbumCoverState();
}

class _AlbumCoverState extends State<_AlbumCover> {
  Future<Uint8List> future;

  @override
  void initState() {
    super.initState();
    future = _getCover();
  }

  Future<Uint8List> _getCover() async {
    final imageList = await widget.item.getAssetListRange(start: 0, end: 1);
    return await imageList.first.thumbDataWithSize(60, 60);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: FutureBuilder<Uint8List>(
          future: _getCover(),
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
            return Image.memory(
              snapshot.data,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          }),
    );
  }
}
