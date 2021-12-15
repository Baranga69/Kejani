import 'package:another_nav_bar/pages/onboarding_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {  
    //double screenWidth = window.physicalSize.width;
   return MaterialApp(
       debugShowCheckedModeBanner: false, 
       home: OnBoardingPage(),
   );
  }

}

 