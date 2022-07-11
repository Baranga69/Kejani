import 'package:another_nav_bar/models/listings.dart';
import 'package:another_nav_bar/models/details.dart';
import 'package:another_nav_bar/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:another_nav_bar/utilities/chip_controller.dart';

class DatabaseService extends GetxController{

  final String uid;
  DatabaseService({ required this.uid});

  //collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Kejani Users');
  Future updateUserData(String email, String username, String phoneNumber, String residence, String imgUrl ) async{
    return await usersCollection.doc(uid).set({
      "Email":"$email", 
      "Username":"$username", 
      "PhoneNumber":"$phoneNumber", 
      "Residence": "$residence",
      "ImgUrl": "$imgUrl"});
     
  }

  //uploading a new listing 
  final CollectionReference listingsCollection = FirebaseFirestore.instance.collection('Kejani Listings');
  Future updateListingData(String name, String address, String amount, String bedrooms, String bathrooms, String area, String garage, String description) async{
    return await listingsCollection.doc(uid).set({
       "Listing Name":"$name",
       "Listing Address":"$address", 
       "Amount" : "$amount",
       "BedroomNo":"$bedrooms", 
       "BathroomNo": "$bathrooms", 
       "Area":"$area",
       "Garage" : "$garage",
       "Description":"$description"
    });
  }

  var userDets = <UserData>[].obs;

  //userObject lists from snapshot
  List<Details> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return Details(
        email: doc.get('email'),
        userType: doc.get('UserType'),
        username: doc.get('username'),
        phoneNumber: doc.get('phoneNumber'),
        residence: doc.get('residence'),
        imgUrl: doc.get('ImgUrl'), 
        lastMessageTime: doc.get('lastMessageTime')
      );
    }).toList();
  }

  var listingList = <ListingData>[].obs;
  var listingLister = <ListingData>[];
  //dependecy injection with GetX
  ChipController _chipController = Get.put(ChipController());

  @override
  void onInit(){
    //binding to stream so that we can listen to real time changes 
    listingList.bindStream(getlistData(ListingDets.values[_chipController.selectedChip]));
    super.onInit();
  }

  //Listing details from snapshot
  List<ListingData> _listingListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return ListingData(
        listingId: doc.get('ListingId'),
        name:  doc.get('Listing Name'), 
        address: doc.get('Listing Address'), 
        amount:  doc.get('Amount'),
        bedrooms: doc.get('BedroomNo'), 
        bathrooms: doc.get('BathroomNo'), 
        area: doc.get('Area'),
        url:  doc.get('imageUrl'),
        garage: doc.get('Garage'),
        listType: doc.get('listingType'),
        description: doc.get('Description'),
      );
    }).toList();
  }

  //another listing stream
  Stream<List<ListingData>> get listData{
  return listingsCollection.snapshots()
  .map(_listingListFromSnapshot);
 }

   Stream<List<Details>> get usersData{
  return usersCollection.snapshots()
  .map(_userListFromSnapshot);
 }
  //get listing stream
 Stream<List<ListingData>> getlistData(ListingDets dets){
   //using the enum class Listingdets in the switch case
   switch (dets){
     case ListingDets.ALL:
     return listingsCollection.snapshots()
     .map(_listingListFromSnapshot);

     case ListingDets.AREA:
     return listingsCollection.where('Area', isLessThanOrEqualTo: '2500').snapshots()
     .map(_listingListFromSnapshot);

     case ListingDets.BEDROOMS:
     return listingsCollection.where('BedroomNo', isGreaterThanOrEqualTo: '3').snapshots()
     .map(_listingListFromSnapshot);

     case ListingDets.PRICE:
     return listingsCollection.where('Amount', isLessThan: '100,000').snapshots()
     .map(_listingListFromSnapshot);

     case ListingDets.PRICE2:
     return listingsCollection.where('Amount', isGreaterThan: '1,000,000').snapshots()
     .map(_listingListFromSnapshot);

     case ListingDets.TYPE1:
     return listingsCollection.where('listingType', isEqualTo: 'For rent').snapshots()
     .map(_listingListFromSnapshot);

     case ListingDets.TYPE2:
     return listingsCollection.where('listingType',isEqualTo: 'For sale').snapshots()
     .map(_listingListFromSnapshot);
   }
 }

  //User details from snapshot
  List<UserData> _userInfoFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return UserData(
        username: doc.get('username'),
        urlAvatar: doc.get('ImgUrl'),
        uid: doc.get('uid'),
        lastMessageTime: doc.get('lastMessageTime')
      );
    }).toList();
  }

 //final CollectionReference chatsCollection = FirebaseFirestore.instance.collection('chat_logs/$userId/messages');

  // //Message data from snapshot
  // List<Message> _messageFromSnapshot(QuerySnapshot snapshot){
  //   return snapshot.docs.map((doc) {
  //     return Message(
  //       userId: doc.get('userId'), 
  //       avatarUrl: doc.get('avatarUrl'), 
  //       username: doc.get('username'), 
  //       message: doc.get('message'), 
  //       createdAt: doc.get('createdat'));
  //   }).toList();
  // }

  //get message stream
  // Stream<List<Message>> getusermessages(String userId){
  //   return chatsCollection.snapshots()
  //   .map(_messageFromSnapshot);
  // }

  //get data stream
 Stream<List<Details>> get uData{
  return usersCollection.snapshots()
  .map(_userListFromSnapshot);
 }

 //get users stream
 Stream<List<UserData>> get infoData{
  return usersCollection.snapshots()
  .map(_userInfoFromSnapshot);
 }


}

class DatabaseService2{
  final String uid;
  DatabaseService2({ required this.uid});

  //uploading a new listing 
  final CollectionReference listingsCollection = FirebaseFirestore.instance.collection('Kejani Listings');
  Future updateListingData(String name, String address, String amount, String bedrooms, String bathrooms, String area, String garage, String description) async{
    return await listingsCollection.doc(uid).set({
       "Listing Name":"$name",
       "Listing Address":"$address", 
       "Amount" : "$amount",
       "BedroomNo":"$bedrooms", 
       "BathroomNo": "$bathrooms", 
       "Area":"$area",
       "Garage" : "$garage",
       "Description":"$description"
    });
  }

   //Listing details from snapshot
  List<ListingData> _listingListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return ListingData(
        listingId: doc.get('ListingId'),
        name:  doc.get('Listing Name'), 
        address: doc.get('Listing Address'), 
        amount:  doc.get('Amount'),
        bedrooms: doc.get('BedroomNo'), 
        bathrooms: doc.get('BathroomNo'), 
        area: doc.get('Area'),
        url:  doc.get('imageUrl'),
        garage: doc.get('Garage'),
        listType: doc.get('listingType'),
        description: doc.get('Description'),
      );
    }).toList();
  }

   //another listing stream
  Stream<List<ListingData>> get listData{
  return listingsCollection.snapshots()
  .map(_listingListFromSnapshot);
 }
}
