import 'package:base/album/album/view_models/album_view_model.dart';
import 'package:base/album/bean/album_model.dart';
import 'package:base/album/event/image_selected_event.dart';
import 'package:base/album/local/album_locale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumItemChecked extends StatelessWidget {
  final int index;

  const AlbumItemChecked({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AlbumViewModel>();
    final item = viewModel.getItem(index);
    final locale = AlbumLocale.of(context);
    return GestureDetector(
      onTap: () {
        ImageSelectedEvent.getInstance().onTap(index, item, locale);
      },
      behavior: HitTestBehavior.translucent,
      child: StreamBuilder<List<AlbumModel>>(
        stream: ImageSelectedEvent.getInstance().stream,
        builder: (context, snapshot) {
          bool selected = false;
          int index = ImageSelectedEvent.getInstance().getIndex(item);
          if (index > -1) {
            selected = true;
          }
          return Container(
            alignment: Alignment.topRight,
            child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.white,
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  child: selected
                      ? Container(
                          width: 20,
                          height: 20,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                width: 13,
                                height: 13,
                              ),
                              Icon(
                                Icons.check_box,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          child: Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                )),
          );
        },
      ),
    );
  }
}
