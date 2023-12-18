import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';

class Button extends StatelessWidget {
  final String buttontitle;
  final VoidCallback buttonCallback;
   Button({required this.buttontitle,required this.buttonCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:10,horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: blueColor),
        child: TextButton(
          onPressed: buttonCallback,
          child: Text(buttontitle,style: TextStyle(color: primaryColor),),
        ));
  }
}
