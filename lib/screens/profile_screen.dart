import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/screens/individual_post_screen.dart';
import 'package:insta_clone/utils/snackBar.dart';
import 'package:insta_clone/widgets/follow_button.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../widgets/PostCard.dart';
import '../widgets/button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  ProfileScreen({required this.uid});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  var postData = {};
  var UserpostLen = 0;
  var userData = {};
  int followers = 0;
  int following = 0;
  bool isfollowing=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
  }

  void getAllData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      userData = userSnap.data()!;
      UserpostLen = postSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isfollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(()
      {
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void signoutuser() {
    final FirebaseAuth _firebase = FirebaseAuth.instance;
    _firebase.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: blueColor,
            ),
          )
        : SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  backgroundColor: mobileBackgroundColor,
                  title: Text(userData['username'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    '${userData['ProfilePhotoUrl']}'),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        buildStats(
                                          buttoncallback: (){},
                                            num: UserpostLen,
                                            statname: 'Posts'),
                                        buildStats(
                                            buttoncallback: (){},
                                            num: followers,
                                            statname: 'Followers'),
                                        buildStats(
                                            buttoncallback: (){},
                                            num: following,
                                            statname: 'Following'),
                                      ],
                                    ),
                                    Container(
                                        width: double.infinity,
                                        child: FirebaseAuth.instance
                                                    .currentUser!.uid ==
                                                widget.uid
                                            ? FollowButton(
                                                buttontitle: 'Sign Out',
                                                buttonCallback: signoutuser,
                                                backgroundColor:
                                                    mobileBackgroundColor,
                                                borderColor: secondaryColor)
                                            : (isfollowing
                                                ? FollowButton(
                                                    buttontitle: 'Unfollow',
                                                    buttonCallback: () async {
                                                      await FirestoreMethods()
                                                          .followUser(
                                                              currentUseruid:
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid,
                                                              followId:
                                                                  userData[
                                                                      'uid'],
                                                              currentUseremail:
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .email!,
                                                              followEmail:
                                                                  userData[
                                                                      'email']);
                                                      setState(() {
                                                        isfollowing=false;
                                                        followers--;
                                                      });
                                                    },
                                                    backgroundColor: blueColor,
                                                    borderColor: blueColor)
                                                : FollowButton(
                                                    buttontitle: 'Follow',
                                                    buttonCallback: () async {
                                                      await FirestoreMethods()
                                                          .followUser(
                                                          currentUseruid:
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid,
                                                          followId:
                                                          userData[
                                                          'uid'],
                                                          currentUseremail:
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .email!,
                                                          followEmail:
                                                          userData[
                                                          'email']);
                                                      setState(() {
                                                        isfollowing=true;
                                                        followers++;
                                                      });
                                                    },
                                                    backgroundColor: blueColor,
                                                    borderColor: blueColor)))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${userData['email']}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${userData['bio']}',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: secondaryColor,
                    ),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .orderBy('datePublished', descending: true)
                            .get(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IndividualPostScreen(
                                                      snap: snapshot
                                                          .data!.docs[index])));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: NetworkImage(snapshot.data!
                                                  .docs[index]['postUrl']))),
                                    ),
                                  ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 1.5,
                                      childAspectRatio: 1));
                        })
                  ],
                )),
          );
  }
}

class buildStats extends StatelessWidget {
  final int num;
  final String statname;
  final VoidCallback buttoncallback;
  buildStats({required this.num, required this.statname,required this.buttoncallback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: buttoncallback,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              num.toString(),
              style: TextStyle(
                  color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Text(statname,
                style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
