
import 'package:another_nav_bar/models/listings.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:another_nav_bar/utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final _firestoreCall = FirebaseFirestore.instance;
    final listingId = ModalRoute.of(context)?.settings.arguments;
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreCall.collection('Kejani Listings').snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData){
          return Center(
            child: Container(
              child: Column(
                children: [
                  Loading(),
                  Text('No Data found..'),
                ],
              ),
            ),
          );
        }
       CollectionReference colref = FirebaseFirestore.instance.collection('Kejani Listings');
    
        return SafeArea(
          child: Scaffold(
            backgroundColor: COLOR_WHITE,
            body: Container(
              width: size.width,
              height: size.height,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ListView(
                  children: [
                    Image.network('')
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}