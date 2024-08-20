import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:montreal/navigation_page.dart';
import 'package:montreal/onb_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '11urlsHJW.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Tween
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Animation duration is 3 seconds
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();

    // Add listener to navigate to next screen when animation completes
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        bool aaa = sharedPreferences.getBool('aaa') ?? false;
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
      }
    });
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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                Container(
                  width: 100.w,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _animation.value,
                        backgroundColor: Colors.white,
                        color: Color(0xFF231F20),
                        minHeight: 2.h,
                      );
                    },
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
