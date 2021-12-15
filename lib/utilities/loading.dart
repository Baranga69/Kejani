import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:another_nav_bar/utilities/constants.dart';

class Loading extends StatelessWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitSquareCircle(
        color: COLOR_DARK_BLUE,
        size: 50.0,
        ),
      ),
    );
  }
}