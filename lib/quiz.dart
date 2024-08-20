import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:montreal/tests_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  bool notificationsEnabled = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  Future<void> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled =
          sharedPreferences.getBool('quiz') ?? false;
    });
  }
Future<void> quizNot() async {
  setState(() {
    notificationsEnabled = !notificationsEnabled;
  });
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool(
    "quiz",
    notificationsEnabled,
  );

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF231F20),
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top+10.h, left: 16.w, right: 16.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quiz',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800),
                ),
                GestureDetector(
                  onTap: quizNot,
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
                      size: 16.sp,
                    ),
                  ),
                )
              ],
            ),
        SizedBox(height: 20.h,),
       GestureDetector(
         onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>TestsPage()));
         },
         child:  Container(
         width: double.infinity,
         margin: EdgeInsets.only(top: 10.h),
         decoration: BoxDecoration(
           color: Color(0xff312D2E),
           borderRadius: BorderRadius.circular(15.r),
         ),
         padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               'Montreal Casino',
               style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16.sp
               ),
             ),
           ],
         ),
       ),)
          ],
        ),
      ),
    );
  }
}
