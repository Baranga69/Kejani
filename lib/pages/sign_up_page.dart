import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:another_nav_bar/pages/home_screen.dart';
import 'package:another_nav_bar/pages/login_page.dart';
import 'package:another_nav_bar/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:another_nav_bar/utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
//import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final AuthService _auth = AuthService();
  final FirebaseAuth _auther = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String? email;

  String? password;

  String? username;

  String? phoneNumber;

  String? residence;

  String error = '';
  
  File? _pickedImage;

  String? imgUrl;

  String? name;

  String? uid;

  String selectedValue = 'User';

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text('User'), value: 'User'),
    DropdownMenuItem(child: Text('Agent'), value: 'Agent'),
  ];
  return menuItems;
 }


  @override
  Widget build(BuildContext context) {
    final fileName = _pickedImage!= null? basename(_pickedImage!.path): 'No File Selected';
    return loading ? Loading() : Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: COLOR_WHITE,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Register for Kejani to continue',
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.openSans(color: COLOR_BLACK, fontSize: 28),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Create your account to gain access to a world of possibility and beautiful spaces',
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.openSans(color: COLOR_BLACK, fontSize: 14),
                    ),
                    SizedBox( height: 20),
                    _pickedImage !=null? Image.file(_pickedImage!, width: 160, height: 160,) : GestureDetector(
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      height: 180,
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                      color: COLOR_WHITE, 
                      border: Border.all(color: COLOR_DARK_BLUE),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: TextFormField(
                      validator: (val) => val!.isEmpty? 'Enter a username':null,
                      style: TextStyle(color: COLOR_BLACK),
                      decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Username",
                      labelStyle: TextStyle(color: COLOR_BLACK),
                      icon: Icon(Icons.person, color: COLOR_BLACK),
                      border: InputBorder.none),
                      onChanged: (val){
                        setState(() => username = val);
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
                      style: TextStyle(color: COLOR_BLACK),
                      validator: (val) => val!.isEmpty? 'Enter an email':null,
                      decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Email",
                      labelStyle: TextStyle(color: COLOR_BLACK),
                      icon: Icon(Icons.email, color: COLOR_BLACK),
                      border: InputBorder.none),
                      onChanged: (val){
                        setState(() => email = val);
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
                      style: TextStyle(color: COLOR_BLACK),
                      validator: (val) => val!.isEmpty? 'Enter a phone number':null,
                      decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Phone Number",
                      labelStyle: TextStyle(color: COLOR_BLACK),
                      icon: Icon(Icons.phone, color: COLOR_BLACK),
                      border: InputBorder.none),
                      onChanged: (val){
                        setState(() => phoneNumber = val);
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
                      style: TextStyle(color: COLOR_BLACK),
                      validator: (val) => val!.isEmpty? 'Enter a city of residence':null,
                      decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "City of residence",
                      labelStyle: TextStyle(color: COLOR_BLACK),
                      icon: Icon(Icons.home,
                      color: COLOR_BLACK),
                      border: InputBorder.none),
                      onChanged: (val){
                        setState(() => residence = val);
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
                      style: TextStyle(color: COLOR_BLACK),
                      validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long':null,
                      decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Password",
                      labelStyle: TextStyle(color: COLOR_BLACK),
                      icon: Icon(Icons.lock, color: COLOR_BLACK),
                      border: InputBorder.none),
                      obscureText: true,
                      onChanged: (val){
                        setState(() => password = val);
                      },
                     ),
                    ),
                    SizedBox(height: 30),
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
                     MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: 50,
                      onPressed: () => [_signUpUser(), goToHome(context)],
                      color: Colors.amber,
                      child: Text('Register',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 10),
                    TextButton(onPressed: () => goToPage(context), child: Text('Already registered? Log In here',
                      style: TextStyle(color:COLOR_BLACK, fontSize: 16))),
                    SizedBox(height: 10),
                    Text(error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        )
      );
  }
  _signUpUser() async {
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
       if(_pickedImage == null){
          setState(() {
          error = "Failed to upload";
          loading = false;
        });
        } else{
          setState(() {
          loading = true;
        });
        await _auth.regWithEmailAndPassword(email!, password!);
        final ref = FirebaseStorage.instance
            .ref()
            .child('images')
            .child(username! + '.jpg');
        await ref.putFile(_pickedImage!);
        imgUrl = await ref.getDownloadURL();
        final User? user = _auther.currentUser;
        final _uid = user!.uid;
        await FirebaseFirestore.instance.collection('Kejani Users').doc(_uid).set({
          "Email":"$email", 
          "PhoneNumber":"$phoneNumber",
          "Username":"$username", 
          "Residence":"$residence", 
          "ImgUrl": "$imgUrl",
          "uid":"$_uid",
          "UserType":"$selectedValue",
          "lastMessageTime": DateTime.parse("1969-07-20 20:18:04Z")
        });
      }
    //  } catch (e) {
    //    setState(() {
    //      error = "Failed to upload data";
    //      loading = false;
    //    });
    //   } finally {
    //     setState(() {
    //       loading = false;
    //     });
        
    //   }
    }
  }
void goToPage(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
void goToHome(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }
  
}


