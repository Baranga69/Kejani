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
  final String listingId;
  const DetailsPage({ Key? key,required this.listingId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    final CollectionReference ref = FirebaseFirestore.instance.collection('Kejani Listings');
    final listing = ref.where('listingId', isEqualTo: listingId);
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final DatabaseService databaseService = Get.put(DatabaseService(uid: ''));
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return SafeArea(
          child: Scaffold(
            backgroundColor: COLOR_WHITE,
            body: Container(
              width: size.width,
              height: size.height,
                  child:SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: databaseService.listingList.length,
                      itemBuilder: (BuildContext context, int index) {  
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image.network("${databaseService.listingList[index].url}"),
                              Positioned(
                                width: size.width,
                                top: padding,
                                child: Padding(
                                  padding: sidePadding,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () => goToHome(context),
                                        child: BorderIcon(
                                          height: 50,
                                          width: 50,
                                          child: Icon(Icons.keyboard_backspace,color: COLOR_BLACK,),
                                    
                                        ),
                                      ),
                                      BorderIcon(
                                        height: 50,
                                        width: 50,
                                        child: Icon(Icons.favorite_border,color:COLOR_BLACK,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(padding),
                          Padding(
                            padding: sidePadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${databaseService.listingList[index].name}",
                                          style: GoogleFonts.lato(textStyle: themeData.textTheme.headline4)),
                                        addHorizontalSpace(25),
                                        Text("${databaseService.listingList[index].address}",style: GoogleFonts.lato(textStyle: themeData.textTheme.subtitle2))
                                      ]
                                    ),
                                    addVerticalSpace(5),
                                    Row(
                                      children: [
                                        Text("${"${databaseService.listingList[index].amount}"} ksh",style: GoogleFonts.lato(textStyle: themeData.textTheme.headline4)),
                                        addHorizontalSpace(60),
                                        Container(
                                          height: 30,
                                          width: 70,
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: COLOR_WHITE,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: COLOR_DARK_BLUE, width: 3)),
                                          padding: EdgeInsets.all(4.0),
                                          child: Center(child: Text("${databaseService.listingList[index].listType}")),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              // BorderIcon(child: Text("20 Hours ago", style: themeData.textTheme.headline5,),padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),)
                              ],
                            ),
                          ),
                          addVerticalSpace(padding),
                          Padding(
                            padding: sidePadding,
                            child: Text("Amenities",style: themeData.textTheme.headline4,),
                          ),
                          addVerticalSpace(padding),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                InformationTile(content: "${"${databaseService.listingList[index].area}"} sq ft.", icon: Icons.architecture,),
                                InformationTile(content: "${"${databaseService.listingList[index].bedrooms}"} bedrooms", icon: Icons.bed,),
                                InformationTile(content: "${"${databaseService.listingList[index].bathrooms}"} bathrooms", icon: Icons.bathtub_outlined,),
                                InformationTile(content: "${"${databaseService.listingList[index].garage}"} garages", icon: Icons.garage_outlined,),
                              ],
                            ),
                          ),
                          addVerticalSpace(padding),
                          Padding(
                            padding: sidePadding,
                            child: Text("${databaseService.listingList[index].description}",
                            textAlign: TextAlign.justify,style: themeData.textTheme.bodyText2,),
                          ),
                          addVerticalSpace(100),
                        ],
                        );
                    }
                  ),
                //   Positioned(
                //     bottom: 20,
                //     width: size.width,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                            
                //           },
                //           child: OptionButton(
                //             text: "Message", 
                //             icon: Icons.message, 
                //             width: size.width*0.35,)),
                //         addHorizontalSpace(25),
                //         GestureDetector(
                //           onTap: () {
                //             _openDialer();
                //           },
                //           child: GestureDetector(
                //             onTap: () {
                //               _openSms();
                //             },
                //             child: OptionButton(
                //               text: "Call", 
                //               icon: Icons.call, 
                //               width: size.width*0.35,),
                //           )),
                //       ],
                //     ),
                //   )
                // ],
          ),
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