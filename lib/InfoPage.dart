import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'HomePage.dart';
import 'main.dart';

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Corona Virus Information'),
      // ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'https://www.worldometers.info/coronavirus/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(null)),
                      );
                      // Navigator.pop(context);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.keyboard_return, size: 36.0),
        heroTag: null,
        ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

}