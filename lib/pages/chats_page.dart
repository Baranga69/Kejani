import 'package:another_nav_bar/chat_utilities/widget/chat_body_widget.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:another_nav_bar/utilities/loading.dart';
import 'package:another_nav_bar/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    String currentUserId = _auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_BLACK,
        title: Text("Chats"),
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Kejani Users').where('uid',isNotEqualTo: currentUserId).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                return Center(child: Loading(),
                );
              }
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index){
                    DocumentSnapshot currentUser = snapshot.data!.docs[index];
                    String username = currentUser.get('Username');
                    String urlAvatar = currentUser.get('ImgUrl');
                    String uid = currentUser.get('uid');
                    Timestamp lastMessageTime = currentUser.get('lastMessageTime');
                    UserData userData = new UserData(username: username,urlAvatar: urlAvatar, uid: uid, lastMessageTime: lastMessageTime);
                    return  ChatBodyWidget(users: userData);
                  },
                );
              } else {
                return Center(child: Loading(),
                );
              }
            },
          )
      )
    );
  }
}