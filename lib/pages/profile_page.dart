
import 'package:another_nav_bar/custom/user_list.dart';
import 'package:another_nav_bar/models/details.dart';
import 'package:another_nav_bar/pages/login_page.dart';
import 'package:another_nav_bar/utilities/loading.dart';
import 'package:another_nav_bar/utilities/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:another_nav_bar/services/database.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Kejani Users').snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                return Center(child: Loading(),
                );
              }
              if(snapshot.hasData){
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index){
                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  final User? user = _auth.currentUser;
                  final _uid = user!.uid;
                  DocumentSnapshot currentUser = snapshot.data!.docs[index];
                  String email = currentUser.get('Email');
                  String username = currentUser.get('Username');
                  String phoneNumber = currentUser.get('PhoneNumber');
                  String residence = currentUser.get('Residence');
                  String imgUrl = currentUser.get('ImgUrl');
                  String userType = currentUser.get('UserType');
                  Details userDetails = new Details(
                    email: email, 
                    username: username,
                    phoneNumber: phoneNumber, 
                    residence: residence,
                    userType: userType,
                    imgUrl: imgUrl, lastMessageTime: DateTime.parse("1969-07-20 20:18:04Z"));
                  return  snapshot.data!.docs[index].id.toString()==_uid? UserTile(details: userDetails): Text('');
                  },
                );
              } else {
                return Center(child: Loading(),
                );
              }
            },
          )
      ),
    );
  }
}
void goToPage(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));