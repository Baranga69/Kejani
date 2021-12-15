import 'package:another_nav_bar/pages/login_page.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Find the keys to your new home",
          body: "Get access to a catalogue of every kind of residence imaginable",
          image: buildImage('assets/onboard1.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Find a community for you",
          body: "Find likeminded individuals you can build a healthy, prosperous community with",
          image: buildImage('assets/community.jpg'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Reach out to an agent immediately",
          body: "Call or chat with an agent to get more details and set up a meeting to view a house",
          image: buildImage('assets/onboard3.png'),
          decoration: getPageDecoration(),
        ),
      ],
      done: Text('Done', style: TextStyle(fontWeight:FontWeight.bold, color: COLOR_BLACK, fontSize: 20),),
      onDone: () => goLog(context),
      showSkipButton: true,
      skip: Text('Skip',style: TextStyle(fontWeight:FontWeight.bold, color: COLOR_BLACK, fontSize: 20,),), 
      onSkip: () => goLog(context),
      next: Icon(Icons.arrow_forward_rounded),
      dotsDecorator: getDotDecoration(),
      onChange: (index) => print('Page $index selected'),
      globalBackgroundColor: COLOR_WHITE,
      animationDuration: 700,
    ),
  );

  void goLog(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));

  Widget buildImage(String path) =>
  Center(child: Image.asset(path, width: 350,));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFBDBDBD),
    activeColor: COLOR_DARK_BLUE,
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyTextStyle: TextStyle(fontSize: 20),
    descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(24),
    pageColor: Colors.white,
  );
}