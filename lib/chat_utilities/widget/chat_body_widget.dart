import 'package:another_nav_bar/pages/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:another_nav_bar/models/user.dart';

class ChatBodyWidget extends StatelessWidget {
  final UserData users;

  const ChatBodyWidget({
    required this.users,
     Key? key,
     }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
        height: 75,
        child: ListTile(
          onTap: () => goToChat(context),
          leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(users.urlAvatar),
                ),
                title: Text(users.username),
        ),
      ),
      ),
    );  
   }
    // Widget buildChats(){
    //   return 
    // },
    void goToChat(context) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatPage()));
}
