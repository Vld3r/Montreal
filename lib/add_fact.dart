import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hotels_info.dart';

class AddFact extends StatefulWidget {
  @override
  _AddFactState createState() => _AddFactState();
}

class _AddFactState extends State<AddFact> {
  int? selectedHotelId;
  TextEditingController factController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF231F20),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: MediaQuery.paddingOf(context).top),
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
                Text(
                  'New Fact',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp),
                ),
                SizedBox(
                  width: 30.w,
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Add New Fact',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5.h),
            DropdownButtonFormField<int>(
              itemHeight: 40.h,
              value: selectedHotelId,
              hint: Text(
                'Select Hotel',
                style: TextStyle(
                    color: Colors.white, fontSize: 10.sp, height: 0.7),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff4B4849),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),

                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 15.h), // Adjusted padding
              ),
              dropdownColor: Color(0xff4B4849),
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              items: hotels.map((hotel) {
                return DropdownMenuItem<int>(
                  value: hotel.id,
                  child: Text(
                    hotel.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      height:
                          0.7, // Ensures the text is properly aligned vertically
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedHotelId = value;
                });
              },
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: factController,
              maxLines: 3,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              decoration: InputDecoration(
                hintText: 'Enter your Facts Here',
                hintStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
                filled: true,
                fillColor: Color(0xff4B4849),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: () async {
                if (selectedHotelId != null && factController.text.isNotEmpty) {
                  await saveFact(selectedHotelId!, factController.text);
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFFFAA00),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  'Save',
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
    );
  }

  Future<void> saveFact(int hotelId, String fact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Find the last fact index
    int factIndex = 0;
    while (prefs.containsKey('hotel_${hotelId}_fact_$factIndex')) {
      factIndex++;
    }

    // Save the new fact with the incremented index
    await prefs.setString('hotel_${hotelId}_fact_$factIndex', fact);
  }
}
