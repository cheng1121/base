import 'package:base/view_models/base_model.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumCoverWidgetModel extends BaseViewModel {
  final Map<String, AssetPathEntity> allGallery;
  final allGalleryCover = Map<String, AssetEntity>();

  AlbumCoverWidgetModel(this.allGallery);

  void getAllCover() async {
    setBusy();
    for (AssetPathEntity entity in allGallery.values) {
      List<AssetEntity> list = await entity.getAssetListPaged(0, 1);
      allGalleryCover[entity.id] = list.first;
    }
    setIdle();
  }
}