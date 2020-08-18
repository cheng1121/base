import 'package:base/album/event/image_selected_event.dart';
import 'package:base/album/preview/widgets/bottom_selected.dart';
import 'package:base/album/preview/widgets/preview_bottom_list.dart';
import 'package:base/utils/common_util.dart';
import 'package:flutter/material.dart';

class PreviewBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    if (ImageSelectedEvent.getInstance().selected.isNotEmpty &&
        ImageSelectedEvent.getInstance().selected.first.type == 1) {
      return Container(
        color: Colors.black.withOpacity(.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PreviewBottomList(),
            Divider(
              indent: 1,
              height: 1,
              color: Colors.black.withOpacity(.9),
            ),
            BottomSelected(),
            Container(
              height: paddingBottom,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
