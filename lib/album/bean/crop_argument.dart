import 'dart:ui';

class CropArgument {
  final String path;
  final bool isAlbum;
  final Size croppedSize;

  CropArgument(this.path, this.isAlbum, this.croppedSize);
}
