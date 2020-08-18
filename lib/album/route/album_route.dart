import 'package:base/album/album/album.dart';
import 'package:base/album/camera/app_camera.dart';
import 'package:base/album/crop/image_crop.dart';
import 'package:base/album/preview/album_preview.dart';
import 'package:base/route/router.dart';
import 'package:flutter/cupertino.dart';

class AlbumRoute {
  static const String moduleName = 'album';
  static const String crop = '$moduleName/crop';
  static const String album = '$moduleName/';
  static const String camera = '$moduleName/camera';
  static const String preview = '$moduleName/preview';

  static Map _albumRoute = <String, WidgetBuilder>{
    crop: (context) => ImageCropPage(),
    album: (context) => AlbumPage(),
    camera: (context) => CustomCamera(),
    preview: (context) => MediaPreview(),
  };

  static void register() {
    AppRouter.registerModulePages(moduleName, _albumRoute);
  }
}
