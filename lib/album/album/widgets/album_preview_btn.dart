import 'package:base/album/album/view_models/album_view_model.dart';
import 'package:base/album/bean/album_model.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/album/local/album_locale.dart';
import 'package:base/album/route/album_route.dart';
import 'package:base/route/page_route.dart';
import 'package:base/route/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumPreviewBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AlbumLocale locale = AlbumLocale.of(context);
    return StreamBuilder<List<AlbumModel>>(
      stream: ImageSelectedEvent.getInstance().stream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        final count = data?.length ?? 0;
        return FlatButton(
          onPressed: count == 0
              ? null
              : () {
                  if (data.first.type == 2) {
                    ///视频
                    AppPage.nextPage(context, AlbumRoute.preview);
                  } else {
                    final list = context.read<AlbumViewModel>().getList();
                    AppPage.nextPage(context, AlbumRoute.preview,
                        argument: RouteArgument.argument(argument: list));
                  }
                },
          child: Text(
            '${locale.preview}${count == 0 ? '' : '($count)'}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}
