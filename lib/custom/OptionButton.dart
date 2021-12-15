
import 'package:another_nav_bar/pages/details_page.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:another_nav_bar/utilities/widget_function.dart';
import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({ Key? key, required this.text, required this.icon, required this.width }) : super(key: key);

  final String text;
  final IconData icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: FlatButton(
        color: COLOR_DARK_BLUE,
        splashColor: COLOR_WHITE.withAlpha(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        onPressed:  () {}, 
        child: Row(
          children: [
            Icon(icon,color: COLOR_WHITE,),
            addHorizontalSpace(10),
            Text(text,style: TextStyle(color: COLOR_WHITE),)
          ],
        ), 
      ),  
    );
  }
}