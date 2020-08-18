
import 'package:flutter/material.dart';

class AlbumItemFlag extends StatelessWidget {
  final int type;
  final int duration;

  const AlbumItemFlag({Key key, this.type, this.duration}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: type == 1,
      child: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.black26,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(
              Icons.videocam,
              size: 24,
              color: Colors.white,
            ),
            Text(
              _castTime(duration),
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  String _castTime(int second) {
    if (second > 3600) {
      int h = second ~/ 3600;

      int m = (second - 3600 * h) ~/ 60;
      int s = second - 60 * m;

      return '$h:$m:$s';
    } else if (second > 60) {
      //大于60s
      return '${second ~/ 60}:${second % 60}';
    } else {
      return '0:${second > 9 ? second : '0$second'}';
    }
  }
}
