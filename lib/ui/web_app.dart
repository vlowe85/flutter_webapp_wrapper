import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webapp_wrapper/constants.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebAppPage extends StatefulWidget {
  @override
  _WebAppPageState createState() => _WebAppPageState();
}

class _WebAppPageState extends State<WebAppPage> {

  final flutterWebviewPlugin = FlutterWebviewPlugin();

  // a flag we could use for something?
  bool pageLoaded = false;

  // todo
  // 1. handle bad http response from webapp
  // 2. handle offline device

  @override
  void initState() {
    super.initState();

    // The webapp has a dark theme so setting the system icons light
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    // add some web view listeners for info
    flutterWebviewPlugin.onStateChanged.listen((state) {
      if(state.type == WebViewState.finishLoad) {
        pageLoaded=true;
      }
    });
    flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {
      print("WebView http error: ${error.code} - ${error.url}");
      // handle this?
    });
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      print('WebView url $url');
    });
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WebviewScaffold(
        resizeToAvoidBottomInset: Platform.isAndroid, // only do this on android
        hidden: true,
        initialChild: Center(child: CircularProgressIndicator()),
        scrollBar: false,
        url: webAppUrl,
        headers: {"isApp": "true"}, // just in case you want to pass something to the web app in headers
        withLocalStorage: true,
        appCacheEnabled: true,
        withJavascript: true,
      ),
    );
  }
}