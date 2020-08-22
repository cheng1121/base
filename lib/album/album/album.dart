
import 'package:base/album/album/widgets/album_appbar.dart';
import 'package:base/album/album/widgets/album_bottom.dart';
import 'package:base/album/album/widgets/album_grid.dart';
import 'package:base/album/album/view_models/album_cover_view_model.dart';
import 'package:base/album/album/view_models/album_view_model.dart';
import 'package:base/album/bean/album_route_arguments.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/route/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AlbumType {
  all,
  image,
  video,
}

class AlbumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeArgument =
        ModalRoute.of(context).settings.arguments as RouteArgument;
//    final type = routeArgument.argument['type'] ?? AlbumType.all;
//    final maxImage = routeArgument.argument['maxImage'] ?? 9;
//    final backPageName = routeArgument.argument['backPageName'];
    assert(routeArgument.argument is AlbumRouteArguments,
        '进入相册在push时需要传AlbumRouteArguments参数');
    assert(routeArgument.argument != null, 'AlbumRouteArguments不能为null');
    ImageSelectedEvent.getInstance().albumRouteArguments =
        routeArgument.argument;
    ImageSelectedEvent.getInstance().selected.clear();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AlbumViewModel(
              ImageSelectedEvent.getInstance().albumRouteArguments.albumType),
        ),
        ChangeNotifierProvider<AlbumCoverViewModel>(
          create: (context) => AlbumCoverViewModel(
              ImageSelectedEvent.getInstance().albumRouteArguments.albumType)
            ..getAllCover(),
        ),
      ],
      builder: (context, child) {
        return Scaffold(
          appBar: AlbumAppBar(),
          body: WillPopScope(
            onWillPop: () async {
              ImageSelectedEvent.getInstance().selected.clear();
              return true;
            },
            child: Column(
              children: [
                Expanded(
                  child: AlbumGrid(),
                ),
                AlbumBottom(),
              ],
            ),
          ),
        );
      },
    );
  }
}
