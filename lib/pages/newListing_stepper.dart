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

class NewListing extends StatefulWidget {
  const NewListing({ Key? key }) : super(key: key);

  @override
  _NewListingState createState() => _NewListingState();
}

class _NewListingState extends State<NewListing> {
  int _currentStep = 0;

  _stepState(int step){
    if(_currentStep > step){
      return StepState.complete;
    } else {
      return StepState.editing;
    }
  }
    _steps() => [
    Step(
      title: Text('Basic Information'),
      content: _InfoForm(),
      state: _stepState(0),
      isActive: _currentStep == 0,
    ),
    Step(
      title: Text('Listing Specifications'),
      content: _SpecForm(),
      state: _stepState(1),
      isActive: _currentStep == 1,
    ),
    Step(
      title: Text('Media Information'),
      content: _MediaForm(),
      state: _stepState(2),
      isActive: _currentStep == 2,
    ),
  ];
  

void goToHome(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BackButton(onPressed: () => goToHome(context)),
        backgroundColor: COLOR_BLACK,
        elevation: 0,
      ),
      body: Stepper(
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          setState(() {
            if (_currentStep < _steps().length - 1){
              _currentStep += 1;
            } else {
              _currentStep = 0;
            }
          });
        },
        onStepCancel:() {
          setState(() {
            if (_currentStep > 0){
              _currentStep -= 1;
            } else {
              _currentStep = 0;
            }
          });
        },
        currentStep: _currentStep,
        steps: _steps()),
    );
  }

  
}

class _InfoForm extends StatefulWidget {
  const _InfoForm({ Key? key }) : super(key: key);

  @override
  State<_InfoForm> createState() => _InfoFormState();
}

class _InfoFormState extends State<_InfoForm> {
  String? name;
  String? address;
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
    return Column(
      children: [
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
      ],
    );
  }
}

class _SpecForm extends StatefulWidget {
  const _SpecForm({ Key? key }) : super(key: key);

  @override
  State<_SpecForm> createState() => _SpecFormState();
}

class _SpecFormState extends State<_SpecForm> {
  String? bedrooms;
  String? bathrooms;
  String? area;
  String? amount;
  String? garage;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}

class _MediaForm extends StatefulWidget {
  const _MediaForm({ Key? key }) : super(key: key);

  @override
  State<_MediaForm> createState() => _MediaFormState();
}

class _MediaFormState extends State<_MediaForm> {

  File? _pickedImage;
  UploadTask? task;
  File? file;
  String? url;
  String? description;
  @override
  Widget build(BuildContext context) {
    final fileName = _pickedImage!= null? basename(_pickedImage!.path): 'No File Selected';
    return Column(
      children: [
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
        ),onTap: () {} ),
      SizedBox(height: 20),
      Text(fileName, style: TextStyle(fontSize: 16, fontWeight:FontWeight.bold)),
      SizedBox(height: 20),
      MaterialButton(
        elevation: 2,
        minWidth: double.infinity,
        height: 50,
        onPressed: () {},
        color: Colors.green,
        child: Text('Upload',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        textColor: Colors.white,
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
     ],
    );
  }
}

