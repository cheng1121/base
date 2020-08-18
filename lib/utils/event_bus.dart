import 'dart:async';

import 'package:base/album/bean/album_model.dart';

class EventBus {
  EventBus._internal() : _streamController = StreamController.broadcast();

  static final EventBus _instance = EventBus._internal();

  factory EventBus.getInstance() => _instance;

  StreamController _streamController;

  StreamController get streamController => _streamController;



  Stream<T> on<T>() {
    if (T == dynamic) {
      return streamController.stream;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  void add(event) {
    streamController.add(event);
  }

  void destroy() {
    streamController.close();
  }
}
