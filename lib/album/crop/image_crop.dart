import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:base/album/bean/album_model.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/route/page_route.dart';
import 'package:base/utils/common_util.dart';
import 'package:base/utils/file_util.dart';
import 'package:base/widgets/busy_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

class ImageCropPage extends StatefulWidget {
  @override
  _ImageCropPageState createState() => _ImageCropPageState();
}

class _ImageCropPageState extends State<ImageCropPage> {
  final GlobalKey<ExtendedImageEditorState> _cropKey =
      GlobalKey<ExtendedImageEditorState>();
  Future<String> _future;

  Future<String> path() async {
    String path = '';
    final model = ImageSelectedEvent.getInstance().selected.first;
    if (model.assetEntity == null) {
      return model.path;
    }
    return (await model.assetEntity.file).path;
  }

  Size get croppedSize =>
      ImageSelectedEvent.getInstance().albumRouteArguments.croppedSize;

  @override
  void initState() {
    super.initState();
    _future = path();
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

//    final DateTime start = DateTime.now();
    final Uint8List result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );
//    print('${DateTime.now().difference(start)} ：total time');
    final path = await cachePath(
        'crop', 'crop_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
    File(path).writeAsBytesSync(result);
    ImageSelectedEvent.getInstance().selected.clear();
    ImageSelectedEvent.getInstance().add(AlbumModel.withPath(path: path));
    AppPage.popUtil(
        context,
        ModalRoute.withName(
            ImageSelectedEvent.getInstance().albumRouteArguments.backPageName));
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
            child: FutureBuilder<String>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return ExtendedImage.file(
                    File(snapshot.data),
                    mode: ExtendedImageMode.editor,
                    extendedImageEditorKey: _cropKey,
                    fit: BoxFit.contain,
                    initEditorConfigHandler: (state) {
                      return EditorConfig(
                          cropAspectRatio: croppedSize.aspectRatio,
                          lineColor: Colors.greenAccent,
                          lineHeight: 1.5,
                          hitTestSize: 0,
                          cornerColor: Colors.transparent,
                          cornerSize: Size.zero,
                          editorMaskColorHandler: (context, pointerDown) {
                            return pointerDown
                                ? Colors.black38
                                : Colors.black54;
                          });
                    },
                  );
                } else {
                  return AppBusyWidget();
                }
              },
            ),
          ),
          Container(
            height: kToolbarHeight + paddingTop,
            child: AppBar(
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
      ),
    );
  }
}
