import 'package:another_nav_bar/pages/favorites_page.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:another_nav_bar/pages/profile_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:another_nav_bar/pages/chats_page.dart';
import 'package:another_nav_bar/pages/landing_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPages(),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

   Widget buildPages(){
    switch(index){
      case 1:
      return FavoritesPage();
      case 2:
      return ChatsPage();
      case 3:
      return ProfilePage();
      case 0:
      default:
      return HomePage();
    }
  }

  Widget buildBottomNavigation(){
    return BottomNavyBar(
      backgroundColor: COLOR_WHITE,
      itemCornerRadius: 16,
      selectedIndex: index,
      onItemSelected: (index) => setState(() => this.index = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
        icon: Icon(Icons.home),
        title: Text("Home"),
        activeColor: COLOR_BLACK,
        inactiveColor: COLOR_BLACK,
        textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
        icon: Icon(Icons.favorite_outline_rounded),
        title: Text("Favorites"),
        activeColor: COLOR_BLACK,
        inactiveColor: COLOR_BLACK,
        textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
        icon: Icon(Icons.chat_bubble_outline_rounded),
        title: Text("Chats"),
        activeColor: COLOR_BLACK,
        inactiveColor: COLOR_BLACK,
        textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
        icon: Icon(Icons.person_outline_rounded),
        title: Text("Profile"),
        activeColor: COLOR_BLACK,
        inactiveColor: COLOR_BLACK,
        textAlign: TextAlign.center,
        ),
      ],
    );
  }

}