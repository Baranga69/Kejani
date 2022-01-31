import 'dart:io';
import 'package:another_nav_bar/pages/home_screen.dart';
import 'package:another_nav_bar/utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
class NewHouse extends StatefulWidget {
  const NewHouse({ Key? key }) : super(key: key);

  @override
  _NewHouseState createState() => _NewHouseState();
}

class _NewHouseState extends State<NewHouse> {
  
  UploadTask? task;
  File? file;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  String? name;
  String? address;
  String? bedrooms;
  String? bathrooms;
  String? area;
  String? amount;
  String error = '';
  File? _pickedImage;
  String? url;
  String? garage;
  String? description;

  String selectedValue = 'For sale';

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text('For rent'), value: 'For rent'),
    DropdownMenuItem(child: Text('For sale'), value: 'For sale'),
  ];
  return menuItems;
  }

   @override
  Widget build(BuildContext context) {
    final fileName = _pickedImage!= null? basename(_pickedImage!.path): 'No File Selected';
    
    return loading ? Loading() : Scaffold(
        appBar: AppBar(
        title: BackButton(onPressed: () => goToHome(context)),
        backgroundColor: COLOR_BLACK,
        elevation: 0,
        ),
        backgroundColor: COLOR_WHITE,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Create a new listing',
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.openSans(color: COLOR_BLACK, fontSize: 28),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Input the details of your listing below',
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.openSans(color: COLOR_BLACK, fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_BLACK, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: InputBorder.none,
                        ),
                        dropdownColor: Colors.white,
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        items: dropdownItems),
                 SizedBox(height: 20),
                 Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                  color: COLOR_WHITE, 
                  border: Border.all(color: COLOR_DARK_BLUE),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(
                  validator: (val) => val!.isEmpty? 'Enter an property name':null,
                  style: TextStyle(color: COLOR_BLACK),
                  decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  labelText: "Listing name",
                  labelStyle: TextStyle(color: COLOR_BLACK),
                  border: InputBorder.none),
                  onChanged: (val){
                    setState(() => name = val);
                  },
                 ),
                ),
                  SizedBox(height: 20),
                 Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                  color: COLOR_WHITE, 
                  border: Border.all(color: COLOR_DARK_BLUE),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(
                  validator: (val) => val!.isEmpty? 'Enter an property address':null,
                  style: TextStyle(color: COLOR_BLACK),
                  decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  labelText: "Property address",
                  labelStyle: TextStyle(color: COLOR_BLACK),
                  border: InputBorder.none),
                  onChanged: (val){
                    setState(() => address = val);
                  },
                 ),
                ),
                 SizedBox(height: 20),
                  Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                  color: COLOR_WHITE, 
                  border: Border.all(color: COLOR_DARK_BLUE),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty? 'Enter an amount':null,
                  style: TextStyle(color: COLOR_BLACK),
                  decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  labelText: "Asking amount",
                  labelStyle: TextStyle(color: COLOR_BLACK),
                  border: InputBorder.none),
                  onChanged: (val){
                    setState(() => amount = val);
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                 ),
                ),
                SizedBox(height: 20),
                 Container(
                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                 decoration: BoxDecoration(
                 color: COLOR_WHITE, 
                 border: Border.all(color: COLOR_DARK_BLUE),
                 borderRadius: BorderRadius.all(Radius.circular(15))),
                 child: TextFormField(
                 keyboardType: TextInputType.number,
                 validator: (val) => val!.isEmpty? 'Enter the number of bedrooms':null,
                 style: TextStyle(color: COLOR_BLACK),
                 decoration: InputDecoration(
                 contentPadding: EdgeInsets.symmetric(horizontal: 10),
                 labelText: "No. of Bedrooms",
                 labelStyle: TextStyle(color: COLOR_BLACK),
                 border: InputBorder.none),
                 onChanged: (val){
                   setState(() => bedrooms = val);
                 },
                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                   ),
                  ),
                SizedBox(height: 20),
               Container(
               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
               decoration: BoxDecoration(
               color: COLOR_WHITE, 
               border: Border.all(color: COLOR_DARK_BLUE),
               borderRadius: BorderRadius.all(Radius.circular(15))),
               child: TextFormField(
               keyboardType: TextInputType.number,
               validator: (val) => val!.isEmpty? 'Enter the number of bathrooms':null,
               style: TextStyle(color: COLOR_BLACK),
               decoration: InputDecoration(
               contentPadding: EdgeInsets.symmetric(horizontal: 10),
               labelText: 'No. of Bathrooms',
               labelStyle: TextStyle(color: COLOR_BLACK),
               border: InputBorder.none),
               onChanged: (val){
                 setState(() => bathrooms = val);
               },
               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                   ),
                  ),
                SizedBox(height: 20),
                Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                color: COLOR_WHITE, 
                border: Border.all(color: COLOR_DARK_BLUE),
                borderRadius: BorderRadius.all(Radius.circular(15))),
                child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty? 'Enter the area':null,
                style: TextStyle(color: COLOR_BLACK),
                decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                labelText: "Area in square ft.",
                labelStyle: TextStyle(color: COLOR_BLACK),
                border: InputBorder.none),
                onChanged: (val){
                  setState(() => area = val);
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                   ),
                  ),
                SizedBox(height: 20),
                 Container(
                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                 decoration: BoxDecoration(
                 color: COLOR_WHITE, 
                 border: Border.all(color: COLOR_DARK_BLUE),
                 borderRadius: BorderRadius.all(Radius.circular(15))),
                 child: TextFormField(
                 keyboardType: TextInputType.number,
                 validator: (val) => val!.isEmpty? 'Enter the number of garages':null,
                 style: TextStyle(color: COLOR_BLACK),
                 decoration: InputDecoration(
                 contentPadding: EdgeInsets.symmetric(horizontal: 10),
                 labelText: "Number of garages",
                 labelStyle: TextStyle(color: COLOR_BLACK),
                 border: InputBorder.none),
                 onChanged: (val){
                   setState(() => garage = val);
                 },
                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                   ),
                  ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                  color: COLOR_WHITE, 
                  border: Border.all(color: COLOR_DARK_BLUE),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(
                  validator: (val) => val!.isEmpty? 'Enter a property description':null,
                  style: TextStyle(color: COLOR_BLACK),
                  decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  labelText: "Property description",
                  labelStyle: TextStyle(color: COLOR_BLACK),
                  border: InputBorder.none),
                  onChanged: (val){
                    setState(() => description = val);
                  },
                 ),
                ),
                 SizedBox(height: 20),
                _pickedImage !=null? Image.file(_pickedImage!, width: 160, height: 160,) : 
                GestureDetector(
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      height: 160,
                      width: 350,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                      child: Icon(
                        Icons.add_a_photo_rounded, size: 100,),
                        ),
                  ),onTap: () => _pickImageGallery(),),
                SizedBox(height: 20),
                Text(fileName, style: TextStyle(fontSize: 16, fontWeight:FontWeight.bold)),
                SizedBox(height: 20),
                MaterialButton(
                  elevation: 2,
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: () => _sendToServer(),
                  color: Colors.green,
                  child: Text('Upload',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
                SizedBox(height: 20),
                task !=null ? buildUploadStatus(task!) : Container(),
              ],
            ),
            ),
              ),
        )
    );
  }

  void _sendToServer() async{
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
      try{
        if(_pickedImage == null){
          setState(() {
          error = "Failed to upload";
          loading = false;
        });
        } else {
          setState(() {
            loading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('images')
              .child(name! + '.jpg');
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();
          final User? user = _auth.currentUser;
          final _uid = user!.uid;
          await FirebaseFirestore.instance.collection('Kejani Listings').doc(_uid).set({
            "Listing Name":"$name", 
            "Listing Address":"$address",
            "Amount":"$amount", 
            "BedroomNo":"$bedrooms", 
            "BathroomNo": "$bathrooms", 
            "Area":"$area",
            "imageUrl": "$url",
            "Garage": "$garage",
            "Description": "$description",
            "UserType":"$selectedValue",
            "ListingId" : "$_uid"
          });
        }
      } catch (e) {
       setState(() {
         error = "Failed to upload data";
         loading = false;
       });
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }
  void goToHome(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) => 
  ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(56),
      primary: Colors.orange,
      onPrimary: Colors.black,
      textStyle: TextStyle(fontSize: 20, color: Colors.black),
    ),
    child: Row(
      children: [
        Icon(icon,size: 28),
        const SizedBox(width: 16),
      ],
    ),
    onPressed: onClicked,
  );

  Future selectFiles() async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result== null) return;
    final path =result.files.single.path;
    setState(() {
      file = File(path!);
    });
  }
  
  Widget buildUploadStatus(UploadTask uploadTask) => StreamBuilder<TaskSnapshot>(
    stream: task!.snapshotEvents,
    builder: (context, snapshot){
      if(snapshot.hasData){
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred/snap.totalBytes;
        final percentage = (progress*100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );
}

