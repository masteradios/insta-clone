import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ShowCircularIndicator extends StatelessWidget {
  const ShowCircularIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: blueColor),
      child: Center(
          child: CircularProgressIndicator(
        color: primaryColor,
      )),
    );
  }
}
// Container(
// margin: EdgeInsets.symmetric(vertical:10),
// width: double.infinity,
// padding: EdgeInsets.symmetric(vertical: 5),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(5), color: blueColor),
// child:const Center(child:CircularProgressIndicator(color: primaryColor,)),)
