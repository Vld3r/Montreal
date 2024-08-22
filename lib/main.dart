import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:montreal/MLsplash_screenERT.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late AppsflyerSdk mlAppsflyerSdk;
Future<void> _mlFirebaseInit() async {
  await Firebase.initializeApp();
}

Future<void> _mlHatOneSignalInitNet() async {
  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  await OneSignal.Location.setShared(false);
  OneSignal.initialize('aa0cfad3-732f-45ee-b99d-75c67d650004');
  await Future.delayed(const Duration(seconds: 1));
  OneSignal.Notifications.requestPermission(false);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences mlSharedPreferences = await SharedPreferences.getInstance();
  await _mlFirebaseInit();
  await _mlHatOneSignalInitNet();
  runApp(MultiProvider(
    providers: [
      Provider<SharedPreferences>(
        create: ((context) => mlSharedPreferences),
      ),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen()
    ),);
  }
}
