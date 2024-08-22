import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:montreal/MLhomeEUV.dart';
import 'package:montreal/MLinterestingICU.dart';
import 'package:montreal/MLquizEII.dart';
import 'package:montreal/MLsettingsCEI.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // List of pages
  final List<Widget> _pages = [
    MLHomePageCER(),
    MLInterestingCET(),
    MLSettingsCER(),
    Quiz(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF231F20),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF4B4849),
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 0
                  ? 'assets/home_active.png'
                  : 'assets/home_inactive.png',
              width: 24.w,
              height: 24.h,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 1
                  ? 'assets/interesting_active.png'
                  : 'assets/interesting_inactive.png',
              width: 24.w,
              height: 24.h,
            ),
            label: 'Interesting',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 2
                  ? 'assets/settings_active.png'
                  : 'assets/settings_inactive.png',
              width: 24.w,
              height: 24.h,
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 3
                  ? 'assets/quiz_active.png'
                  : 'assets/quiz_inactive.png',
              width: 24.w,
              height: 24.h,
            ),
            label: 'Quiz',
          ),
        ],
        selectedItemColor: Color(0xFFFFAA00),
        unselectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(fontSize: 12.sp),
        unselectedLabelStyle: TextStyle(fontSize: 12.sp),
      ),
    );
  }
}
