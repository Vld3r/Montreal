import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:montreal/MLnavigation_pageEUI.dart';

class OnbScreen extends StatefulWidget {
  const OnbScreen({super.key});

  @override
  State<OnbScreen> createState() => _OnbScreenState();
}

class _OnbScreenState extends State<OnbScreen> {
  Future<void> _onGetStarted() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool('aaa', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavigationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231F20),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/onb.png',
                width: 150.w,
                height: 150.w,
              ),
              SizedBox(height: 20.h),
              Text(
                'Welcome to',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
              Text(
                'Lotoquébec \nde Montréal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  'See reviews of the hotels you are interested in. Find out all the information you need and get a full description of all the amenities and benefits.',
                  style: TextStyle(
                    color: const Color(0xff7C7C7C),
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50.h),
              GestureDetector(
                onTap: _onGetStarted,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFAA00),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}