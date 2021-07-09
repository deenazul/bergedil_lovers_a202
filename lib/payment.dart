import 'dart:async';

import 'package:bergedil_lovers/user.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PayScreen extends StatefulWidget {
  final User user;
  final String email;
  const PayScreen({Key key, this.user, this.email}) : super(key: key);

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl:
                      'http://nurulida1.com/272834/bergedillovers/php/generate_bill.php?email=' +
                          widget.user.email +
                          '&mobile=' +
                          widget.user.phone +
                          '&name=' +
                          widget.user.name +
                          '&amount=' +
                          widget.user.amount,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
