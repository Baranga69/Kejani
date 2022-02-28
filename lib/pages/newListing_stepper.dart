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

List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(),GlobalKey<FormState>(),GlobalKey<FormState>()];

class NewListing extends StatefulWidget {
  const NewListing({ Key? key }) : super(key: key);

  @override
  _NewListingState createState() => _NewListingState();
}

class _NewListingState extends State<NewListing> {
  

  void goToHome(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BackButton(onPressed: () => goToHome(context)),
        backgroundColor: COLOR_BLACK,
        elevation: 0,
      ),
      body: StepperBody(),
    );
  } 
}


  

class StepperBody extends StatefulWidget {
  const StepperBody({ Key? key }) : super(key: key);

  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currentStep = 0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
  String? propType;
  String selectedValue = 'For sale';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text('For rent'), value: 'For rent'),
    DropdownMenuItem(child: Text('For sale'), value: 'For sale'),
  ];
  return menuItems;
  }

  void _pickImageGallery() async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  final pickedImageFile = File(pickedImage!.path);
  setState(() {
    _pickedImage = pickedImageFile;
  });
}
  

  // @override
  // void initState(){
  //   super.initState();
  //   _focusNode.addListener(() {
  //     setState(() {
  //       print("Has focus: $_focusNode.hasFocus");
  //     });
  //   });
  // }

  // @override
  // void dispose(){
  //   _focusNode.dispose();
  //   super.dispose();
  // }

  _steps() => [
    Step(title: const Text("Basic Information"), 
      content: Form(
        key: formKeys[0],
        child: Column(
          children: <Widget>[
            _inputName(),
            SizedBox(height: 10),
            _inputAddress(),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
              color: COLOR_WHITE, 
              border: Border.all(color: COLOR_DARK_BLUE),
              borderRadius: BorderRadius.all(Radius.circular(10))),
              child: DropdownButtonFormField(
                items: [
                  DropdownMenuItem<String>(
                    value: "For Sale",
                    child: Text(
                      "For Sale"
                    )
                  ),
                  DropdownMenuItem<String>(
                    value: "For Rent",
                    child: Text(
                      "For Rent"
                    )
                  ),
                ],
                onChanged: (value) async{
                  setState(() {
                    selectedValue = value as String;
                  });
                },
                validator: (value) => value == null ? "Please select a type": null,
              ),
            )
          ],
        )
      )
    ),
    Step(
      title: const Text("Listing Specifications"), 
      content: Form(
        key: formKeys[1],
        child: Column(
          children:<Widget>[
            _inputAmount(),
            SizedBox(height: 10),
            _inputBedrooms(),
            SizedBox(height: 10),
            _inputBathrooms(),
            SizedBox(height: 10),
            _inputArea(),
            SizedBox(height: 10),
            _inputGarages(),
          ],
        )
      )
    ),
    Step(
      title:const Text("Media Information"), 
      content: Form(
      key: formKeys[2],
      child: Column(
        children: <Widget>[
          _inputDescription(),
          SizedBox(height: 10),
          _pickedImage !=null? Image.file(_pickedImage!, width: 160, height: 160) : 
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
            ),
            onTap: () => _pickImageGallery(),
          ),
          SizedBox(height: 20),
          // Text(fileName, style: TextStyle(fontSize: 16, fontWeight:FontWeight.bold)),
          // SizedBox(height: 20),
        ],
      )
     )
    )
  ];
  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
     [ color = Colors.red]){
      ScaffoldMessenger.of(context)
      .showSnackBar( SnackBar(content: Text(message)));
    }

    void _submitDetails() async{
    final FormState? formState = _formKey.currentState!;
    if(formState!.validate()){
      _formKey.currentState!.save();
      try{
        if(_pickedImage == null){
          setState(() {
          showSnackBarMessage("Failed to upload data");
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
         showSnackBarMessage("Failed to upload data");
         loading = false;
       });
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

    // void _submitDetails(){
    //   final FormState? formState = _formKey.currentState;

    //   if(!formState!.validate()){
    //     showSnackBarMessage('Please enter correct data');
    //   } else {
    //     formState.save();
    //     print("Name: ${data.name}");
    //     print("Address: ${data.address}");
    //     print("Amount: ${data.amount}");
    //     print("Area: ${data.area}");
    //     print("Bedrooms: ${data.bedrooms}");
    //     print("Bathrooms: ${data.bathrooms}");
    //     print("Garage: ${data.garage}");
    //     print("Description: ${data.description}");

    //   }
    // }
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Stepper(
              controlsBuilder: (BuildContext context, { VoidCallback? onStepContinue, VoidCallback? onStepCancel }){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: onStepContinue, 
                      child: const Text('NEXT'),
                    ),
                    if (currentStep != 0)
                    TextButton(
                    onPressed: onStepCancel, 
                    child: const Text(
                      'BACK', 
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ],
                ),
              );
             },
              steps: _steps(),
              type: StepperType.vertical,
              currentStep: this.currentStep,
              onStepContinue: (){
                setState(() {
                  if(formKeys[currentStep].currentState!.validate()){
                    if (currentStep < _steps().length -1){
                      currentStep = currentStep + 1;
                    } else {
                      currentStep = 0;
                    }
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (currentStep > 0){
                    currentStep = currentStep - 1;
                  } else {
                    currentStep = 0;
                  }
                });
              },
              onStepTapped: (step) {
                setState(() {
                  currentStep = step;
                });
              },
            ), 
            SizedBox(
              height: 50,
              width: 80,
              child: ElevatedButton(
                onPressed: _submitDetails, 
                style: ElevatedButton.styleFrom(
                  primary: COLOR_DARK_BLUE,
                  side: BorderSide(width: 2, color: COLOR_GREY),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text("Submit Data"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _inputDescription(){
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
      color: COLOR_WHITE, 
      border: Border.all(color: COLOR_DARK_BLUE),
      borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: (val) => val!.isEmpty || val.length < 1 ? 'Enter a property description':null,
        style: TextStyle(color: COLOR_BLACK),
        decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: " Enter a description",
        labelStyle: TextStyle(color: COLOR_BLACK),
        border: InputBorder.none),
        onSaved: (val){
            description = val;
        },
      ),
    );
  }

  _inputGarages(){
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
      color: COLOR_WHITE, 
      border: Border.all(color: COLOR_DARK_BLUE),
      borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (val) => val!.isEmpty || val.length < 1 ? 'Enter No. of garages':null,
        style: TextStyle(color: COLOR_BLACK),
        decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: " Enter No. of garages",
        labelStyle: TextStyle(color: COLOR_BLACK),
        border: InputBorder.none),
        onSaved: (val){
            garage = val;
        },
      ),
    );
  }

  _inputArea(){
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
      color: COLOR_WHITE, 
      border: Border.all(color: COLOR_DARK_BLUE),
      borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (val) => val!.isEmpty || val.length < 1 ? 'Enter area in sq.ft':null,
        style: TextStyle(color: COLOR_BLACK),
        decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: " Area in sq.ft",
        labelStyle: TextStyle(color: COLOR_BLACK),
        border: InputBorder.none),
        onSaved: (val){
            area = val;
        },
      ),
    );
  }

   _inputBathrooms(){
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
      color: COLOR_WHITE, 
      border: Border.all(color: COLOR_DARK_BLUE),
      borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (val) => val!.isEmpty || val.length < 1 ? 'Enter No.of Bathrooms':null,
        style: TextStyle(color: COLOR_BLACK),
        decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: " No. of bathrooms",
        labelStyle: TextStyle(color: COLOR_BLACK),
        border: InputBorder.none),
        onSaved: (val){
            bathrooms = val;
        },
      ),
    );
  }

  _inputBedrooms(){
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
      color: COLOR_WHITE, 
      border: Border.all(color: COLOR_DARK_BLUE),
      borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (val) => val!.isEmpty || val.length < 1 ? 'Enter No.of Bedrooms':null,
        style: TextStyle(color: COLOR_BLACK),
        decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: " No. of bedrooms",
        labelStyle: TextStyle(color: COLOR_BLACK),
        border: InputBorder.none),
        onSaved: (val){
            bedrooms = val;
        },
      ),
    );
  }

  _inputAmount(){
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
      color: COLOR_WHITE, 
      border: Border.all(color: COLOR_DARK_BLUE),
      borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (val) => val!.isEmpty || val.length < 1 ? 'Enter an amount':null,
        style: TextStyle(color: COLOR_BLACK),
        decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: " Enter an amount",
        labelStyle: TextStyle(color: COLOR_BLACK),
        border: InputBorder.none),
        onSaved: (val){
            amount = val;
        },
      ),
    );
  }

  _inputName(){
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
      color: COLOR_WHITE, 
      border: Border.all(color: COLOR_DARK_BLUE),
      borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: (val) => val!.isEmpty || val.length < 1 ? 'Enter a property name':null,
        style: TextStyle(color: COLOR_BLACK),
        decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: " Enter a name",
        labelStyle: TextStyle(color: COLOR_BLACK),
        border: InputBorder.none),
        onSaved: (val){
            bathrooms = val;
        },
      ),
    );
  }

  _inputAddress(){
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
      color: COLOR_WHITE, 
      border: Border.all(color: COLOR_DARK_BLUE),
      borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: (val) => val!.isEmpty || val.length < 1 ? 'Enter an address':null,
        style: TextStyle(color: COLOR_BLACK),
        decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: " Enter an address",
        labelStyle: TextStyle(color: COLOR_BLACK),
        border: InputBorder.none),
        onSaved: (val){
           bathrooms = val;
        },
      ),
    );
  }
}



