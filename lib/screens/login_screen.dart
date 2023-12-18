import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/screens/forgot_password_screen.dart';
import 'package:insta_clone/screens/signup_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/button.dart';
import 'package:insta_clone/widgets/circular_indicator.dart';
import 'package:insta_clone/widgets/text_input_field.dart';

import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_layout.dart';
import '../utils/snackBar.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void forgotpassword()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading=false;
  void loginUserCallback() async {
    String? res;
 {
      setState(() {
        _isLoading = true;
      });
      res = await Auth().loginUser(email: _emailController.text, password: _passwordController.text);
      print(res);
      setState(() {
        _isLoading = false;
      });
      if (res != 'Success') {
        if (res == 'Some error took place') {
          setState(() {
            res = 'Please fill proper details!!';
          });
        }
        showSnackBar(context: context,content: res!);
      }
      else
      {
        print('Login Sucessful');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
        {
          return ResponsiveUI(MobileScreenLayout: MobileScreenLayout(), WebLayout: WebLayout());
        }));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/insta.svg',
                    height: 64,
                  ),
                  TextInputField(
                    labeltext: 'Enter Email',
                    hinttext: 'abc@example.com',
                    controller: _emailController,
                    keyboardtype: TextInputType.emailAddress,
                  ),
                  TextInputField(
                      isPassword: true,
                      labeltext: 'Enter Password',
                      hinttext: '',
                      controller: _passwordController,
                      keyboardtype: TextInputType.visiblePassword),
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: forgotpassword,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: primaryColor),
                          ))),
                  _isLoading?
                  ShowCircularIndicator():Container(width: double.infinity,child: Button(buttontitle: 'Login',buttonCallback: loginUserCallback,)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?',style: TextStyle(color: primaryColor),),
                      GestureDetector(onTap: ()
                      {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                      },child: Text(' SignUp',style: TextStyle(fontWeight: FontWeight.bold,color: primaryColor),))
                    ],
                  )
                ],
              ))),
    );
  }
}
