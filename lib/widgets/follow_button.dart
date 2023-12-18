import 'package:flutter/material.dart';

import '../utils/colors.dart';

class FollowButton extends StatelessWidget {
  final String buttontitle;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback buttonCallback;
  FollowButton({required this.buttontitle, required this.buttonCallback,required this.backgroundColor,required this.borderColor});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: buttonCallback,
      child: Container(
        alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(5), color: backgroundColor),
          child: Text(
            buttontitle,
            style: TextStyle(color: primaryColor),
          )),
    );
  }
}
