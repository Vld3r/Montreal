import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'hotels_info.dart';

class Comment {
  final String name;
  final String comment;

  Comment({required this.name, required this.comment});

  // Convert a Comment object into a Map object
  Map<String, String> toMap() {
    return {
      'name': name,
      'comment': comment,
    };
  }

  // Convert a Map object into a Comment object
  factory Comment.fromMap(Map<String, String> map) {
    return Comment(
      name: map['name']!,
      comment: map['comment']!,
    );
  }

  // Convert a Comment object into a JSON string
  String toJson() {
    return jsonEncode(toMap());
  }

  // Convert a JSON string into a Comment object
  factory Comment.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return Comment.fromMap(Map<String, String>.from(map));
  }
}

class Hotel {
  final int id;
  final String name;
  final String description;
  final String place;
  final double rate;
  final List<Comment> comments;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.place,
    required this.rate,
    required this.comments,
  });
}

class HotelDetails extends StatefulWidget {
  final int hotelId;

  const HotelDetails({super.key, required this.hotelId});

  @override
  State<HotelDetails> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  bool notificationsEnabled = false;
  int selected = 0;
  String selectedImage = 'assets/01.png';
  Hotel? hotel;
  TextEditingController nameController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    loadComments();
    setState(() {
      selectedImage = 'assets/${widget.hotelId}1.png';
    });
  }

  Future<void> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled =
          sharedPreferences.getBool(widget.hotelId.toString()) ?? false;
      hotel = hotels.firstWhere((h) => h.id == widget.hotelId);
    });
  }

  Future<void> saveNotification() async {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
      widget.hotelId.toString(),
      notificationsEnabled,
    );
  }

  Future<void> loadComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedComments =
        prefs.getStringList('comments_${widget.hotelId}');

    if (savedComments != null) {
      setState(() {
        savedComments.forEach((c) {
          Comment newComment = Comment.fromJson(c);

          // Check if the comment already exists in the list
          if (!hotel!.comments.any((comment) =>
              comment.name == newComment.name &&
              comment.comment == newComment.comment)) {
            hotel?.comments.add(newComment);
          }
        });
      });
    }
  }

  Future<void> addComment(String name, String comment) async {
    Comment newComment = Comment(name: name, comment: comment);
    setState(() {
      hotel?.comments.add(newComment);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedComments =
        prefs.getStringList('comments_${widget.hotelId}') ?? [];

    savedComments.add(newComment.toJson()); // Save as JSON string
    await prefs.setStringList('comments_${widget.hotelId}', savedComments);
  }

  @override
  Widget build(BuildContext context) {
    if (hotel == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF231F20),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Stack(
              children: [
                Image.asset(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  selectedImage,
                  fit: BoxFit.cover,
                ),
                Positioned(
                    top: MediaQuery.paddingOf(context).top + 20.h,
                    left: 16.w,
                    right: 16.w,
                    child: Row(
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
                            hotel!.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp),
                          ),
                        ),
                        GestureDetector(
                          onTap: saveNotification,
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
                              size: 15.sp,
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 0;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 12.w),
                            decoration: BoxDecoration(
                                color: selected == 0
                                    ? Color(0xFFFFAA00)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: Color(0xFF4B4849))),
                            child: Text(
                              'About',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 1;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 12.w),
                            decoration: BoxDecoration(
                                color: selected == 1
                                    ? Color(0xFFFFAA00)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: Color(0xFF4B4849))),
                            child: Text(
                              'Gallery',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.h),
                    if (selected == 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            hotel!.description,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Package Facilities',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: Image.asset('assets/f1.png'),
                              ),
                              SizedBox(width: 24.w),
                              Expanded(child: Image.asset('assets/f2.png')),
                              SizedBox(width: 24.w),
                              Expanded(child: Image.asset('assets/f3.png')),
                              SizedBox(width: 24.w),
                              Expanded(child: Image.asset('assets/f4.png')),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rate This Hotel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.sp),
                              ),
                              Text(
                                '(4)',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                              )
                            ],
                          ),
                          Row(
                            children: List.generate(
                              hotel!.rate.ceil(),
                              (index) => Icon(
                                Icons.star_rate_rounded,
                                color: Color(0xFFFFAA00),
                                size: 40.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Comments',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.sp),
                              ),
                              Text(
                                '(${hotel!.comments.length})',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                              ),
                            ],
                          ),
                          ...hotel!.comments.map((c) {
                            return CommentsContainer(c.name, c.comment);
                          }).toList(),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Text(
                                'Write comment',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          TextField(
                            controller: nameController,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.sp),
                            decoration: InputDecoration(
                              hintText: 'Your Name',
                              hintStyle: TextStyle(
                                  color: Colors.white, fontSize: 12.sp),
                              filled: true,
                              fillColor: Color(0xff4B4849),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          TextField(
                            controller: commentController,
                            maxLines: 3,
                            keyboardType: TextInputType.text,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.sp),
                            decoration: InputDecoration(
                              hintText: 'Your Message',
                              hintStyle: TextStyle(
                                  color: Colors.white, fontSize: 12.sp),
                              filled: true,
                              fillColor: Color(0xff4B4849),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),
                          GestureDetector(
                            onTap: () async {
                              if (nameController.text.isNotEmpty &&
                                  commentController.text.isNotEmpty) {
                                await addComment(nameController.text,
                                    commentController.text);
                                nameController.clear();
                                commentController.clear();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13.h),
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFAA00),
                                  borderRadius: BorderRadius.circular(5.r)),
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    if (selected == 1)
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImage =
                                          'assets/${widget.hotelId}1.png';
                                    });
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 100.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/${widget.hotelId}1.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: selectedImage ==
                                                'assets/${widget.hotelId}1.png'
                                            ? Color(0xffFFAA00)
                                            : Colors.transparent,
                                        width: 1.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImage =
                                          'assets/${widget.hotelId}2.png';
                                    });
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 100.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/${widget.hotelId}2.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: selectedImage ==
                                                'assets/${widget.hotelId}2.png'
                                            ? Color(0xffFFAA00)
                                            : Colors.transparent,
                                        width: 1.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImage =
                                          'assets/${widget.hotelId}3.png';
                                    });
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 100.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/${widget.hotelId}3.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: selectedImage ==
                                                'assets/${widget.hotelId}3.png'
                                            ? Color(0xffFFAA00)
                                            : Colors.transparent,
                                        width: 1.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImage =
                                          'assets/${widget.hotelId}4.png';
                                    });
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 100.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/${widget.hotelId}4.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: selectedImage ==
                                                'assets/${widget.hotelId}4.png'
                                            ? Color(0xffFFAA00)
                                            : Colors.transparent,
                                        width: 1.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImage =
                                          'assets/${widget.hotelId}5.png';
                                    });
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 100.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/${widget.hotelId}5.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: selectedImage ==
                                                'assets/${widget.hotelId}5.png'
                                            ? Color(0xffFFAA00)
                                            : Colors.transparent,
                                        width: 1.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImage =
                                          'assets/${widget.hotelId}6.png';
                                    });
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 100.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/${widget.hotelId}6.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: selectedImage ==
                                                'assets/${widget.hotelId}6.png'
                                            ? Color(0xffFFAA00)
                                            : Colors.transparent,
                                        width: 1.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget CommentsContainer(String name, String comment) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(top: 10.h),
    decoration: BoxDecoration(
      color: Color(0xff312D2E),
      borderRadius: BorderRadius.circular(15.r),
    ),
    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
              color: Color(0xffFFAA00),
              fontWeight: FontWeight.w700,
              fontSize: 14.sp),
        ),
        Text(
          comment,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ],
    ),
  );
}
