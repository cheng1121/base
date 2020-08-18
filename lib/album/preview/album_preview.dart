import 'package:base/album/bean/album_model.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/album/preview/view_models/page_change_view_model.dart';
import 'package:base/album/preview/view_models/selected_border_view_model.dart';
import 'package:base/album/preview/widgets/preview_appbar.dart';
import 'package:base/album/preview/widgets/preview_bottom.dart';
import 'package:base/album/preview/widgets/preview_page_view.dart';
import 'package:base/album/preview/view_models/preview_page_view_model.dart';
import 'package:base/route/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeArgument = RouteArgument.getArgument(context);
    final list = <AlbumModel>[];
    if (routeArgument != null && routeArgument is List<AlbumModel>) {
      list.clear();
      list.addAll(routeArgument);
    } else {
      list.addAll(ImageSelectedEvent.getInstance().selected);
    }
    final width = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PreviewPageViewModel>(
          create: (context) => PreviewPageViewModel(list),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final model = PageChangeViewModel(list.first, width);

            ///延迟初始化（加入事件队列）
            Future.delayed(Duration(), () {
              model.init();
            });
            return model;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final model = SelectedBorderViewModel();

            ///加入事件队列
            Future.delayed(Duration.zero, () {
              model.viewChange(list.first);
            });
            return model;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PreviewPageView(),
            PreviewAppbar(),
            PreviewBottom(),
          ],
        ),
      ),
    );
  }
}
