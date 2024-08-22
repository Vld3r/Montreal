import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MLadd_factCED.dart';
import 'MLfact_detailsCHE.dart';
import 'MLhotel_detailsWCD.dart';
import 'MLhotels_infoCER.dart';

class MLInterestingCET extends StatefulWidget {
  const MLInterestingCET({super.key});

  @override
  State<MLInterestingCET> createState() => _InterestingState();
}

class _InterestingState extends State<MLInterestingCET> {
  List<Map<String, dynamic>> interestingFacts = [];

  @override
  void initState() {
    super.initState();
    _loadFacts();
  }

  Future<void> _loadFacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> loadedFacts = [];

    for (Hotel hotel in hotels) {
      List<String> facts = [];
      int factIndex = 0;

      while (prefs.containsKey('hotel_${hotel.id}_fact_$factIndex')) {
        String? fact = prefs.getString('hotel_${hotel.id}_fact_$factIndex');
        if (fact != null) facts.add(fact);
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
      backgroundColor: const Color(0xFF231F20),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + 10.h,
          left: 16.w,
          right: 16.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: interestingFacts.isEmpty
                  ? _buildEmptyState()
                  : _buildFactsList(),
            ),
            _buildAddFactButton(),
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
          'Interesting Facts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Add your first fact',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFactsList() {
    return ListView.builder(
      itemCount: interestingFacts.length,
      itemBuilder: (context, index) {
        final hotel = interestingFacts[index]['hotel'] as Hotel;
        final facts = interestingFacts[index]['facts'] as List<String>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: facts.map((fact) => _buildFactCard(hotel, fact)).toList(),
        );
      },
    );
  }

  Widget _buildFactCard(Hotel hotel, String fact) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MLFactDetailsCEJ(
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
            color: const Color(0xFF312D2E),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHotelImage(hotel.id),
              SizedBox(width: 16.w),
              Expanded(child: _buildHotelDetails(hotel)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelImage(int hotelId) {
    return Container(
      width: 100.w,
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        image: DecorationImage(
          image: AssetImage('assets/$hotelId.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHotelDetails(Hotel hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        _buildHotelLocation(hotel.place),
        SizedBox(height: 4.h),
        _buildHotelRating(hotel.rate),
      ],
    );
  }

  Widget _buildHotelLocation(String location) {
    return Row(
      children: [
        Icon(Icons.location_on, color: const Color(0xFFFFAA00)),
        SizedBox(width: 4.w),
        Text(
          location,
          style: TextStyle(
            color: const Color(0xFFFFAA00),
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildHotelRating(double rating) {
    return Row(
      children: [
        Icon(Icons.star_rate_rounded, color: Colors.amber, size: 14.sp),
        SizedBox(width: 4.w),
        Text(
          rating.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildAddFactButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MLAddFactCEI()),
          ).then((_) => _loadFacts()); // Reload facts after adding a new one
        },
        child: Container(
          height: 50.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFAA00),
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
    );
  }
}