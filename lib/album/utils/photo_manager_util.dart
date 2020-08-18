import 'package:base/album/album/album.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoManagerUtil {
  static Future<List<AssetPathEntity>> getAsset(AlbumType type,
      {bool only = true}) async {
    var requestType = RequestType.image | RequestType.video;
    if (type == AlbumType.all) {
      ///不能使用RequestType.all，RequestType.all带有音频文件
      requestType = RequestType.image | RequestType.video;
    } else if (type == AlbumType.video) {
      requestType = RequestType.video;
    } else if (type == AlbumType.image) {
      requestType = RequestType.image;
    }
//    else if (type == AlbumType.audio) {
//      requestType = RequestType.audio;
//    }
    final optionGroup = FilterOptionGroup()
      ..setOption(
          AssetType.video,
          FilterOption(
              durationConstraint: DurationConstraint(
            max: const Duration(seconds: 16),
          )));
    final assetPathEntity = await PhotoManager.getAssetPathList(
        type: requestType, onlyAll: only, filterOption: optionGroup);
    return assetPathEntity;
  }
}
