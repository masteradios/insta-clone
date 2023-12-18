import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/responsive/responsive_layout.dart';
import 'package:insta_clone/responsive/web_layout.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/utils/select_image.dart';
import 'package:insta_clone/utils/snackBar.dart';
import 'package:insta_clone/widgets/button.dart';
import 'package:insta_clone/widgets/circular_indicator.dart';
import '../responsive/mobile_screen_layout.dart';
import '../utils/colors.dart';
import '../widgets/text_input_field.dart';

class SignUpScreen extends StatefulWidget {

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  Uint8List? img;
  bool _isLoading = false;
  void _selectImage() async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select Image'),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Uint8List _img = await getImage(source: ImageSource.camera);
                  setState(() {
                    img = _img;
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('Upload from camera'))),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Uint8List _img = await getImage(source: ImageSource.gallery);
                  setState(() {
                    img = _img;
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('Upload from gallery'))),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('Cancel'))),
              ),
            ],
          );
        });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void SignupCallback() async {
    String? res;
    if (img == null) {
      setState(() {
        res = 'Please select a Profile Image!!';
        showSnackBar(context: context,content: res!);
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      res = await Auth().signUpUser(
          imagefile: img!,
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          username: _usernameController.text.trim(),
          bio: _bioController.text.trim());
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
        Navigator.push(context, MaterialPageRoute(builder: (context)
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
          child: SingleChildScrollView(
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/insta.svg',
                  height: 64,
                ), //Insta Log
                Stack(
                  children: [
                    img != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(img!),
                          )
                        : CircleAvatar(

                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://randomuser.me/api/portraits/lego/5.jpg'),
                          ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                            radius: 20,
                            backgroundColor: blueColor,
                            child: IconButton(
                              icon: Icon(
                                Icons.add_a_photo_rounded,
                                size: 20,
                                color: primaryColor,
                              ),
                              onPressed: _selectImage,
                            )))
                  ],
                ),
                TextInputField(
                    labeltext: 'Enter Username',
                    hinttext: '',
                    controller: _usernameController,
                    keyboardtype: TextInputType.text), //username
                TextInputField(

                  labeltext: 'Enter Email',
                  hinttext: 'abc@example.com',
                  controller: _emailController,
                  keyboardtype: TextInputType.emailAddress,
                ), //  Email
                TextInputField(
                    isPassword: true,
                    labeltext: 'Enter Password',
                    hinttext: '',
                    controller: _passwordController,
                    keyboardtype: TextInputType.text), //Password
                TextInputField(
                    labeltext: 'Enter your bio',
                    hinttext: 'Tell us about yourself',
                    controller: _bioController,
                    keyboardtype: TextInputType.text),
                _isLoading? ShowCircularIndicator():Container(width: double.infinity,child: Button(buttontitle: 'SignUp', buttonCallback: SignupCallback)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: primaryColor),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          ' Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: primaryColor),
                        ))
                  ],
                )
              ],
            )),
      )),
    );
  }
}

