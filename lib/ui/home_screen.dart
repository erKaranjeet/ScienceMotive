import 'package:flutter/material.dart';
import 'package:science_motive/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  late WebViewController controller;

  late bool isLoading = true, canGoBack = false;

  @override
  void initState() {
    super.initState();

    initWebViewController();
  }

  void initWebViewController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {

            },
            onPageStarted: (String url) {
              isLoading = true;
              setState(() { });
            },
            onPageFinished: (String url) async {
              isLoading = false;
              if (await controller.canGoBack()) {
                canGoBack = true;
              } else {
                canGoBack = false;
              }
              setState(() { });
            },
            onWebResourceError: (WebResourceError error) {

            },
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          )
      )
      ..loadRequest(Uri.parse(Constants.webUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   elevation: 5.0,
      //   leading: canGoBack ? GestureDetector(
      //     onTap: () async {
      //       if (await controller.canGoBack()) {
      //         controller.goBack();
      //       }
      //     },
      //     child: const Icon(
      //       Icons.arrow_back_rounded,
      //       color: Colors.white,
      //       size: 25.0,
      //     ),
      //   ) : Container(),
      //   title: const Text(
      //     Constants.appName,
      //     textAlign: TextAlign.center,
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontWeight: FontWeight.w700,
      //       fontSize: 22.0,
      //     ),
      //   ),
      // ),
      body: WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
            controller.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: WebViewWidget(
                  controller: controller,
                ),
              ),
              isLoading ? const Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                    strokeWidth: 5.0,
                  ),
                ),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}