import 'package:flutter/material.dart';

showSnackBar({required BuildContext context,required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: 2),
    content: Text(content),
  ));
}
