import 'package:base/album/album/widgets/album_all_btn.dart';
import 'package:base/album/bean/album_model.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/album/local/album_locale.dart';
import 'package:base/album/route/album_route.dart';
import 'package:base/route/page_route.dart';
import 'package:base/route/router.dart';
import 'package:base/utils/common_util.dart';
import 'package:base/video/util/ffmpeg_util.dart';
import 'package:base/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class AlbumBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    final locale = AlbumLocale.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AlbumAllBtn(),
              StreamBuilder<List<AlbumModel>>(
                stream: ImageSelectedEvent.getInstance().stream,
                builder: (context, snapshot) {
                  final count = snapshot.data?.length ?? 0;
                  return FlatButton(
                    onPressed: count == 0
                        ? null
                        : () async {
                            if (ImageSelectedEvent.getInstance()
                                .albumRouteArguments
                                .toCorp) {
                              AppPage.nextPage(context, AlbumRoute.crop);
                            } else {
                              if (ImageSelectedEvent.getInstance()
                                      .selected
                                      .first
                                      .type ==
                                  2) {
                                Loading.show(context,
                                    msg: '${locale.videoProcessingHint}');
                                final model = ImageSelectedEvent.getInstance()
                                    .selected
                                    .first;
                                final origin = model.path;
                                final videoInfo =
                                    await FFmpegUtil.getVideoInfo(origin);
                                final path = await FFmpegUtil.compress(origin);
                                final newModel = model.copyWith(
                                    path: path,
                                    videoOriginal: origin,
                                    duration: videoInfo.duration);
                                ImageSelectedEvent.getInstance()
                                    .selected
                                    .clear();
                                ImageSelectedEvent.getInstance().add(newModel);
                              }
                              AppPage.popUtil(
                                  context,
                                  ModalRoute.withName(
                                      ImageSelectedEvent.getInstance()
                                          .albumRouteArguments
                                          .backPageName));
                            }
                          },
                    child: Text(
                      '${locale.complete}${count == 0 ? '' : '($count)'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          height: paddingBottom,
          color: Colors.blue,
        ),
      ],
    );
  }
}
