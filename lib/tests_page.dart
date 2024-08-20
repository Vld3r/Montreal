import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key});

  @override
  State<TestsPage> createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  int currentQuestionIndex = 0;
  int selectedAnswerIndex = -1;
  int correctAnswersCount = 0;
  bool showResult = false;
  late Timer timer;
  int timeLeft = 60; // Total time for the test in seconds

  final List<Map<String, dynamic>> questions = [
    {
      "question": "What year did the Montreal Casino officially open?",
      "options": ["1990", "1993", "1996", "1999"],
      "answerIndex": 1
    },
    {
      "question": "Which island is the Montreal Casino located on?",
      "options": [
        "Île Notre-Dame",
        "Île Sainte-Hélène",
        "Île Bizard",
        "Île de Montréal"
      ],
      "answerIndex": 0
    },
    {
      "question":
          "What is the name of the architectural style of Montreal Casino?",
      "options": ["Art Deco", "Modernist", "Postmodern", "Brutalist"],
      "answerIndex": 2
    },
    {
      "question":
          "Which event prompted the initial construction of the buildings now housing the Montreal Casino?",
      "options": [
        "1967 World’s \nFair (Expo 67)",
        "1976 Summer \nOlympics",
        "1980 Winter \nOlympics",
        "Canada’s \nCentennial"
      ],
      "answerIndex": 0
    },
    {
      "question":
          "How many gaming tables does the Montreal Casino approximately offer?",
      "options": ["50", "200", "150", "100"],
      "answerIndex": 3
    },
    {
      "question":
          "Which of these is NOT one of the restaurants located within Montreal Casino?",
      "options": [
        "Le Montréal",
        "L'Atelier de Joël \nRobuchon",
        "Pavillon 67",
        "La Ronde"
      ],
      "answerIndex": 3
    },
    {
      "question": "How many slot machines are there in the Montreal Casino?",
      "options": ["1,000", "2,000", "3,000", "4,000"],
      "answerIndex": 2
    },
    {
      "question": "What is unique about the design of the Montreal Casino?",
      "options": [
        "It is built on \nstilts over water",
        "It features two \ninterconnected \nbuildings",
        "It has an \nunderwater level",
        " It is entirely \nmade of glass"
      ],
      "answerIndex": 1
    },
    {
      "question":
          "Which of the following entertainment options is available at Montreal Casino?",
      "options": [
        "IMAX Theater",
        "Live music \nperformances",
        "Indoor skiing",
        "Amusement \npark rides"
      ],
      "answerIndex": 1
    },
    {
      "question":
          "What was the original purpose of the building that now houses Montreal Casino?",
      "options": [
        "Expo 67 Pavilion",
        "Olympic Village",
        "Hotel",
        "Government \noffice"
      ],
      "answerIndex": 0
    },
    // Add more questions here
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          showTimeoutDialog();
        }
      });
    });
  }

  void showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFF231F20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Time's Up!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'You didn\'t complete the test in time. Would you like to retry?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close dialog
                    retryTest();
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
                      'Retry Test',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void retryTest() {
    setState(() {
      currentQuestionIndex = 0;
      selectedAnswerIndex = -1;
      correctAnswersCount = 0;
      showResult = false;
      timeLeft = 60;
    });
    startTimer();
  }

  void checkAnswer(int selectedIndex) {
    setState(() {
      selectedAnswerIndex = selectedIndex;
      showResult = true;

      if (selectedAnswerIndex ==
          questions[currentQuestionIndex]['answerIndex']) {
        correctAnswersCount++;
      }

      // Move to the next question after a short delay
      Future.delayed(Duration(seconds: 1), () {
        if (currentQuestionIndex < questions.length - 1) {
          setState(() {
            currentQuestionIndex++;
            selectedAnswerIndex = -1;
            showResult = false;
          });
        } else {
          // Show the final score at the end of the quiz
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
              backgroundColor: Color(0xFF231F20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/splash.png',
                      width: 50.w,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      correctAnswersCount == questions.length
                          ? 'Congratulations!'
                          : "Quiz Finished",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      correctAnswersCount == questions.length
                          ? 'You win! You managed to answer all the questions correctly. Try your hand at other quizzes'
                          : 'You answered $correctAnswersCount out of ${questions.length} correctly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to previous screen
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
                          correctAnswersCount == questions.length
                              ? 'Continue'
                              : 'OK',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16.sp),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final options = currentQuestion['options'] as List<String>;
    final correctAnswerIndex = currentQuestion['answerIndex'] as int;

    return Scaffold(
      backgroundColor: Color(0xFF231F20),
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 5.h,
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
                      size: 14.sp,
                    ),
                  ),
                ),
                Text(
                  'Montreal Casino',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question #${currentQuestionIndex + 1}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  "00:${timeLeft.toString().padLeft(2, '0')}",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
                decoration: BoxDecoration(
                  color: Color(0xFF312D2E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  currentQuestion['question'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            Spacer(),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedAnswerIndex == index;

                Color backgroundColor;
                if (showResult) {
                  if (isSelected) {
                    backgroundColor = selectedAnswerIndex == correctAnswerIndex
                        ? Colors.green
                        : Colors.red;
                  } else {
                    backgroundColor = Color(0xFF312D2E);
                  }
                } else {
                  backgroundColor = Color(0xFF312D2E);
                }

                return GestureDetector(
                  onTap: () {
                    if (!showResult) {
                      checkAnswer(index);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        options[index],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
            Spacer(),
            Spacer(),
            Spacer()
          ],
        ),
      ),
    );
  }
}
