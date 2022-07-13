import 'package:another_nav_bar/models/listings.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:another_nav_bar/utilities/loading.dart';
import 'package:another_nav_bar/utilities/widget_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({ Key? key }) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  // @override
  // void initState(){
  //   super.initState();
  //   _favorites = [];
  // }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final _uid = user!.uid;  
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: COLOR_DARK_BLUE,
          title: Center(child: Text('Favorites')),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Favorites').doc(_uid).collection('myFavorites').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(!snapshot.hasData){
              return Center(child:Text('Like something....'));
            }
            if(snapshot.hasData){
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                DocumentSnapshot currentUser = snapshot.data!.docs[index];
                String name = currentUser.get('Listing Name');
                String address = currentUser.get('Listing Address');
                String amount = currentUser.get('Amount');
                String bedrooms = currentUser.get('BedroomNo');
                String bathrooms = currentUser.get('BathroomNo');
                String area = currentUser.get('Area');
                String imageUrl = currentUser.get('imageUrl');
                String garage = currentUser.get('Garage');
                String description = currentUser.get('Description');
                String listType = currentUser.get('listType');
                String listingId = currentUser.get('ListingId');
                ListingData listingData = new ListingData(
                  listingId: listingId, 
                  name: name, 
                  listType: listType, 
                  address: address, 
                  amount: amount, 
                  bedrooms: bedrooms, 
                  bathrooms: bathrooms, 
                  area: area, 
                  url: imageUrl, 
                  garage: garage, 
                  description: description);
                return RealEstateItem(listingData: listingData);
              },
             );
            } else {
                return Center(child: Loading(),
                );
              }
          },
        ),
      ),
    );
  }
}

class RealEstateItem extends StatelessWidget {

  final ListingData listingData;
  //Icon favIcon = Icon(FontAwesomeIcons.heart);
  
  const RealEstateItem({ Key? key, required this.listingData }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final _uid = user!.uid;
    bool _isFavorited = true;

    if(_auth.currentUser== null){
       Icon(
        FontAwesomeIcons.solidHeart,
        color: Colors.red,
      );
    } else {
       Icon(
        FontAwesomeIcons.heart,
      );
    }

    return GestureDetector(
      //onTap: () => goToDetPage(context),
      child: Card(
        margin: const EdgeInsets.fromLTRB(3, 8, 3, 8),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(image: NetworkImage(listingData.url),)
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
                        alignment: Alignment.center,
                        icon: (_isFavorited
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border, color: Colors.black54)),
                          color: Colors.red[500],
                          onPressed: () async {
                              deleteData(_uid);
                          }, 
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(10),
              Row(children: [
                Text(
                  listingData.name, 
                  style: GoogleFonts.lato(
                    fontSize: 24),
                  ),
                  addHorizontalSpace(70),
                  Text(
                    listingData.address,
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
                  addHorizontalSpace(20),
                  Text(
                    //"${formatCurrency(listings.amount)}",
                    "${listingData.amount} ksh",
                    style:GoogleFonts.lato(
                      fontSize:22,
                      fontWeight: FontWeight.w700,
                      color: COLOR_BLACK,
                    ),
                  ), 
                ],
              ),
              addVerticalSpace(5),
              Text(
                "${listingData.bedrooms} bedrooms / ${listingData.bathrooms} bathrooms / ${listingData.area} sqft",
                style: GoogleFonts.lato(textStyle:themeData.textTheme.headline6),
              ),
              addVerticalSpace(5)
            ],
          ),
        ),
      ),
    );
  }
  Future deleteData(String id) async{
    try {
      await FirebaseFirestore.instance
      .collection("Favorites")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("myFavorites")
      .doc(id)
      .delete();
    }catch (e){
      return false;
    }
  }

  
}