import 'package:another_nav_bar/models/details.dart';
import 'package:another_nav_bar/pages/profile_page.dart';
import 'package:another_nav_bar/services/auth.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
 UserTile({ Key? key, required this.details }) : super(key: key);

  final Details details;
  static AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundImage: NetworkImage(details.imgUrl),
                  ),
                ),
                Divider(
                  color: COLOR_BLACK,
                  height: 60.0,
                ),
                Text('USERNAME',
                  style: TextStyle(
                    color: COLOR_GREY,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(details.username,
                  style: TextStyle(
                    color: COLOR_DARK_BLUE,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 30.0),
                Text(
                  'CURRENT TOWN',
                  style: TextStyle(
                    color: COLOR_GREY,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(details.residence,
                  style: TextStyle(
                    color:  COLOR_DARK_BLUE,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 30.0),
                Text(
                  'PHONE NUMBER',
                  style: TextStyle(
                    color: COLOR_GREY,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(details.phoneNumber,
                  style: TextStyle(
                    color:  COLOR_DARK_BLUE,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 30.0),
                Text(
                      'EMAIL ADDRESS',
                      style: TextStyle(
                        color: COLOR_GREY,
                        letterSpacing: 2.0,
                      ),
                ),
                SizedBox(height: 20.0),   
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      color: COLOR_BLACK,
                    ),
                    SizedBox(width: 10.0),
                    Text(details.email,
                      style: TextStyle(
                        color: COLOR_DARK_BLUE,
                        fontSize: 18.0,
                        letterSpacing: 1.0,
                      ),
                    )
                  ],
                ),
                 SizedBox(height: 30.0),
                Text(
                      'USER TYPE',
                      style: TextStyle(
                        color: COLOR_GREY,
                        letterSpacing: 2.0,
                      ),
                ),
                SizedBox(height: 20.0),   
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: COLOR_BLACK,
                    ),
                    SizedBox(width: 10.0),
                    Text(details.userType,
                      style: TextStyle(
                        color: COLOR_DARK_BLUE,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        letterSpacing: 2.0,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 100.0),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: COLOR_DARK_BLUE,
                        onPrimary: COLOR_WHITE,
                        elevation: 3
                      ),
                      onPressed: () async{
                        await _auth.signOut();
                        goToPage(context);
                      },  
                      icon: Icon(Icons.logout_rounded), 
                      label: Text('Logout',style: TextStyle(fontSize: 18),)),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
}