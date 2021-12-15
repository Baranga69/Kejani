import 'package:another_nav_bar/utilities/constants.dart';
import 'package:flutter/material.dart';

class BorderIcon extends StatelessWidget {

  final Widget child;
  final  width, height;
  const BorderIcon({ Key? key, required this.child,  this.width, this.height, EdgeInsets? padding,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: COLOR_WHITE,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        border: Border.all(color: COLOR_GREY.withAlpha(40),width: 2)),
      padding: const EdgeInsets.all(8.0),
      child: Center(child: child),
    );
  }
}