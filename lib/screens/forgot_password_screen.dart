import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/snackBar.dart';
import 'package:insta_clone/widgets/button.dart';
import 'package:insta_clone/widgets/text_input_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController=TextEditingController();
  bool isLoading=false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/insta.svg',height: 50,
              ),
              Container(
                padding: EdgeInsets.all(10),
                  child: Text(
                'Enter email on which reset password link should be sent :',
                style: TextStyle(fontSize: 18,color: secondaryColor),
              )),
              TextInputField(
                  labeltext: '',
                  hinttext: '',
                  controller: _emailController,
                  keyboardtype: TextInputType.emailAddress),
             isLoading?Container(width: double.infinity,color: Colors.blue,child: Center(child: const CircularProgressIndicator(color: primaryColor,)),): Container(width: double.infinity,child: Button(buttontitle: 'Submit', buttonCallback: ()
              async {
                setState(() {
                  isLoading=true;
                });
                String res=await Auth().sendPasswordResetMail(email: _emailController.text.trim());
                setState(() {
                  isLoading=false;
                });
                showSnackBar(context: context, content: res);
                  Navigator.of(context).pop();
              }))
            ],
          ),
        ),
      ),
    );
  }
}
