import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/select_image.dart';
import 'package:insta_clone/utils/snackBar.dart';
import 'package:insta_clone/widgets/button.dart';
import 'package:provider/provider.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_layout.dart';
import '../widgets/linear_indicator.dart';

class AddPostScreen extends StatefulWidget {
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool _isLoading = false;
  final _descriptionController = TextEditingController();
  Uint8List? img;

  void uploadPost(
      {required String uid,
      required String description,
      required Uint8List image,
      required String username,
      required String profileImage}) async {
    setState(() {
      _isLoading = true;
    });

    if(_descriptionController.text.isEmpty)
    {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context: context, content: 'Caption can\'t be empty!!');
    }
else
{
  try {
    String res = await FirestoreMethods().uploadPost(
        uid: uid,
        description: description,
        image: image,
        username: username,
        profileImage: profileImage);
    setState(() {
      _isLoading = false;
    });
    if (res == 'Success') {
      showSnackBar(context: context, content: 'Post Uploaded Successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
      {
        return ResponsiveUI(MobileScreenLayout: MobileScreenLayout(), WebLayout: WebLayout());
      }));
    } else {
      showSnackBar(context: context, content: res);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
}

  }

  _selectImage(BuildContext context) async {
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

  void clearImage()
  {
    setState(() {
      img=null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ModelUser _user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: mobileBackgroundColor,
            title: Text(
              'Create Post',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: (img==null)?null:IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: clearImage,
            ),
          ),
          body: (img == null)
              ? Center(
                  child: TextButton(
                    onPressed: () {
                      _selectImage(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload,
                          size: 40,
                          color: blueColor,
                        ),
                        Text(
                          'Upload Image',
                          style: TextStyle(color: primaryColor, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(alignment: Alignment.centerRight,child: TextButton(child: Text('Retake photo',style: TextStyle(color: primaryColor,fontSize: 15,fontWeight: FontWeight.bold),),onPressed: ()
                      {
                        _selectImage(context);
                      },),),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(img!), fit: BoxFit.contain)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage('${_user.photoUrl}'),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0,bottom: 10),
                                child: TextField(
                                  controller: _descriptionController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLength: 100,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Write a caption...',
                                    labelStyle: TextStyle(color: primaryColor),
                                    contentPadding: EdgeInsets.all(10),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: Divider.createBorderSide(
                                            context,
                                            color: secondaryColor)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: Divider.createBorderSide(
                                            context,
                                            color: secondaryColor)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _isLoading
                          ? ShowLinearIndicator()
                          : Container(
                        width: double.infinity,
                            child: Button(
                                buttontitle: 'Share',
                                buttonCallback: () => uploadPost(
                                      description:
                                          _descriptionController.text.trim(),
                                      image: img!,
                                      uid: _user.uid,
                                      username: _user.username,
                                      profileImage: _user.photoUrl,
                                    )),
                          )
                    ],
                  ),
                )),
    );
  }
}


