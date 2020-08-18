import 'package:base/album/bean/album_model.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/album/preview/view_models/preview_page_view_model.dart';
import 'package:base/album/preview/view_models/page_change_view_model.dart';
import 'package:base/album/preview/view_models/selected_border_view_model.dart';
import 'package:base/album/widgets/future_to_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewBottomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedModel = context.watch<PageChangeViewModel>();
    return StreamBuilder<List<AlbumModel>>(
      stream: ImageSelectedEvent.getInstance().stream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? ImageSelectedEvent.getInstance().selected;
        if (data.length == 0) {
          return Container();
        } else {
          return Container(
            height: 80,
            alignment: Alignment.centerLeft,
            child: Container(
              height: 60,
              child: ListView.builder(
                  controller: selectedModel.scrollController,
                  padding: EdgeInsets.only(left: 10),
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final model = data[index];
                    return GestureDetector(
                      onTap: () {
                        final pageView = context.read<PreviewPageViewModel>();
                        pageView.onItemTap(model);
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            Future2Image(
                              future: model.assetEntity != null
                                  ? model.assetEntity.file
                                  : Future.value(model.path),
                              width: 60,
                              fit: BoxFit.cover,
                              cacheWidth: 100,
                              cacheHeight: 100,
                              shouldRebuild: true,
                            ),
                            _ItemBorder(
                              item: model,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
        }
      },
    );
  }
}

class _ItemBorder extends StatelessWidget {
  final AlbumModel item;

  const _ItemBorder({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SelectedBorderViewModel>().model;
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: item.assetEntity.id == model?.assetEntity?.id
            ? Border.all(color: Colors.blue, width: 1)
            : null,
      ),
    );
  }
}
