import 'package:another_nav_bar/utilities/constants.dart';
import 'package:flutter/material.dart';

class BorderBox extends StatelessWidget {
  const BorderBox({ Key? key,  required this.width, required this.height,required this.child, }) : super(key: key);

  final Widget child;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: COLOR_WHITE,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: COLOR_GREY.withAlpha(40), width: 2)),
      padding: EdgeInsets.all(8.0),
      child: Center(child: child),
    );
  }
}