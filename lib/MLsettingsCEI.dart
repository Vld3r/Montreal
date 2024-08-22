import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MLSettingsCER extends StatefulWidget {
  const MLSettingsCER({super.key});

  @override
  State<MLSettingsCER> createState() => _SettingsState();
}

class _SettingsState extends State<MLSettingsCER> {
  bool notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _requestReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  Future<void> _loadNotificationPreference() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = sharedPreferences.getBool('notification_enabled') ?? false;
    });
  }

  Future<void> _toggleNotification() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });
    await sharedPreferences.setBool('notification_enabled', notificationsEnabled);

    if (notificationsEnabled) {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231F20),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top,
          right: 16.w,
          left: 16.w,
        ),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildSettingsOption('Term of Service', () => _launchUrl('https://your-terms-url.com')),
            _buildSettingsOption('Privacy Policy', () => _launchUrl('https://your-privacy-url.com')),
            _buildSettingsOption('Rate Us', _requestReview),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        GestureDetector(
          onTap: _toggleNotification,
          child: Container(
            padding: EdgeInsets.all(9.sp),
            decoration: BoxDecoration(
              color: const Color(0xFF7C7C7C),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              notificationsEnabled
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_off_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsOption(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF302D2E),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}