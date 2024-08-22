import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'MLhotel_detailsWCD.dart';
import 'MLhotels_infoCER.dart'; // Make sure to import the necessary files

class MLHomePageCER extends StatefulWidget {
  const MLHomePageCER({super.key});

  @override
  State<MLHomePageCER> createState() => _HomePageState();
}

class _HomePageState extends State<MLHomePageCER> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF231F20),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top,
          left: 16.w,
          right: 16.w,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        'We have found for you a wonderful selection of hotels',
                        style: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: hotels.map((hotel) {
                    return HotelContainer(
                      hotel.name,
                      hotel.rate,
                      hotel.place,
                      'assets/${hotel.id}.png',
                      // Assuming the image asset is named by hotel ID
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HotelDetails(hotelId: hotel.id),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget HotelContainer(String title, double rate, String location, String image,
    VoidCallback onTap) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        color: Color(0xff312D2E),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 118.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Container(
            width: 150.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Color(0xFFFFAA00),
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        color: Color(0xFFFFAA00),
                        fontSize: 14.sp,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star_rate_rounded,
                      color: Color(0xFFFFAA00),
                    ),
                    Text(
                      rate.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
