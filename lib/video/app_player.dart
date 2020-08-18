import 'dart:io';
import 'dart:math';

import 'package:base/utils/common_util.dart';
import 'package:base/video/util/ffmpeg_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppPlayer extends StatefulWidget {
  final String url;
  final VideoFit fit;
  final double width;
  final double height;
  final Alignment alignment;
  final bool autoPlay;
  final bool looping;
  final Color backgroundColor;
  final ValueSetter<VideoPlayerController> onTap;
  final bool showIcon;
  final double videoIconSize;
  final ImageProvider videoIcon;

  const AppPlayer(
      {Key key,
      this.url,
      this.fit = VideoFit.contain,
      this.width,
      this.height,
      this.alignment = Alignment.center,
      this.autoPlay = false,
      this.looping = false,
      this.backgroundColor = Colors.black,
      this.onTap,
      this.videoIconSize = 30,
      this.showIcon = true,
      this.videoIcon})
      : super(key: key);

  @override
  _AppPlayerState createState() => _AppPlayerState();
}

class _AppPlayerState extends State<AppPlayer> {
  VideoPlayerController _controller;
  Future<bool> _future;
  bool _futureResult = false;
  int _rotate = 0;
  double _vWidth = -1;
  double _vHeight = -1;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    final path = widget.url;
    if (path.contains('http')) {
      _controller = VideoPlayerController.network(path);
    } else {
      _controller = VideoPlayerController.file(File(path));
    }
    _future = _initVideo();
  }

  @override
  void didUpdateWidget(AppPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _futureResult = false;
      initPlayer();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  void _listener() {
    if (!_controller.value.isPlaying && mounted) {
      setState(() {});
    }
  }

  Future<bool> _initVideo() async {
    _controller.addListener(_listener);

    final info = await FFmpegUtil.getVideoInfo(widget.url);
    await _controller.initialize();
    Size s = _controller.value.size;
    _vWidth = s.width;
    _vHeight = s.height;

    ///获取视频的旋转角度
    _rotate = _getRotate(info.videoInfo.rotate);

    await _controller.setLooping(widget.looping);
    if (widget.autoPlay) {
      await _controller.play();
    }

    return true;
  }

  int _getRotate(String rotate) {
    switch (rotate) {
      case '90':
        return 0;
      case '180':
        return 180;
      case '270':
        return 0;
      default:
        return 0;
    }
  }

  void _onTap() async {
    if (widget.onTap != null) {
      widget.onTap(_controller);
    } else {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        if (!widget.looping) {
          _controller.seekTo(Duration.zero);
        }
        _controller.play();
      }
      setState(() {});
    }
  }

  Size applyAspectRatio(BoxConstraints constraints, double aspectRatio) {
    assert(constraints.hasBoundedHeight && constraints.hasBoundedWidth);

    constraints = constraints.loosen();

    double width = constraints.maxWidth;
    double height = width;

    if (width.isFinite) {
      height = width / aspectRatio;
    } else {
      height = constraints.maxHeight;
      width = height * aspectRatio;
    }

    if (width > constraints.maxWidth) {
      width = constraints.maxWidth;
      height = width / aspectRatio;
    }

    if (height > constraints.maxHeight) {
      height = constraints.maxHeight;
      width = height * aspectRatio;
    }

    if (width < constraints.minWidth) {
      width = constraints.minWidth;
      height = width / aspectRatio;
    }

    if (height < constraints.minHeight) {
      height = constraints.minHeight;
      width = height * aspectRatio;
    }

    return constraints.constrain(Size(width, height));
  }

  double getAspectRatio(BoxConstraints constraints, double ar) {
    if (ar == null || ar < 0) {
      ar = _vWidth / _vHeight;
    } else if (ar.isInfinite) {
      ar = constraints.maxWidth / constraints.maxHeight;
    }
    return ar;
  }

  /// calculate Texture size
  Size getTxSize(BoxConstraints constraints, VideoFit fit) {
    Size childSize = applyAspectRatio(
        constraints, getAspectRatio(constraints, fit.aspectRatio));
    double sizeFactor = fit.sizeFactor;
    if (-1.0 < sizeFactor && sizeFactor < -0.0) {
      sizeFactor = max(constraints.maxWidth / childSize.width,
          constraints.maxHeight / childSize.height);
    } else if (-2.0 < sizeFactor && sizeFactor < -1.0) {
      sizeFactor = constraints.maxWidth / childSize.width;
    } else if (-3.0 < sizeFactor && sizeFactor < -2.0) {
      sizeFactor = constraints.maxHeight / childSize.height;
    } else if (sizeFactor < 0) {
      sizeFactor = 1.0;
    }
    childSize = childSize * sizeFactor;
    return childSize;
  }

  Offset getTxOffset(BoxConstraints constraints, Size childSize, VideoFit fit) {
    final Alignment resolvedAlignment = fit.alignment;
    final Offset diff = constraints.biggest - childSize;
    return resolvedAlignment.alongOffset(diff);
  }

  Widget _buildVideo() {
    return RotatedBox(
      quarterTurns: _rotate ~/ 90,
      child: VideoPlayer(_controller),
    );
  }

  Widget _buildLayout() {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
        ),
        alignment: widget.alignment,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final Size childSize = getTxSize(constraints, widget.fit);
            final Offset offset =
                getTxOffset(constraints, childSize, widget.fit);
            final Rect pos = Rect.fromLTWH(
                offset.dx, offset.dy, childSize.width, childSize.height);
            List ws = <Widget>[
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
              Positioned.fromRect(
                  rect: pos,
                  child: Container(
                    color: Color(0xFF000000),
                    child: _buildVideo(),
                  )),
              widget.videoIcon == null
                  ? Container()
                  : Offstage(
                      offstage: !widget.showIcon,
                      child: Offstage(
                        offstage: _controller.value.isPlaying,
                        child: Center(
                          child: Image(
                            image: widget.videoIcon,
                            height: widget.videoIconSize,
                            width: widget.videoIconSize,
                          ),
                        ),
                      ),
                    )
            ];
            return Stack(
              children: ws,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_futureResult) {
      return _buildLayout();
    } else {
      return FutureBuilder<bool>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            _futureResult = snapshot.data;
            return _buildLayout();
          } else {
            return CupertinoActivityIndicator();
          }
        },
      );
    }
  }
}

class VideoFit {
  final Alignment alignment;
  final double aspectRatio;
  final double sizeFactor;

  const VideoFit(
      {this.alignment = Alignment.center,
      this.aspectRatio = -1,
      this.sizeFactor = 1.0});

  static const VideoFit fill = VideoFit(
    sizeFactor: 1.0,
    aspectRatio: double.infinity,
    alignment: Alignment.center,
  );

  static const VideoFit contain = VideoFit(
    sizeFactor: 1.0,
    aspectRatio: -1,
    alignment: Alignment.center,
  );
  static const VideoFit cover = VideoFit(
    sizeFactor: -0.5,
    aspectRatio: -1,
    alignment: Alignment.center,
  );

  static const VideoFit fitWidth = VideoFit(
    sizeFactor: -1.5,
  );

  static const VideoFit fitHeight = VideoFit(
    sizeFactor: -2.5,
  );
}
