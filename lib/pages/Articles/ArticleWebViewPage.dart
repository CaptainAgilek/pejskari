import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// This class represents page with open article. WebView is used for displaying article (url).
class ArticleWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const ArticleWebViewPage({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  _ArticleWebViewPageState createState() => _ArticleWebViewPageState();
}

class _ArticleWebViewPageState extends State<ArticleWebViewPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Stack(children: <Widget>[
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (value) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ]));
  }
}
