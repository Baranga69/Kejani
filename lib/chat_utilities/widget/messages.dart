import 'package:another_nav_bar/api/firebase_api.dart';
import 'package:another_nav_bar/chat_utilities/widget/messager.dart';
import 'package:another_nav_bar/models/message.dart';
import 'package:another_nav_bar/utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesWidget extends StatelessWidget {

  const MessagesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final _uid = user!.uid; 
    return SafeArea(
      child: 
      Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chat_logs').doc(_uid)
          .collection('messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
              return Center(child: Loading());
             default:
             if (snapshot.hasError){
               return Text('Something went wrong... Try again later');
             } else {
               final messages = snapshot.data!;
                
               if(snapshot.hasData){
                 return ListView.builder(
                   physics: BouncingScrollPhysics(),
                   reverse: true,
                   itemCount: messages.size,
                   itemBuilder: (context, index){
                    DocumentSnapshot currentUser = messages.docs[index];
                    String message = currentUser.get('message');
                    String userId = currentUser.get('userId');
                    String imgUrl = currentUser.get('ImgUrl');
                    Timestamp dateTime = currentUser.get("createdAt");
                    Message messData = new Message(
                      userId: userId, 
                      avatarUrl: imgUrl,  
                      message: message,
                      createdAt:dateTime);
                    return MessageWidget(message: messData, isMe: messData.userId ==_uid);
                   });
               } else {
                return Center(child: Loading(),
                );
              } 
            }
           }
          },
        )
      )
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}