import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:science_motive/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  late WebViewController controller;
  late BannerAd bannerAd;

  late bool isLoading = false, canGoBack = false, isBannerLoaded = false;

  @override
  void initState() {
    super.initState();

    initWebViewController();
    initBannerAd();
  }

  void initBannerAd() {
    bannerAd = BannerAd(
      adUnitId: kDebugMode ? Constants.BANNER_DEBUG_ADMOB_ID : Constants.BANNER_ADMOB_ID,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
          onAdLoaded: (ad) {
            print('$ad loaded.');
            setState(() {
              isBannerLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            print('BannerAd failed to load: $error');
            ad.dispose();
          },
          onAdOpened: (ad) {

          },
          onAdClosed: (ad) {

          },
          onAdImpression: (ad) {

          },
          onAdClicked: (ad) {

          }
      ),
    );
    bannerAd.load();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5.0,
        leading: canGoBack ? GestureDetector(
          onTap: () async {
            if (await controller.canGoBack()) {
              controller.goBack();
            }
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 25.0,
          ),
        ) : Container(),
        title: const Text(
          Constants.appName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22.0,
          ),
        ),
      ),
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
              isBannerLoaded ? Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                height: 70.0,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  // height: 65.0,
                  child: AdWidget(
                    ad: bannerAd,
                  ),
                ),
              ) : Container(),
              Positioned(
                top: isBannerLoaded ? 70.0 : 0.0,
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