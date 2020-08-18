import 'package:base/album/album/widgets/album_preview_btn.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/album/local/album_locale.dart';
import 'package:base/route/page_route.dart';
import 'package:flutter/material.dart';

class AlbumAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final locale = AlbumLocale.of(context);
    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 0,
      leading: BackButton(
        onPressed: () {
          ImageSelectedEvent.getInstance().selected.clear();
          AppPage.pop(context);
        },
      ),
      title: Text(
        '${locale.album}',
        style: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      actions: <Widget>[
        AlbumPreviewBtn(),
      ],
    );
  }
}
