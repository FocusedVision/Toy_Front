import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

import '../../config/my_colors.dart';
import '../../widgets/app_bars/simple_app_bar.dart';

class TermsOfUsageScreen extends StatefulWidget {
  TermsOfUsageScreen({Key? key}) : super(key: key);

  @override
  State<TermsOfUsageScreen> createState() => _TermsOfUsageScreenState();
}

class _TermsOfUsageScreenState extends State<TermsOfUsageScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Terms of usage',
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://toyvalley.io/terms',
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Container(
                  color: MyColors.lightBlue,
                  child: const Center(
                    child: CircularProgressIndicator(color: MyColors.orange),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
