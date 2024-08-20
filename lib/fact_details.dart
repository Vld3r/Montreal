import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FactDetails extends StatefulWidget {
  final String image;
  final String name;
  final String fact;

  const FactDetails(
      {super.key, required this.image, required this.name, required this.fact});

  @override
  State<FactDetails> createState() => _FactDetailsState();
}

class _FactDetailsState extends State<FactDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF231F20),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              widget.image,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top,
                left: 16.w,
                right: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(9.sp),
                        decoration: BoxDecoration(
                            color: Color(0xFF7C7C7C),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(
                      width: 30.w,
                    )
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        widget.fact,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 30.h,
                      )
                    ],
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
