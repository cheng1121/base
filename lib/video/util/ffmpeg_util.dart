
import 'dart:io';

import 'package:base/video/bean/video_info.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';

class FFmpegUtil {
  ///author:cheng
  ///time: 2020-07-06 12:03:08
  ///desc: 获取视频信息
  static Future<VideoInfo> getVideoInfo(String path) async {
    FlutterFFprobe _fprobe = FlutterFFprobe();
    final info = await _fprobe.getMediaInformation(path);
    return VideoInfo.fromMap(info);
  }

  ///author:cheng
  ///time: 2020-07-06 12:02:49
  ///desc: 视频压缩
  static Future<String> compress(String path) async {
    final directory = Directory('${(await getTemporaryDirectory()).path}/temp');
    if (!directory.existsSync()) {
      directory.createSync();
    }
    final output = '${directory.path}/temp.mp4';
    final beforeInfo = await getVideoInfo(path);
    final file = File(output);
    if (file.existsSync()) {
      file.deleteSync();
    }
    final arguments = <String>[
      '-i',
      path,
      '-c:v',
      'libx264',
      '-vf',
      'scale=trunc(iw/2)*2:trunc(ih/2)*2',
      '-preset',
      'ultrafast',

      ///ultrafast
      ///crf越小，质量越高，文件越大
      '-crf',
      '32',

      ///下方为音频
      '-c:a',
      'copy',
      output,
    ];
    FlutterFFmpeg fFmpeg = FlutterFFmpeg();
    int result = await fFmpeg.executeWithArguments(arguments);
    if (result == 0) {
      final afterInfo = await getVideoInfo(path);
      return output;
    }
    return '';
  }

  ///author:cheng
  ///time: 2020-07-05 16:29:44
  ///desc: 视频截图
  static Future<String> screenshot(String videoPath) async {
    Directory tempDir = await getTemporaryDirectory();
    String thumbnailDirectory = '${tempDir.path}/thumbnail';
    Directory directory = Directory(thumbnailDirectory);

    ///如果目录不存在则创建该目录
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    ///获取视频名字
    String videoName = videoPath.split('/').last;

    ///替换后缀为jpg
    String thumbnailName = videoName.replaceRange(
        videoName.lastIndexOf('.'), videoName.length, '.jpg');
    String thumbnailPath = '$thumbnailDirectory/$thumbnailName';
    var file = File(thumbnailPath);

    ///如果该缩略图已存在则直接返回路径
    if (file.existsSync()) {
      return file.path;
    }
    final videoInfo = await getVideoInfo(videoPath);
    int duration = videoInfo.duration;
    int d = (duration ~/ 1000) ~/ 2;

    final arguments = <String>[
      '-ss',
      '00:00:$d',
      '-i',
      '$videoPath',
      '-r',
      '1',
      '-vframes',
      '1',
      '-an',
      '-vcodec',
      'mjpeg',
      '$thumbnailPath',
    ];
    FlutterFFmpeg fFmpeg = FlutterFFmpeg();
    final result = await fFmpeg.executeWithArguments(arguments);
    if (result == 0) {
      return thumbnailPath;
    }
    return '';
  }
}
