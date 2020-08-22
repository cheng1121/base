import 'package:base/route/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebViewState();
  }
}

class _WebViewState extends State<WebViewPage> {
  WebViewController _webViewController;
  final Set gestureRecognizers = [
    Factory(() => EagerGestureRecognizer()),
  ].toSet();
  String _url;
  String _title;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argument = RouteArgument.getArgument(context);
    if (argument is Map) {
      _url = argument['url'];
      _title = argument['title'] ?? '';
      assert(_url != null, 'url is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: WebView(
        initialUrl: _url,
        // 加载js
        javascriptMode: JavascriptMode.unrestricted,
        debuggingEnabled: true,
        onWebViewCreated: (WebViewController controller) {
          _webViewController = controller;
          _webViewController.currentUrl().then((url) {
            debugPrint('返回当前$url');
          });
        },
        onPageFinished: (String value) async {
          debugPrint('加载完成: $value');
        },
        gestureRecognizers: gestureRecognizers,
        // gestureRecognizers: Set()
        //   ..add(Factory<VerticalDragGestureRecognizer>(
        //       () => VerticalDragGestureRecognizer())),
      ),
    );
  }
}
