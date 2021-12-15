import 'package:another_nav_bar/chat_utilities/chats/chat_card.dart';
import 'package:another_nav_bar/chat_utilities/messages/message_screen.dart';
import 'package:another_nav_bar/custom/filled_outline_button.dart';
import 'package:another_nav_bar/utilities/chat.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color: COLOR_DARK_BLUE,
          child: Row(
            children: [
              FillOutlineButton(press: () {}, text: "Recent Message",),
              SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () {},
                text: "Active",
                isFilled: false,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: chatsData.length,
            itemBuilder: (context, index) => ChatCard(
              chat: chatsData[index],
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagesScreen(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}