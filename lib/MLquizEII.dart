import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:montreal/MLtests_pageCER.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  bool notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = sharedPreferences.getBool('quiz') ?? false;
    });
  }

  Future<void> _toggleNotification() async {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });

    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('quiz', notificationsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231F20),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + 10.h,
          left: 16.w,
          right: 16.w,
        ),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildQuizOption(
              title: 'Montreal Casino',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TestsPage()),
              ),
            ),
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
          'Quiz',
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
              size: 16.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizOption({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFF312D2E),
          borderRadius: BorderRadius.circular(15.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}