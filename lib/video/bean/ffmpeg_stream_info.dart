
class FFmpegStreamInfo {
  int streamId;
  String streamType;
  String codec;
  String fullCodec;
  int width;
  int height;
  int sampleRate;
  String sampleFormat;
  String channelLayout;
  String sar;
  String dar;
  String averageFrameRate;
  String realFrameRate;
  String timeBase;
  String codecTimeBase;
  String encoder;
  String rotate;
  String creationTime;
  String handlerName;
  Map sideData;

  FFmpegStreamInfo.fromMap(Map streamsInfo) {
    this.streamId = streamsInfo['index'];
    this.streamType = streamsInfo['type'];
    this.codec = streamsInfo['codec'];
    this.fullCodec = streamsInfo['fullCodec'];
    this.width = streamsInfo['width'];
    this.height = streamsInfo['height'];
    this.sampleRate = streamsInfo['sampleRate'];
    this.sampleFormat = streamsInfo['sampleFormat'];
    this.channelLayout = streamsInfo['channelLayout'];
    this.sar = streamsInfo['sampleAspectRatio'];
    this.dar = streamsInfo['displayAspectRatio'];
    this.averageFrameRate = streamsInfo['averageFrameRate'];
    this.realFrameRate = streamsInfo['realFrameRate'];
    this.timeBase = streamsInfo['timeBase'];
    this.codecTimeBase = streamsInfo['codecTimeBase'];
    final metadataMap = streamsInfo['metadata'];
    if (metadataMap != null) {
      this.encoder = metadataMap['encoder'];
      this.rotate = metadataMap['rotate'];
      this.creationTime = metadataMap['creation_time'];
      this.handlerName = metadataMap['handler_name'];
    }
    this.sideData = streamsInfo['sidedata'];
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        map[key] = value;
      }
    }

    addIfNotNull('streamId', this.streamId);
    addIfNotNull('streamType', this.streamType);
    addIfNotNull('codec', this.codec);
    addIfNotNull('fullCodec', this.fullCodec);
    addIfNotNull('width', this.width);
    addIfNotNull('height', this.height);
    addIfNotNull('sampleRate', this.sampleRate);
    addIfNotNull('sampleFormat', this.sampleFormat);
    addIfNotNull('channelLayout', this.channelLayout);
    addIfNotNull('sar', this.sar);
    addIfNotNull('dar', this.dar);
    addIfNotNull('averageFrameRate', this.averageFrameRate);
    addIfNotNull('realFrameRate', this.realFrameRate);
    addIfNotNull('timeBase', this.timeBase);
    addIfNotNull('codecTimeBase', this.codecTimeBase);
    addIfNotNull('encoder', this.encoder);
    addIfNotNull('rotate', this.rotate);
    addIfNotNull('creationTime', this.creationTime);
    addIfNotNull('handlerName', this.handlerName);
    addIfNotNull('sideData', this.sideData);
    return map;
  }
}
