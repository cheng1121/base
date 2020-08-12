import 'package:base/video/app_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoPreview extends StatelessWidget {
  final String path;
  final UniqueKey tag;

  VideoPreview({Key key, this.path, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Center(
          child: SafeArea(
            child: AppPlayer(
              url: path,
              autoPlay: true,
              looping: true,
              onTap: (_) {},
            ),
          ),
        ),
      ),
    );
  }
}

class NetworkImagePreview extends StatefulWidget {
  final String path;
  final UniqueKey uniqueKey;

  NetworkImagePreview({Key key, @required this.path, @required this.uniqueKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NetworkImagePreviewState();
  }
}

class _NetworkImagePreviewState extends State<NetworkImagePreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Center(
          child: SafeArea(
            child: Hero(
              tag: widget.uniqueKey,
              child: Container(),

              ///CacheImage(
              //                url: widget.path,
              //                fit: BoxFit.fitWidth,
              //              )
            ),
          ),
        ),
      ),
    );
  }
}
