import 'dart:io';
import 'dart:typed_data';

import 'package:base/album/bean/album_model.dart';
import 'package:base/utils/resize_file_image.dart';
import 'package:base/video/util/ffmpeg_util.dart';
import 'package:base/widgets/busy_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Future2Image extends StatefulWidget {
  final Future future;
  final BoxFit fit;
  final double width;
  final double height;
  final double scale;
  final int cacheWidth;
  final int cacheHeight;
  final ExtendedImageMode mode;
  final bool shouldRebuild;

  const Future2Image(
      {Key key,
      @required this.future,
      this.fit = BoxFit.contain,
      this.width = double.infinity,
      this.height = double.infinity,
      this.scale = 1.0,
      this.cacheWidth,
      this.cacheHeight,
      this.mode = ExtendedImageMode.none,
      this.shouldRebuild = false})
      : super(key: key);

  @override
  _Future2ImageState createState() => _Future2ImageState();
}

class _Future2ImageState extends State<Future2Image> {
  Future _future;
  Object _futureResult;

  @override
  void initState() {
    super.initState();
    _future = widget.future;
  }

  @override
  void didUpdateWidget(Future2Image oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.future != oldWidget.future && widget.shouldRebuild) {
      _future = widget.future;
      _futureResult = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_futureResult == null) {
      return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            _futureResult = snapshot.data;
            return showImage();
          } else {
            return AppBusyWidget();
          }
        },
      );
    }
    return showImage();
  }

  Widget showImage() {
    Widget image(File file) {
      return ExtendedImage.file(
        file,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        scale: widget.scale,
        cacheHeight: widget.cacheHeight,
        cacheWidth: widget.cacheWidth,
        mode: widget.mode,
      );
    }

    if (_futureResult is File) {
      return image(_futureResult);
    } else if (_futureResult is String) {
      return image(File(_futureResult));
    } else {
      return Container();
    }
  }
}
