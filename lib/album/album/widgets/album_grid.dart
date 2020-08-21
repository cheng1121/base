import 'package:base/album/album/view_models/album_view_model.dart';
import 'package:base/album/album/widgets/album_item.dart';
import 'package:base/widgets/busy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';

class AlbumGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final albumViewModel = context.watch<AlbumViewModel>();
    return EasyRefresh.custom(
      firstRefresh: true,
      firstRefreshWidget: AppBusyWidget(),
      onLoad: albumViewModel.loadAlbum,
      footer: MaterialFooter(),
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),

          delegate: SliverChildBuilderDelegate((context, index) {
            final item = albumViewModel.list[index];
            return AlbumItem(
              item: item,
              index: index,
            );
          }, childCount: albumViewModel.list.length),
        )
      ],
    );
  }
}
