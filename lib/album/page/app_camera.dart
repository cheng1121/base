import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:base/album/bean/argument.dart';
import 'package:base/utils/common_util.dart';
import 'package:base/utils/date_util.dart';
import 'package:base/utils/image_util.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;

Future<void> getAvailableCameras() async {
  cameras = await availableCameras();
}

class CustomCamera extends StatefulWidget {
  final MediaRouteArgument argument;

  const CustomCamera({
    Key key,
    this.argument,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomCameraState();
  }
}

class _CustomCameraState extends State<CustomCamera>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController _controller;
  AnimationController _animationController;
  bool _isVideoComplete = false;
  String _videoPath = '';
  bool _isBack = true;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    final result = _getCamera(true);
    if (result == null) {
      showAppToast('未检测到摄像头');
      Navigator.of(context).pop();
    }
    _isBack = true;
    onNewCameraSelected(result);
    _animationController =
        AnimationController(duration: Duration(seconds: 15), vsync: this);
    _animationController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.dismissed:
          //onVideoComplete();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
        case AnimationStatus.completed:
          onVideoComplete();
          break;
      }
    });
  }

  CameraDescription _getCamera(bool back) {
    if (cameras == null || cameras.isEmpty) {
      return null;
    } else {
      return cameras.firstWhere((description) {
        if (back) {
          return description.lensDirection == CameraLensDirection.back;
        } else {
          return description.lensDirection == CameraLensDirection.front;
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        ///重新初始化照相机
        onNewCameraSelected(_controller.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _cameraPreviewWidget(),
          _buildControl(),
          _buildChangeCamera(),
        ],
      ),
    );
  }

  Widget _buildChangeCamera() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            var cameraDes = _getCamera(!_isBack);
            _isBack = !_isBack;
            onNewCameraSelected(cameraDes);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Image(
              image: ImageUtil.images(CommonImg.changeCamera),
              width: 30,
              height: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControl() {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '轻触拍照${widget.argument.hasVideo ? '，长按摄像' : ''}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: onTap,
                      onLongPressStart: (details) {
                        if (!widget.argument.hasVideo) {
                          return;
                        }
                        onVideoStart();
                      },
                      onLongPressEnd: (details) {
                        if (!widget.argument.hasVideo) {
                          return;
                        }
                        onVideoComplete();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return CameraBtn(
                            size: 80,
                            value: _animationController.value,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  void onVideoComplete() async {
    _animationController.reset();
    if (!_isVideoComplete) {
      _isVideoComplete = true;
      await stopVideoRecording();
      widget.argument.cropped = false;
//      final argument = MediaRouteArgument.toCameraPreview(
//          widget.argument, true, _videoPath, _scale);
//      AppPage.replacePage(context, RouteName.cameraPreview,
//          argument: argument);
    }
  }

  void onTap() async {
    final path = await takePicture();
    if (path.isNotEmpty) {
//      final argument = MediaRouteArgument.toCameraPreview(
//          widget.argument, false, path, _scale);
//      AppPage.replacePage(context, RouteName.cameraPreview,
//          arguments: argument);
    }
  }

  void onVideoStart() async {
    _isVideoComplete = false;
    _videoPath = await startVideoRecording();
  }

  Future<String> startVideoRecording() async {
    ///视频保存路径
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = '${dir.path}/pinto/video';

    ///创建图片目录
    await Directory(dirPath).create(recursive: true);
    final String videoPath = '$dirPath/${DateUtil.getNowDateMs()}.mp4';

    if (_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await _controller.startVideoRecording(videoPath);
      _animationController.reset();
      _animationController.forward();
    } on CameraException catch (e) {
      return null;
    }

    return videoPath;
  }

  Future<void> stopVideoRecording() async {
    ///未录制，则直接返回
    if (!_controller.value.isRecordingVideo) {
      return null;
    }
    try {
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      return null;
    }
  }

  ///拍照
  Future<String> takePicture() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = '${dir.path}/pinto/image';

    ///创建图片目录
    await Directory(dirPath).create(recursive: true);
    final String imagePath = '$dirPath/${DateUtil.getNowDateMs()}.jpg';

    if (_controller.value.isTakingPicture) {
      return null;
    }
    try {
      await _controller.takePicture(imagePath);
    } on CameraException catch (e) {
      return null;
    }

    return imagePath;
  }

  ///画面预览界面
  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container(
        color: Colors.black,
      );
    } else {
      final size = MediaQuery.of(context).size;
      final ratio = MediaQuery.of(context).devicePixelRatio;
      final screenHeight = size.height * ratio;
      final screenWidth = size.width * ratio;
      final previewHeight = _controller.value.previewSize.width;
      if (screenHeight > previewHeight) {
        final s = (screenHeight - previewHeight) / 2;
        _scale = (screenHeight - s) / previewHeight;
      }

      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Transform.scale(
          scale: _scale,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          ),
        ),
      );
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }

    ResolutionPreset resolutionPreset = ResolutionPreset.high;
    if (Platform.isAndroid) {
      final list = await availableResolutions(cameraDescription);
      if (list != null && list.isNotEmpty) {
        Size size = list.first;

        /// /// 352x288 on iOS, 240p (320x240) on Android
        //  low,
        //
        //  /// 480p (640x480 on iOS, 720x480 on Android)
        //  medium,
        //
        //  /// 720p (1280x720)
        //  high,
        //
        //  /// 1080p (1920x1080)
        //  veryHigh,
        //
        //  /// 2160p (3840x2160)
        //  ultraHigh,
        //
        //  /// The highest resolution available.
        //  max,

        if (size.height > 2160) {
          if (size.width > 3820) {
            resolutionPreset = ResolutionPreset.max;
          } else {
            resolutionPreset = ResolutionPreset.ultraHigh;
          }
        } else if (size.height > 1080 && size.height <= 2160) {
          if (size.width >= 3820) {
            resolutionPreset = ResolutionPreset.ultraHigh;
          } else {
            resolutionPreset = ResolutionPreset.veryHigh;
          }
        } else if (size.height > 720 && size.height <= 1080) {
          if (size.width >= 1920) {
            resolutionPreset = ResolutionPreset.veryHigh;
          } else {
            resolutionPreset = ResolutionPreset.high;
          }
        } else if (size.height > 480 && size.height <= 720) {
          if (size.width >= 1280) {
            resolutionPreset = ResolutionPreset.high;
          } else {
            resolutionPreset = ResolutionPreset.medium;
          }
        } else if (size.height > 240 && size.height <= 480) {
          if (size.width >= 720) {
            resolutionPreset = ResolutionPreset.medium;
          } else {
            resolutionPreset = ResolutionPreset.low;
          }
        } else {
          resolutionPreset = ResolutionPreset.low;
        }
      }
    }

    _controller = CameraController(cameraDescription, resolutionPreset);
    _controller.addListener(() {
      if (_controller.value.hasError) {}
      if (mounted) {
        setState(() {});
      }
    });

    try {
      await _controller.initialize();
      if (Platform.isIOS) {
        _controller.prepareForVideoRecording();
      }
    } on CameraException catch (e) {}

    if (mounted) {
      setState(() {});
    }
  }
}

class CameraBtn extends StatefulWidget {
  final double size;
  final double value;
  final Widget child;

  const CameraBtn({
    Key key,
    this.size,
    this.value,
    this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CameraBtnState();
  }
}

class _CameraBtnState extends State<CameraBtn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _CameraBtnPainter(value: widget.value),
      child: widget.child,
    );
  }
}

class _CameraBtnPainter extends CustomPainter {
  final double total;
  final double value;
  final Color progressColor;
  final double progressWidth;

  _CameraBtnPainter({
    this.value = .5,
    this.total = 2 * pi,
    this.progressColor = Colors.green,
    this.progressWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double _value = (value ?? .0);
    _value = _value.clamp(.0, 1.0) * total;

    var paint = Paint();
    paint.color = Colors.grey.shade200;
    paint.isAntiAlias = true;
    paint.style = PaintingStyle.fill;
    final width = size.width;
    final height = size.height;
    canvas.drawCircle(Offset(width / 2, height / 2), width / 2, paint);
    Rect rect = Offset(progressWidth / 2, progressWidth / 2) &
        Size(width - progressWidth, height - progressWidth);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = progressWidth;
    paint.color = progressColor;
    canvas.drawArc(rect, -pi / 2, _value, false, paint);

    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(width / 2, height / 2), width / 2 - progressWidth, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
