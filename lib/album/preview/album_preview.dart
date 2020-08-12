import 'dart:async';

import 'package:base/album/bean/album_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///相册的预览页面
class AlbumPreview extends StatefulWidget {
  AlbumPreview(this.selectedList);

  final List<AlbumModel> selectedList;

  @override
  State<StatefulWidget> createState() {
    return _AlbumPreviewState();
  }
}

class _AlbumPreviewState extends State<AlbumPreview> {
  PageController _pageController;

  StreamController<int> _streamController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _streamController = StreamController<int>.broadcast();
    _streamController.add(0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                PageView.builder(
                  controller: _pageController,
                  itemBuilder: _buildItem,
                  itemCount: widget.selectedList.length,
                  onPageChanged: (index) {
                    _streamController.add(index);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: StreamBuilder<int>(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return PageDot(
                            count: widget.selectedList.length,
                            activeIndex: snapshot.data,
                          );
                        }
                        return PageDot(
                          count: widget.selectedList.length,
                          activeIndex: 0,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: kToolbarHeight + safeTop,
          child: AppBar(
            backgroundColor: Colors.transparent,
//            leading: BackNoShadow(),
            title: Text(
              '预览',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            centerTitle: true,
          ),
        )
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = widget.selectedList[index];

    if (item.type == 2) {
//      return Future2Video(model: item);
//    } else if (item.type == 1) {
//      return Future2Image(
//        albumModel: item,
//      );
    } else {
      return Container();
    }
  }
}

class PageDot extends StatelessWidget {
  final int count;
  final int activeIndex;

  PageDot({this.count, this.activeIndex});

  List<Widget> _list() {
    List<Widget> list = [];
    for (int i = 0; i < count; i++) {
      list.add(Container(
        margin: EdgeInsets.all(4),
        child: ClipOval(
          child: Container(
//            color: i == activeIndex ? mainColor : underLineColor,
            height: 6,
            width: 6,
          ),
        ),
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _list(),
    );
  }
}
