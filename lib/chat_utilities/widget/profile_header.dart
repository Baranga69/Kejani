import 'package:another_nav_bar/models/details.dart';
import 'package:another_nav_bar/models/message.dart';
import 'package:another_nav_bar/pages/chats_page.dart';
import 'package:another_nav_bar/pages/landing_page.dart';
import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
   final Details details;

   ProfileHeaderWidget({
    Key? key, required this.details
   }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        padding: EdgeInsets.all(16).copyWith(left: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white, onPressed: () => Navigator.pop(context)),
                SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children:[ 
                    CircleAvatar(
                    radius: 24,
                   backgroundImage: NetworkImage(details.imgUrl)),
                    SizedBox(width:10),
                    Text(
                    "User",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                    ]
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildIcon(Icons.call),
                    SizedBox(width: 12),
                    buildIcon(Icons.videocam),
                  ],
                ),
                SizedBox(width: 4),
              ],
            )
          ],
        ),
      );
  Widget buildIcon(IconData icon) => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white54,
        ),
        child: Icon(icon, size: 25, color: Colors.white),
      );
}