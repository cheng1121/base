import 'package:base/album/bean/argument.dart';
import 'package:base/video/app_player.dart';
import 'package:flutter/material.dart';

class AppCameraPreview extends StatelessWidget {
  final MediaRouteArgument argument;

  const AppCameraPreview({
    Key key,
    this.argument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
//          AppPage.replacePage(context, RouteName.camera, arguments: argument);
          return false;
        },
        child: Stack(
          children: <Widget>[
            argument.isVideo
                ? AppPlayer(
                    width: double.infinity,
                    height: double.infinity,
                    url: argument.path,
                  )
                : Container(),

            ///CacheImage(
            //              url: argument.path,
            //              fit: BoxFit.contain,
            //              alignment: Alignment.center,
            //              width: size.width,
            //              height: size.height,
            //            )
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                height: kToolbarHeight + top,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
//                  leading: BackNoShadow(
//                    onTap: () {
//                      AppPage.replacePage(context, RouteName.camera,
//                          arguments: argument);
//                    },
//                    iconColor: Colors.white,
//                  ),
                  actions: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: InkWell(
                        onTap: () async {
//                          if (argument.cropped) {
//                            showLoading(context, true);
//                            final file = File(argument.path);
//                            final imageInfo = await decodeImageFromList(
//                                file.readAsBytesSync());
//                            showLoading(context, false);
//                            AppPage.replacePage(context, RouteName.imageCrop,
//                                arguments: [
//                                  argument.path,
//                                  argument.croppedSize,
//                                  Size(imageInfo.width.toDouble(),
//                                      imageInfo.height.toDouble()),
//                                  false
//                                ]);
//                          } else if (argument.userAlbum) {
//                            ///用户相册
//                            final list = <UserAlbumModel>[
//                              UserAlbumModel.init(
//                                type: argument.isVideo
//                                    ? PhotoType.video
//                                    : PhotoType.image,
//                                path: argument.path,
//                              ),
//                            ];
//                            AppPage.replacePage(
//                                context, RouteName.userAlbumPreview,
//                                arguments: [
//                                  -1,
//                                  true,
//                                  list,
//                                ]);
//                          } else {
//                            ///退出
//                            var compressPath = argument.path;
//                            if (argument.isVideo) {
//                              showLoading(context, true, msg: '短视频正在处理中');
//
//                              ///压缩视频
//                              final videoPath =
//                                  await FFmpegUtil.compress(argument.path);
//                              showLoading(context, false);
//                              compressPath = videoPath;
//                            }
//
//                            final model = AlbumModel(
//                              path: compressPath,
//                              type: argument.isVideo ? 2 : 1,
//                              videoOriginal: argument.path,
//                            );
//                            AppPage.pop(context);
//                            bus.emit(EventName.camera, model);
//                          }
                        },
                        child: Container(
                          width: 60,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Text(
                            '完成',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
