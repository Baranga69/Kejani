//import 'package:another_nav_bar/custom/BorderBox.dart';
import 'package:another_nav_bar/custom/BorderBox.dart';
import 'package:another_nav_bar/models/listings.dart';
import 'package:another_nav_bar/pages/details_page.dart';
import 'package:another_nav_bar/pages/newListing_stepper.dart';
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
    final double padding = 5;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return SafeArea(
      child: Scaffold(
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
                addVerticalSpace(5),
                // Padding(
                //   padding: sidePadding,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       BorderBox(
                //         height: 45,
                //         width:45,
                //         child: Icon(Icons.menu,color:COLOR_BLACK,),
                //       ),
                //       BorderBox(
                //         height: 45,
                //         width:45,
                //         child: Icon(Icons.settings,color:COLOR_BLACK,),
                //       ),
                //     ],
                //   ),
                // ),
                // addVerticalSpace(5),
                Padding(
                  padding: sidePadding,
                  child: Row(
                    children: [
                      Icon(Icons.location_pin),
                      addHorizontalSpace(5),
                      Text(
                      "Nairobi", 
                      style: TextStyle(
                      fontSize:22,
                      fontWeight: FontWeight.w700,
                      color: COLOR_BLACK,
                      ),
                      ),
                    ],
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Obx(
                        ()=> Wrap(
                          spacing: 10,
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
                         Color color = Colors.black;
                          Widget infoSection = Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              VerticalDivider( color: COLOR_BLACK, width: 10.0),
                              _buildInfoRow(color, Icons.bed_outlined, "${"${databaseService.listingList[index].bedrooms}"}"),
                              VerticalDivider( color: COLOR_BLACK, width: 10.0),
                              _buildInfoRow(color, Icons.bathtub_outlined, "${"${databaseService.listingList[index].bathrooms}"}"),
                              VerticalDivider( color: COLOR_BLACK, width: 10.0),
                              _buildInfoRow(color, Icons.architecture, "${"${databaseService.listingList[index].area}"}"),
                              VerticalDivider( color: COLOR_BLACK, width: 10.0),
                            ],
                          );
                        return GestureDetector(
                          onTap: () => goToDetPage(context),
                          child: Card(
                            margin: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Image.network("${databaseService.listingList[index].url}", height: 80, width: 100,alignment: Alignment.topLeft),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5),
                                            child: Row(
                                              children: [
                                              Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${databaseService.listingList[index].name}", 
                                                        style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          fontStyle: FontStyle.italic),
                                                        ),
                                                      
                                                        Text(
                                                          "${databaseService.listingList[index].address}",
                                                          style: GoogleFonts.lato(textStyle: themeData.textTheme.bodyText2),
                                                        ),
                                                    ],
                                                  ),
                                                  addVerticalSpace(2),
                                                  Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Text('Asking:', 
                                                              style: GoogleFonts.lato(
                                                                fontSize:12,
                                                                fontWeight: FontWeight.w600,
                                                                color: COLOR_BLACK,
                                                              ),
                                                            ),
                                                            addHorizontalSpace(4),
                                                            Text(
                                                              //"${formatCurrency(listings.amount)}",
                                                              "${"${databaseService.listingList[index].amount}"} ksh",
                                                              style:GoogleFonts.lato(
                                                                fontSize:16,
                                                                fontWeight: FontWeight.w700,
                                                                color: COLOR_BLACK,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        addHorizontalSpace(10),
                                                        Container(
                                                          height: 30,
                                                          width: 70,
                                                          margin: EdgeInsets.only(left: 10),
                                                          decoration: BoxDecoration(
                                                            color: COLOR_WHITE,
                                                            borderRadius: BorderRadius.circular(8),
                                                            border: Border.all(color: COLOR_DARK_BLUE, width: 3)),
                                                          padding: EdgeInsets.all(4.0),
                                                          child: Center(child: Text("${databaseService.listingList[index].listType}")),
                                                        ), 
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ]
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 5,    
                                        child: FavoriteWidget(),
                                      )
                                    ],
                                  ),
                                ),
                                 Divider(
                                  color: COLOR_BLACK,
                                  height: 5.0,
                                  indent: 25,
                                  endIndent: 25,
                                  thickness: 1,
                                ),
                                infoSection,
                                addVerticalSpace(5)
                              ],
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

  Row _buildInfoRow(Color color, IconData icon, String label){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: COLOR_GREY, size: 25,),
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        )
      ],
    );
  }
  
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

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
     
       child: IconButton(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.center,
          icon: (_isFavorited
              ? const Icon(Icons.star)
              : const Icon(Icons.star_border, color: Colors.black54)),
          color: Colors.red[500],
          iconSize: 25,
          onPressed: _toggleFavorite,
        ),
      );
  }

  void _toggleFavorite(){

    setState((){
      if(_isFavorited){
        _isFavorited = false;
        
      } else {
        _isFavorited = true;
        // final FirebaseAuth _auth = FirebaseAuth.instance;
        // final User? userLog = _auth.currentUser;
        // final _uid = userLog!.uid;
        // final DatabaseService databaseService = Get.put(DatabaseService(uid: ''));
        // final CollectionReference userFavorites = FirebaseFirestore.instance.collection('Favorites');
        // await userFavorites.doc(_uid).collection('myFavorites').add({
        //   "Listing Name":"${databaseService.listingList[index].name}", 
        //   "Listing Address":"${databaseService.listingList[index].address}",
        //   "Amount":"${databaseService.listingList[index].amount}", 
        //   "BedroomNo":"${databaseService.listingList[index].bedrooms}", 
        //   "BathroomNo": "${databaseService.listingList[index].bathrooms}", 
        //   "Area":"${databaseService.listingList[index].area}",
        //   "imageUrl": "${databaseService.listingList[index].url}",
        //   "Garage": "${databaseService.listingList[index].garage}",
        //   "Description": "${databaseService.listingList[index].description}",
        //   "listType":"${databaseService.listingList[index].listType}",
        //   "ListingId" : "$_uid"
        // }); 
      }
    });
    
  }
}