import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:parkinson/screens/home.dart';

class TestScreen extends StatefulWidget {
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final List<Introduction> list = [
    Introduction(
      title: 'Welcome',
      subTitle: 'Early Parkinson\'s detection',
      imageUrl: 'assets/brain chemistry.gif',
    ),
    Introduction(
      title: 'Image Analysis',
      subTitle: 'Analyzing spiral and wave images',
      imageUrl: 'assets/brain organ.gif',
    ),
    Introduction(
      title: 'Get Started',
      subTitle: 'Begin your journey',
      imageUrl: 'assets/brain sides.gif',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      backgroudColor: Colors.white,
      introductionList: list,
      onTapSkipButton: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ), //MaterialPageRoute
        );
      },
    );
  }
}
