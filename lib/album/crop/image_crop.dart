import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:base/album/bean/argument.dart';
import 'package:base/route/page_route.dart';
import 'package:base/utils/file_util.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

class ImageCropPage extends StatefulWidget {
  final String path;
  final bool isAlbum;
  final Size croppedSize;

  const ImageCropPage({Key key, this.path, this.isAlbum, this.croppedSize})
      : super(key: key);

  @override
  _ImageCropPageState createState() => _ImageCropPageState();
}

class _ImageCropPageState extends State<ImageCropPage> {
  final GlobalKey<ExtendedImageEditorState> _cropKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  void initState() {
    super.initState();
  }

  void _cropImage() async {
    final state = _cropKey.currentState;
    final cropRect = state.getCropRect();
    final EditActionDetails action = state.editAction;

    final int rotateAngle = action.rotateAngle.toInt();
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;
    final ImageEditorOption option = ImageEditorOption();

    if (action.needCrop) {
      option.addOption(ClipOption.fromRect(cropRect));
    }

    if (action.needFlip) {
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    }

    if (action.hasRotateAngle) {
      option.addOption(RotateOption(rotateAngle));
    }

    final DateTime start = DateTime.now();
    final Uint8List result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );
    print('${DateTime.now().difference(start)} ：total time');
    final path = await cachePath(
        'crop', 'crop_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
    File(path).writeAsBytesSync(result);
//    bus.emit(EventName.cropped, [path, widget.path]);
    AppPage.pop(context);
  }

  void _back() {
    if (widget.isAlbum) {
      ///相册
      final argument = MediaRouteArgument.toAlbum(
          maxImage: 1,
          albumType: AlbumType.image,
          cropped: true,
          croppedSize: widget.croppedSize);
//      AppPage.replacePage(context, AlbumRoute.album, arguments: argument);
    } else {
      ///拍照
      final argument = MediaRouteArgument.toCamera(
          hasVideo: false,
          cropped: true,
          userAlbum: false,
          croppedSize: widget.croppedSize);
//      AppPage.replacePage(context, RouteName.camera, arguments: argument);
    }
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            _back();
            return false;
          },
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.black,
                child: ExtendedImage.file(
                  File(widget.path),
                  mode: ExtendedImageMode.editor,
                  extendedImageEditorKey: _cropKey,
                  fit: BoxFit.contain,
                  initEditorConfigHandler: (state) {
                    return EditorConfig(
                        cropAspectRatio: widget.croppedSize.aspectRatio,
                        lineColor: Colors.greenAccent,
                        lineHeight: 1.5,
                        hitTestSize: 0,
                        cornerColor: Colors.transparent,
                        cornerSize: Size.zero,
                        editorMaskColorHandler: (context, pointerDown) {
                          return pointerDown ? Colors.black38 : Colors.black54;
                        });
                  },
                ),
              ),
              Container(
                height: kToolbarHeight + paddingTop,
                child: AppBar(
//                  leading: BackNoShadow(
//                    onTap: _back,
//                  ),
                  backgroundColor: Colors.transparent,
                  actions: [
                    FlatButton(
                      onPressed: _cropImage,
                      child: Text(
                        '裁剪',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
