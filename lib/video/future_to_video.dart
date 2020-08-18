import 'dart:io';

import 'package:base/album/bean/album_model.dart';
import 'package:base/utils/common_util.dart';
import 'package:base/video/app_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Future2Video extends StatefulWidget {
  final AlbumModel model;
  final bool autoPlay;
  final bool loop;
  final bool canController;
  final bool showVideoIcon;
  final double width;
  final double height;
  final VideoFit fit;
  final String cover;
  final ValueSetter<VideoPlayerController> onTap;

  const Future2Video(
      {Key key,
      @required this.model,
      this.autoPlay = false,
      this.loop = false,
      this.canController = true,
      this.showVideoIcon = true,
      this.width,
      this.height,
      this.fit = VideoFit.contain,
      this.cover,
      this.onTap})
      : super(key: key);

  @override
  _Future2VideoState createState() {
    return _Future2VideoState();
  }
}

class _Future2VideoState extends State<Future2Video> {
  Future<File> future;

  @override
  void initState() {
    super.initState();
    future = getFuture();
  }

  Future<File> getFuture() async {
    Future<File> future;
    if (widget.model.assetEntity != null) {
      future = widget.model.assetEntity.file;
    } else if (widget.model.assetEntity == null) {
      future = Future.value(File(widget.model.path));
    }

    return future;
  }

  @override
  void didUpdateWidget(Future2Video oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      future = getFuture();
    }
  }

  Widget player(String path) {
    return AppPlayer(
      url: path,
      autoPlay: widget.autoPlay,
      looping: widget.loop,
      showIcon: widget.showVideoIcon,
      width: widget.width,
      height: widget.height,
      onTap: widget.onTap,
      fit: widget.fit,
    );
  }

  @override
  void dispose() {
    super.dispose();
    future = null;
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.assetEntity == null) {
      return player(widget.model.path);
    } else {
      return FutureBuilder<File>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return player(snapshot.data.path);
          } else {
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              alignment: Alignment.center,
              color: Colors.grey.shade200,
              child: CupertinoActivityIndicator(),
            );
          }
        },
      );
    }
  }
}
