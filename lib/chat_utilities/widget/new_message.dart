import 'package:another_nav_bar/api/firebase_api.dart';
import 'package:another_nav_bar/models/details.dart';
import 'package:another_nav_bar/models/user.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:another_nav_bar/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:another_nav_bar/models/message.dart';

class NewMessageWidget extends StatefulWidget {

  const NewMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage() async {
    FocusScope.of(context).unfocus();

    _uploadMessage();

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 45,
                child: TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: 'Type your message',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      gapPadding: 5,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    message = value;
                  }),
                ),
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: message.trim().isEmpty ? null : sendMessage,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: COLOR_DARK_BLUE,
                ),
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      );

  void _uploadMessage() async{
    final User? user = _auth.currentUser;
    
    final _uid = user!.uid;
    await FirebaseFirestore.instance.collection('chat_logs').doc(_uid).collection('messages').add({
      "message":"$message",
      "userId": "$_uid",
      "ImgUrl": "",
      "createdAt": Timestamp.now()
    });

    final refUsers = FirebaseFirestore.instance.collection('Kejani Users');
    await refUsers.doc(_uid).update({UserField.lastMessageTime:DateTime.now()});
  }
}