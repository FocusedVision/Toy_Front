import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

import '../../config/my_colors.dart';
import '../../widgets/app_bars/simple_app_bar.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
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
        title: 'Privacy Policy',
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://toyvalley.io/privacy',
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
