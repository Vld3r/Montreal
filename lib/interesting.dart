import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_fact.dart';
import 'fact_details.dart';
import 'hotel_details.dart';
import 'hotels_info.dart';

class Interesting extends StatefulWidget {
  const Interesting({super.key});

  @override
  State<Interesting> createState() => _InterestingState();
}

class _InterestingState extends State<Interesting> {
  List<Map<String, dynamic>> interestingFacts = [];

  @override
  void initState() {
    super.initState();
    loadFacts();
  }

  Future<void> loadFacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> loadedFacts = [];

    for (Hotel hotel in hotels) {
      List<String> facts = [];

      // Load all facts for the current hotel
      int factIndex = 0;
      while (prefs.containsKey('hotel_${hotel.id}_fact_$factIndex')) {
        String? fact = prefs.getString('hotel_${hotel.id}_fact_$factIndex');
        if (fact != null) {
          facts.add(fact);
        }
        factIndex++;
      }

      if (facts.isNotEmpty) {
        loadedFacts.add({
          'hotel': hotel,
          'facts': facts,
        });
      }
    }

    setState(() {
      interestingFacts = loadedFacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF231F20),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + 10.h,
          left: 16.w,
          right: 16.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Interesting Facts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Expanded(
              child: interestingFacts.isEmpty
                  ? Center(
                      child: Text(
                        'Add your first fact',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: interestingFacts.length,
                      itemBuilder: (context, index) {
                        final hotel = interestingFacts[index]['hotel'] as Hotel;
                        final facts =
                            interestingFacts[index]['facts'] as List<String>;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: facts.map((fact) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 0.w,
                                vertical: 10.h,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FactDetails(
                                        image: 'assets/${hotel.id}1.png',
                                        name: hotel.name,
                                        fact: fact,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16.h),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF312D2E),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 100.w,
                                        height: 70.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/${hotel.id}1.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              hotel.name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Color(0xFFFFAA00),
                                                ),
                                                Text(
                                                  hotel.place,
                                                  style: TextStyle(
                                                      color: Color(0xFFFFAA00),
                                                      fontSize: 14.sp),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star_rate_rounded,
                                                  color: Colors.amber,
                                                  size: 14.sp,
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  hotel.rate.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFact()),
                  ).then((_) =>
                      loadFacts()); // Reload facts after adding a new one
                },
                child: Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFAA00),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    '+ Add New Fact',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
