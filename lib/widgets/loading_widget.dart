import 'package:base/route/page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading {
  static show(BuildContext context, {String msg = ''}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: WillPopScope(
              onWillPop: () async => false,
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoTheme(
                      data: CupertinoTheme.of(context)
                          .copyWith(brightness: Brightness.dark),
                      child: CupertinoActivityIndicator(
                        radius: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$msg',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
