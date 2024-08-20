import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:montreal/navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnbScreen extends StatefulWidget {
  const OnbScreen({super.key});

  @override
  State<OnbScreen> createState() => _OnbScreenState();
}

class _OnbScreenState extends State<OnbScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF231F20),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/onb.png',
                width: 150.w,
                height: 150.w,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Welcome to',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp),
              ),
              Text(
                'Lotoquébec \nde Montréal',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  'See reviews of the hotels you are interested in. Find out all the information you need and get a full description of all the amenities and benefits.',
                  style: TextStyle(color: Color(0xff7C7C7C), fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              GestureDetector(
                onTap: () async {
                  SharedPreferences sharedPrefs =
                      await SharedPreferences.getInstance();
                  sharedPrefs.setBool('aaa', true);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationPage()));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xFFFFAA00),
                      borderRadius: BorderRadius.circular(5.r)),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16.sp),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
