import 'package:base/album/album/widgets/album_all_bottom_sheet.dart';
import 'package:base/album/album/view_models/album_cover_view_model.dart';
import 'package:base/album/album/view_models/album_view_model.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

///author: cheng
///date: 2020/8/13
///time: 10:26 下午
///desc: 全部相册按钮
class AlbumAllBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentAlbum = context.select<AlbumViewModel, AssetPathEntity>(
        (value) => value.selectedGallery);
    final coverAlbum = context.watch<AlbumCoverViewModel>();
    return FlatButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return AlbumAllBottomSheet(
                list: coverAlbum.list,
                selectedId: currentAlbum.id,
                onTap: (album) {
                  final albumViewModel = context.read<AlbumViewModel>();

                  final selectedList =
                      ImageSelectedEvent.getInstance().selected;
                  albumViewModel.setCurrent(album, selectedList);
                },
              );
            });
      },
      child: Text(
        '${currentAlbum?.name ?? ''}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
