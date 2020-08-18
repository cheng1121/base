import 'package:base/album/preview/view_models/page_change_view_model.dart';
import 'package:base/album/preview/view_models/selected_border_view_model.dart';
import 'package:base/album/widgets/future_to_image.dart';
import 'package:base/album/preview/view_models/preview_page_view_model.dart';
import 'package:base/utils/common_util.dart';
import 'package:base/video/future_to_video.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PreviewPageViewModel viewModel = context.watch<PreviewPageViewModel>();
    if (viewModel.list.first.type == 2) {
      ///视频（分为本地视频和网络视频）
      final model = viewModel.list.first;
      return Future2Video(
        model: model,
        autoPlay: true,
        loop: true,
      );
    } else {
      ///图片
      return ExtendedImageGesturePageView.builder(
        onPageChanged: (index) {
          viewModel.onPageChange(index);
          final viewSelected = context.read<PageChangeViewModel>();
          final borderModel = context.read<SelectedBorderViewModel>();
          viewSelected.setPageChange(viewModel.list[index]);
          borderModel.viewChange(viewModel.list[index]);
        },
        controller: viewModel.pageController,
        itemCount: viewModel.list.length,
        itemBuilder: (context, index) {
          final model = viewModel.list[index];
          if (model.path != null && model.path.contains('http')) {
            ///网络图片
            return ExtendedImage.network(
              model.path,
              mode: ExtendedImageMode.gesture,
            );
          } else {
            ///本地图片（一般为拍照图片）
            return Future2Image(
              future: model.assetEntity != null
                  ? model.assetEntity.file
                  : Future.value(model.path),
              mode: ExtendedImageMode.gesture,
            );
          }
        },
      );
    }
  }
}
