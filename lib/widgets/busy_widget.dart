import 'package:base/utils/common_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBusyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: 20,
      ),
    );
  }
}
