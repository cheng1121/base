import 'package:flutter/material.dart';

///提示框
void showHintDialog(
  BuildContext context, {
  String title = '提示',
  String hint,
  String confirm = '确认',
  String cancel = '取消',
  VoidCallback onCancel,
  VoidCallback onConfirm,
  bool barrierDismissible = true,
  bool showCancel = true,
  Color confirmColor = Colors.blue,
}) {
  showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return showCancel;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Text(hint),
            title: Text(
              title,
              textAlign: TextAlign.left,
            ),
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
            contentTextStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            actions: <Widget>[
              showCancel
                  ? FlatButton(
                      onPressed: () {
                        if (onCancel != null) {
                          onCancel();
                        }
                      },
                      child: Text(
                        cancel,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      textColor: Colors.grey,
                    )
                  : Container(),
              FlatButton(
                onPressed: () {
                  if (onConfirm != null) {
                    onConfirm();
                  }
                },
                child: Text(
                  confirm,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                textColor: confirmColor,
              )
            ],
          ),
        );
      });
}
