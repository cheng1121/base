import 'dart:io';

import 'package:path_provider/path_provider.dart';

///获取缓存文件所在路径
///[dir] 一级目录
///[fileName] 文件名
///[isDel] 如果文件已存在，是否删除该文件
Future<String> cachePath(String dir, String fileName,
    {bool isDel = true}) async {
  Directory tempDir = await getTemporaryDirectory();
  String directoryPath = '${tempDir.path}/$dir';
  Directory directory = Directory(directoryPath);

  ///如果目录不存在则创建该目录
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  String filePath = '$directoryPath/$fileName';
  var file = File(filePath);

  ///如果该文件已存在并且isDel为true则删除文件
  if (isDel && file.existsSync()) {
    file.deleteSync();
  } else if (!isDel && file.existsSync()) {
    return file.path;
  }

  return filePath;
}
