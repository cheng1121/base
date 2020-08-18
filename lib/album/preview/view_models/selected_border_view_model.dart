import 'package:base/album/bean/album_model.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/view_models/base_view_model.dart';

class SelectedBorderViewModel extends BaseViewModel {
  bool showSelected = false;
  AlbumModel model;

  void viewChange(AlbumModel model) {
    int selectedIndex = ImageSelectedEvent.getInstance().getIndex(model);
    if (selectedIndex > -1) {
      showSelected = true;
      this.model = model;
    } else {
      showSelected = false;
      this.model = null;
    }
    setIdle();
  }
}
