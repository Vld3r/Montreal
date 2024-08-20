import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:montreal/11urlsHJW.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notificationsEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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

  Future<void> rt() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  Future<void> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled =
          sharedPreferences.getBool('notification_enabled') ?? false;
    });
  }

  void toggleNotification() async {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
      "notification_enabled",
      notificationsEnabled,
    );

    if (notificationsEnabled) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF231F20),
        body: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top, right: 16.w, left: 16.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800),
                  ),
                  GestureDetector(
                    onTap: toggleNotification,
                    child: Container(
                      padding: EdgeInsets.all(9.sp),
                      decoration: BoxDecoration(
                          color: Color(0xFF7C7C7C),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Icon(
                        notificationsEnabled
                            ? Icons.notifications_active_outlined
                            : Icons.notifications_off_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: term,
                child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFF302D2E),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Text(
                    'Term of Service',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              GestureDetector(
                onTap: privacy,
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFF302D2E),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              GestureDetector(
                onTap: rt,
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFF302D2E),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Text(
                    'Rate Us',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
