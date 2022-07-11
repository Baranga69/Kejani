import 'package:another_nav_bar/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileHeaderWidget extends StatefulWidget {
   ProfileHeaderWidget({ Key? key,}) : super(key: key);

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
   final DatabaseService databaseService = Get.put(DatabaseService(uid: ''));

   final double padding = 10;

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
                  child: FutureBuilder <String>(
                    future: loadImage(),
                    builder: (BuildContext context, AsyncSnapshot<String> image,){
                      if(image.hasData){
                        return Row(
                          children:[ 
                          CircleAvatar(
                          radius: 24,
                          child:Image.network(image.data.toString())),
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
                        );
                      } else {
                        return new Row(
                          children:[ 
                          CircleAvatar(
                          radius: 24,
                          child:Image.asset('assets/user_2.jpg')),
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
                        ); // placeholder
                      }
                    }
                   
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

    Future <String> loadImage() async{
    final _userID = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot variable = await FirebaseFirestore.instance.
      collection('Kejani Users').
      doc(_userID).
      get();

      var fileName = variable['ImgUrl'];
      //var nameUser = variable['Username'];

      // DatabaseReference reference = FirebaseDatabase.instance.ref().child("Kejani Users/$_userID").child(nameUser[0]);
      // var name = await reference.get();

      Reference ref = FirebaseStorage.instance.ref().child("Kejani Users/$_userID/ImgUrl").child(fileName[0]);
      var url = await ref.getDownloadURL();
      print('url:' + url);
      return url;
    }
}


