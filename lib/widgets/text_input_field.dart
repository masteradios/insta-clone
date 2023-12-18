import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';

class TextInputField extends StatelessWidget {
  final hinttext;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardtype;

  final labeltext;
   TextInputField({required this.labeltext,required this.hinttext,this.isPassword=false,required this.controller,required this.keyboardtype});

  @override
  Widget build(BuildContext context) {
    final inputBorder=OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,color: secondaryColor));
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardtype,
        decoration: InputDecoration
          (
          fillColor: Colors.white54,
          hintText: hinttext,
          labelStyle: TextStyle(color: primaryColor),
          labelText: labeltext,
          filled: true,
          contentPadding: EdgeInsets.all(10),
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,

        ),
      ),
    );
  }
}
