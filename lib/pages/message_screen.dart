import 'package:another_nav_bar/chat_utilities/widget/messages.dart';
import 'package:another_nav_bar/chat_utilities/widget/new_message.dart';
import 'package:another_nav_bar/chat_utilities/widget/profile_header.dart';
import 'package:another_nav_bar/models/details.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
 
  const ChatPage({
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: COLOR_DARK_BLUE,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(details: Details(email: "", username: "", phoneNumber: "", residence: "", imgUrl: "",userType: '', lastMessageTime: DateTime.now()),),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(),
                ),
              ),
              NewMessageWidget(),
            ],
          ),
        ),
      );
}