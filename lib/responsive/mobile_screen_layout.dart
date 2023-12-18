import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/screens/add_post_screen.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/screens/search_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  PageController _pageController = PageController();
  var user;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      user = userData;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void goToPage(int pageNumber) {
    _pageController.jumpToPage(pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: const CircularProgressIndicator(
            color: blueColor,
          ))
        : PopScope(
            canPop: false,
            child: Scaffold(
              body: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  FeedScreen(),
                  SearchScreen(),
                  AddPostScreen(),
                  Center(child: Text('fav')),
                  ProfileScreen(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ),
                ],
              ),
              bottomNavigationBar: CupertinoTabBar(
                activeColor: primaryColor,
                currentIndex: _page,
                inactiveColor: secondaryColor,
                backgroundColor: mobileBackgroundColor,
                onTap: (newValue) {
                  setState(() {
                    _page = newValue;
                  });
                  goToPage(_page);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      backgroundColor: primaryColor,
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      backgroundColor: primaryColor,
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_circle_outline_outlined),
                      backgroundColor: primaryColor,
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      backgroundColor: primaryColor,
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Container(
                        height: 30,
                        width: 30,
                        decoration: _page == 4
                            ? BoxDecoration(
                                border:
                                    Border.all(width: 2, color: primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    user['ProfilePhotoUrl'],
                                  ),
                                ),
                              )
                            : BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    user['ProfilePhotoUrl'],
                                  ),
                                ),
                              ),
                      ),
                      backgroundColor: primaryColor,
                      label: ''),
                ],
              ),
            ),
          );
  }
}
