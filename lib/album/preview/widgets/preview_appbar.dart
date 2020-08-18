import 'package:base/album/bean/album_model.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/album/local/album_locale.dart';
import 'package:base/album/preview/view_models/preview_page_view_model.dart';
import 'package:base/album/route/album_route.dart';
import 'package:base/route/page_route.dart';
import 'package:base/video/util/ffmpeg_util.dart';
import 'package:base/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final previewPage = context.watch<PreviewPageViewModel>();
    final paddingTop = MediaQuery.of(context).padding.top;
    final locale = AlbumLocale.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: kToolbarHeight + paddingTop,
        child: AppBar(
          backgroundColor: Colors.black.withOpacity(.7),
          title: previewPage.getType() == 1
              ? Text(
                  '${previewPage.pageIndex}/${previewPage.list.length}',
                  style: TextStyle(fontSize: 16),
                )
              : Container(),
          actions: [
            FlatButton(
              onPressed: () async {
                if (ImageSelectedEvent.getInstance().selected.isEmpty) {
                  ImageSelectedEvent.getInstance()
                      .selected
                      .addAll(previewPage.list);
                }
                if (ImageSelectedEvent.getInstance()
                    .albumRouteArguments
                    .toCorp) {
                  AppPage.nextPage(context, AlbumRoute.crop);
                } else {
                  if (ImageSelectedEvent.getInstance().selected.first.type ==
                      2) {
                    Loading.show(context, msg: '${locale.videoProcessingHint}');
                    final model =
                        ImageSelectedEvent.getInstance().selected.first;
                    final origin = model.path;
                    final videoInfo = await FFmpegUtil.getVideoInfo(origin);
                    final path = await FFmpegUtil.compress(origin);
                    final newModel = model.copyWith(
                        path: path,
                        videoOriginal: origin,
                        duration: videoInfo.duration);
                    ImageSelectedEvent.getInstance().selected.clear();
                    ImageSelectedEvent.getInstance().add(newModel);
                  }

                  AppPage.popUtil(
                      context,
                      ModalRoute.withName(ImageSelectedEvent.getInstance()
                          .albumRouteArguments
                          .backPageName));
                }
              },
              child: StreamBuilder<List<AlbumModel>>(
                stream: ImageSelectedEvent.getInstance().stream,
                builder: (context, snapshot) {
                  final length = snapshot.data?.length ??
                      ImageSelectedEvent.getInstance().selected.length;
                  String str = '';
                  if (previewPage.getType() == 1 && length > 0) {
                    str =
                        '($length/${ImageSelectedEvent.getInstance().albumRouteArguments.maxCount})';
                  }
                  return Text(
                    '${locale.complete}$str',
                    style: TextStyle(fontSize: 18),
                  );
                },
              ),
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
