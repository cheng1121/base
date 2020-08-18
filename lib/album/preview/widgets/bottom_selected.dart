import 'package:base/album/local/album_locale.dart';
import 'package:base/album/preview/view_models/page_change_view_model.dart';
import 'package:base/album/preview/view_models/selected_border_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSelected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AlbumLocale.of(context);
    final borderModel = context.watch<SelectedBorderViewModel>();
    return Container(
      height: kMinInteractiveDimension,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          final selectedModel = context.read<PageChangeViewModel>();
          selectedModel.onSelectedTap(locale, borderModel);
        },
        behavior: HitTestBehavior.translucent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            borderModel.showSelected
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 18,
                      )
                    ],
                  )
                : Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.white,
                    size: 18,
                  ),
            SizedBox(
              width: 8,
            ),
            Text(
              '${locale.choose}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
