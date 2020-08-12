
import 'package:base/video/bean/ffmpeg_stream_info.dart';

class VideoInfo {
  String path;
  String format;
  int duration;
  int bitrate;
  FFmpegStreamInfo videoInfo;
  FFmpegStreamInfo audioInfo;

  VideoInfo.fromMap(Map map) {
    this.path = map['path'];
    this.format = map['format'];
    this.duration = map['duration'];
    this.bitrate = map['bitrate'];
    if (map['streams'] != null) {
      final streamsInfoArray = map['streams'] as List;
      if (streamsInfoArray.length > 0) {
        for (var streamsInfo in streamsInfoArray) {
          if (streamsInfo['type'] == 'video') {
            this.videoInfo = FFmpegStreamInfo.fromMap(streamsInfo);
          } else if (streamsInfo['type'] == 'audio') {
            this.audioInfo = FFmpegStreamInfo.fromMap(streamsInfo);
          }
        }
      }
    }
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        map[key] = value;
      }
    }

    addIfNotNull('path', this.path);
    addIfNotNull('format', this.format);
    addIfNotNull('duration', this.duration);
    addIfNotNull('bitrate', this.bitrate);
    addIfNotNull('videoInfo', this.videoInfo.toMap());
    addIfNotNull('audioInfo', this.audioInfo.toMap());

    return map;
  }
}