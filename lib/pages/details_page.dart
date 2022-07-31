import 'package:another_nav_bar/custom/BorderIcon.dart';
import 'package:another_nav_bar/custom/OptionButton.dart';
import 'package:another_nav_bar/pages/home_screen.dart';
import 'package:another_nav_bar/services/database.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:another_nav_bar/utilities/loading.dart';
import 'package:another_nav_bar/utilities/widget_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


class DetailsPage extends StatelessWidget {
  const DetailsPage({ Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final listingID = ModalRoute.of(context)?.settings.arguments;
    if (kDebugMode){
      print(listingID);
    }
    final CollectionReference ref = FirebaseFirestore.instance.collection('Kejani Listings');
    final listing = ref.where('listingId', isEqualTo: listingID);
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final DatabaseService databaseService = Get.put(DatabaseService(uid: ''));
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
 return SafeArea(
      child: Scaffold(
      backgroundColor: COLOR_WHITE,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Kejani Listings').where('listingId', isEqualTo: listingID).snapshots(),
          builder: (context, snapshot){
            if (!snapshot.hasData){
              return Text('No Data...');
            } else {
              CollectionReference listRef = FirebaseFirestore.instance.collection('Kejani Listings')
            }
          },
        )
      )
    );
  }
}
void goToHome(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));

_openDialer() async {
  final Uri _teleLaunchUri = Uri(
    scheme: 'tel',
    path: '+254 703 889 605');
  if (await canLaunchUrl(_teleLaunchUri)){
    await launchUrl(_teleLaunchUri);
  } else {
    throw 'Could not launch $_teleLaunchUri';
  }
}

_openSms() async {
  final Uri _smsLaunchUri = Uri(
    scheme: 'sms',
    path: '+254 703 889 605');
  if (await canLaunchUrl(_smsLaunchUri)){
    await launchUrl(_smsLaunchUri);
  } else {
    throw 'Could not reach $_smsLaunchUri';
  }
}

class InformationTile extends StatelessWidget {

  final String content;
  final IconData icon;
  
  const InformationTile({ Key? key, required this.content, required this.icon }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double tileSize = size.width*0.22;
    return Container(
      height: tileSize,
      width: tileSize,
      margin: const EdgeInsets.only(left: 25),
      decoration: BoxDecoration(
        color: COLOR_WHITE,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: COLOR_GREY.withAlpha(40), width: 3)),
        padding: EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 45,),
          addVerticalSpace(10),
          Text(content,style: TextStyle(fontSize: 11),)
        ],
      ),
    );
  }
}