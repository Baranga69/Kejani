//import 'package:another_nav_bar/custom/BorderBox.dart';
import 'package:another_nav_bar/models/listings.dart';
import 'package:another_nav_bar/pages/details_page.dart';
import 'package:another_nav_bar/pages/newListing_stepper.dart';
import 'package:another_nav_bar/pages/new_listing.dart';
import 'package:another_nav_bar/services/database.dart';
import 'package:another_nav_bar/utilities/chip_controller.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:another_nav_bar/utilities/widget_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    //dependency injection with GetX
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? userLog = _auth.currentUser;
    final _uid = userLog!.uid;
    final DatabaseService databaseService = Get.put(DatabaseService(uid: ''));
    final ChipController chipController = Get.put(ChipController());
    //name of chips as list
    final List<String> _chipLabel = ['All','<2500sqft.','3-5 Beds','<100,000','>1,000,000','For Rent','For Sale'];
    final double padding = 10;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: COLOR_DARK_BLUE,
          onPressed: () => goToList(context)),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                addVerticalSpace(padding),
                // Padding(
                //   padding: sidePadding,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       BorderBox(
                //         height: 50,
                //         width:50,
                //         child: Icon(Icons.menu,color:COLOR_BLACK,),
                //       ),
                //       BorderBox(
                //         height: 50,
                //         width:50,
                //         child: Icon(Icons.settings,color:COLOR_BLACK,),
                //       ),
                //     ],
                //   ),
                // ),
                addVerticalSpace(20),
                Padding(
                  padding: sidePadding,
                  child: Text(
                    "City",
                     style: themeData.textTheme.bodyText2,),
                ),
                 addVerticalSpace(10),
                Padding(
                  padding: sidePadding,
                  child: Text(
                    "Nairobi", 
                    style: TextStyle(
                    fontSize:22,
                    fontWeight: FontWeight.w700,
                    color: COLOR_BLACK,
                  ),
                  ),
                ), 
                Padding(
                  padding: sidePadding,
                  child: Divider(
                    height: 25,
                    color: COLOR_GREY,
                  ),
                ),
                //addVerticalSpace(10),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Obx(
                      ()=> Wrap(
                        spacing: 20,
                        children: List<Widget>.generate(7,(int index){
                          return ChoiceChip(
                            label: Container(
                              width: 90,
                              height: 35,
                              child: Center(
                                child: Text(
                                  _chipLabel[index], style: TextStyle(fontSize: 20),),
                              )),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            selected: chipController.selectedChip == index,
                            elevation: 0.5,
                            selectedColor: Colors.blueGrey[150],
                            onSelected: (bool selected){
                              chipController.selectedChip = selected ? index : null;
                              databaseService.onInit();
                              databaseService.getlistData(ListingDets.values[chipController.selectedChip]);
                            },
                          );
                        }),
                      ),
                    )
                  ),
                addHorizontalSpace(10),
                Obx(() =>Expanded(
                  child: Padding(
                    padding: sidePadding,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: databaseService.listingList.length,
                      itemBuilder: (BuildContext context, int index){
                        //final bool alreadySaved = 
                        return GestureDetector(
                          onTap: () => goToDetPage(context),
                          child: Card(
                            margin: const EdgeInsets.fromLTRB(3, 8, 3, 8),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image.network("${databaseService.listingList[index].url}"),
                                        ),
                                        Positioned(
                                          top: 15,
                                          right: 10,    
                                          child: Container(
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                            color: COLOR_WHITE,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: COLOR_GREY.withAlpha(40), width: 2)),
                                          child: Center(
                                            child: IconButton(
                                              icon: Icon(
                                                 Icons.favorite_border_rounded
                                              ),
                                              onPressed: () async {
                                               final CollectionReference userFavorites = FirebaseFirestore.instance.collection('User Favorites');
                                               await userFavorites.doc(_uid).collection('User Favorites').add({
                                                  "Listing Name":"${databaseService.listingList[index].name}", 
                                                  "Listing Address":"${databaseService.listingList[index].address}",
                                                  "Amount":"${databaseService.listingList[index].amount}", 
                                                  "BedroomNo":"${databaseService.listingList[index].bedrooms}", 
                                                  "BathroomNo": "${databaseService.listingList[index].bathrooms}", 
                                                  "Area":"${databaseService.listingList[index].area}",
                                                  "imageUrl": "${databaseService.listingList[index].url}",
                                                  "Garage": "${databaseService.listingList[index].garage}",
                                                  "Description": "${databaseService.listingList[index].description}",
                                                  "listType":"${databaseService.listingList[index].listType}",
                                                  "ListingId" : "$_uid"
                                                }); 
                                              }, 
                                            )
                                          )
                                          )
                                        )
                                      ],
                                    ),
                                    addVerticalSpace(10),
                                    Row(children: [
                                      Text(
                                        "${databaseService.listingList[index].name}", 
                                        style: GoogleFonts.lato(
                                          fontSize: 24),
                                        ),
                                        addHorizontalSpace(70),
                                        Text(
                                          "${databaseService.listingList[index].address}",
                                          style: GoogleFonts.lato(textStyle: themeData.textTheme.bodyText2),
                                        ),
                                      ]
                                    ),
                                    addVerticalSpace(5),
                                    Row(
                                      children: [
                                        Text('Asking:', 
                                          style: GoogleFonts.lato(
                                            fontSize:20,
                                            fontWeight: FontWeight.w600,
                                            color: COLOR_BLACK,
                                          ),),
                                        addHorizontalSpace(10),
                                        Row(
                                          children: [
                                            Text(
                                              //"${formatCurrency(listings.amount)}",
                                              "${"${databaseService.listingList[index].amount}"} ksh",
                                              style:GoogleFonts.lato(
                                                fontSize:22,
                                                fontWeight: FontWeight.w700,
                                                color: COLOR_BLACK,
                                              ),
                                            ),
                                            addHorizontalSpace(12),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 30),
                                              child: Container(
                                                height: 30,
                                                width: 70,
                                                margin: EdgeInsets.only(right: 10),
                                                decoration: BoxDecoration(
                                                  color: COLOR_WHITE,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: COLOR_DARK_BLUE, width: 3)),
                                                padding: EdgeInsets.all(4.0),
                                                child: Center(child: Text("${databaseService.listingList[index].listType}")),
                                              ),
                                            )
                                          ],
                                        ), 
                                      ],
                                    ),
                                    addVerticalSpace(5),
                                    Text(
                                      "${"${databaseService.listingList[index].bedrooms}"} bedrooms / ${"${databaseService.listingList[index].bathrooms}"} bathrooms / ${"${databaseService.listingList[index].area}"} sqft",
                                      style: GoogleFonts.lato(textStyle:themeData.textTheme.headline6),
                                    ),
                                    addVerticalSpace(5)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ),
                ),
               ),

              ],
             ),
            ],
           ),
          ),
        ),
      ),
    );
  }

  void goToDetPage(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DetailsPage()));
}

void goToList(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => NewListing()));

class ChoiceOption extends StatelessWidget {
  const ChoiceOption({ Key? key, required this.text }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: COLOR_GREY.withAlpha(25)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.only(left: 25),
      child: Text(text, style: themeData.textTheme.headline6),

    );
  }
}



class HomeTile extends StatelessWidget {
  const HomeTile({ Key? key, required this.content, required this.icon }) : super(key: key);
  final String content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}