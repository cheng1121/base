import 'package:flutter/material.dart';

enum AlbumType {
  all,
  image,
  video,
  audio,
}

class MediaRouteArgument {
  bool hasVideo;
  bool cropped;
  bool userAlbum;
  Size croppedSize;
  AlbumType albumType;
  int maxImage;
  String path;
  bool isVideo;
  double scale;

  MediaRouteArgument.toCamera({
    @required this.hasVideo,
    @required this.cropped,
    @required this.userAlbum,
    this.croppedSize = Size.zero,
  });

  MediaRouteArgument.toCameraPreview(MediaRouteArgument mediaRouteArgument,
      this.isVideo, this.path, this.scale) {
    this.hasVideo = mediaRouteArgument.hasVideo;
    this.cropped = mediaRouteArgument.cropped;
    this.userAlbum = mediaRouteArgument.userAlbum;
    this.croppedSize = mediaRouteArgument.croppedSize;
  }

  MediaRouteArgument.toAlbum({
    this.maxImage,
    this.albumType,
    this.hasVideo,
    this.cropped,
    this.userAlbum,
    this.croppedSize,
  });
}