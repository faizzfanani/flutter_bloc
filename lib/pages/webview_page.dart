import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Github WebView'),
        backgroundColor: Color(0xff33313b),
      ),
      body: WebView(
        initialUrl: 'https://github.com',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
