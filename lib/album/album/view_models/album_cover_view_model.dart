import 'package:base/album/album/album.dart';
import 'package:base/album/utils/photo_manager_util.dart';
import 'package:base/view_models/base_view_model.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumCoverViewModel extends BaseViewModel {
  final AlbumType type;

  List<AssetPathEntity> list = [];

  AlbumCoverViewModel(this.type);

  Future<void> getAllCover() async {
    setBusy();
    final data = await PhotoManagerUtil.getAsset(type, only: false);
    list.clear();
    list.addAll(data);
    setIdle();
  }
}
