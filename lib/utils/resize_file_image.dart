
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResizeFileImage extends ImageProvider<ResizeFileImage> {
  const ResizeFileImage(
      this.file, {
        this.scale = 1.0,
      })  : assert(file != null),
        assert(scale != null);

  final File file;
  final double scale;

  @override
  Future<ResizeFileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ResizeFileImage>(this);
  }

  @override
  ImageStreamCompleter load(ResizeFileImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key, decode),
        scale: key.scale,
        informationCollector: () sync* {
          yield ErrorDescription('Path: ${file?.path}');
        });
  }

  Future<Codec> _loadAsync(ResizeFileImage key, DecoderCallback decode) async {
    assert(key == this);
    final Uint8List bytes = await file.readAsBytes();
    if (bytes.lengthInBytes == 0) {
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError('$file is empty and cannot be loaded as an image.');
    }
    final size = await getScaleImgSize(bytes, isScale: scale < 1);
    return await decode(bytes,
        cacheWidth: size.width.floor(), cacheHeight: size.height.floor());
  }
}

Future<Size> getScaleImgSize(Uint8List bytes, {bool isScale = false}) async {
  double getScale(int size) {
    final x = size / 300;
    if (x <= 1) {
      return 1.0;
    } else {
      return 1 / x;
    }
  }

  ///获取图片信息
  final imageInfo = await decodeImageFromList(bytes);
  final int imgWidth = imageInfo.width;
  final int imgHeight = imageInfo.height;
  if (isScale) {
    double targetScale = 1;
    if (imgWidth > imgHeight) {
      targetScale = getScale(imgWidth);
    } else if (imgWidth < imgHeight) {
      targetScale = getScale(imgHeight);
    } else if (imgWidth == imgHeight) {
      targetScale = getScale(imgWidth);
    }
    final actualWidth = (imageInfo.width * targetScale);
    final actualHeight = (imageInfo.height * targetScale);

    return Size(actualWidth, actualHeight);
  }
  return Size(imgWidth.toDouble(), imgHeight.toDouble());
}

Future<Size> getImgWidgetSize(String path) async {
  final file = File(path);
  final size = await getScaleImgSize(file.readAsBytesSync(), isScale: true);
  double widgetWidth;
  double widgetHeight;

  ///保留一位小数，四舍五入
  final str = size.aspectRatio.toStringAsFixed(1);
  final d = double.parse(str);
  if (d == 1.0 || d + 0.1 == 1.0) {
    widgetHeight = 110.0;
    widgetWidth = 110.0;
  } else if (size.aspectRatio >= 1) {
    if (size.width <= 180) {
      widgetWidth = size.width;
    } else {
      widgetWidth = 180.0;
    }
    if (size.height <= 110) {
      widgetHeight = size.height;
    } else {
      widgetHeight = 110.0;
    }
  } else {
    if (size.width <= 110) {
      widgetWidth = size.width;
    } else {
      widgetWidth = 110.0;
    }
    if (size.height <= 180) {
      widgetHeight = size.height;
    } else {
      widgetHeight = 180.0;
    }
  }
  return Size(widgetWidth, widgetHeight);
}