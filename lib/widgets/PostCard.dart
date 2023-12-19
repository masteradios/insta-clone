import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/utils/snackBar.dart';
import 'package:intl/intl.dart';

import '../screens/comments_screen.dart';
import '../utils/colors.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  void reportPost() {
    print('Post has been reported');
    showSnackBar(context: context, content: 'Post has been reported');
    Navigator.of(context).pop();
  }

  void getComments() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
    setState(() {
      commentLen = snap.docs.length;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }
  @override
  Widget build(BuildContext context) {
    String date =
        DateFormat('MMMM').format(widget.snap['datePublished'].toDate()) +
            ' ' +
            widget.snap['datePublished'].toDate().day.toString() +
            ', ' +
            widget.snap['datePublished'].toDate().year.toString();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      color: mobileBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(widget.snap['profImage']),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(widget.snap['username'],
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  widget.snap['uid'] ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? 'Delete'
                                      : 'Report'
                                ]
                                    .map((e) => InkWell(
                                          onTap: widget.snap['uid'] ==
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                              ? () async {
                                                  String res =
                                                      await FirestoreMethods()
                                                          .deletePost(
                                                              postId: widget
                                                                      .snap[
                                                                  'postId']);
                                                  showSnackBar(
                                                      context: context,
                                                      content: res);
                                                  Navigator.of(context).pop();
                                                }
                                              : reportPost,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(
                                                e,
                                                style: TextStyle(
                                                    color: primaryColor),
                                              )),
                                        ))
                                    .toList(),
                              ),
                            ));
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: primaryColor,
                  ))
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 20,
            ),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.snap['postUrl']),
                    fit: BoxFit.contain)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  ActionOnPost(
                      color: widget.snap['likes']
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.red
                          : Colors.white,
                      icon: widget.snap['likes']
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      IconCallback: () async {
                        await FirestoreMethods().likePost(
                            postId: widget.snap['postId'],
                            userid: FirebaseAuth.instance.currentUser!.uid);
                      }),
                  ActionOnPost(
                      color: Colors.white,
                      icon: HeroIcons.chat_bubble_bottom_center,
                      IconCallback: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CommentScreen(snap: widget.snap)));
                      }),
                  ActionOnPost(
                      color: Colors.white,
                      icon: HeroIcons.share,
                      IconCallback: () {}),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ActionOnPost(
                      color: Colors.white,
                      icon: Icons.bookmark_border,
                      IconCallback: () {}),
                ),
              )
            ],
          ),
          Text(
            widget.snap['likes'].length.toString() + ' likes',
            style: TextStyle(color: Colors.white70),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.snap['username'],
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold)),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    widget.snap['description'],
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CommentScreen(snap: widget.snap)));
              },
              child: Text(
                'View all ${commentLen} comments',
                style: TextStyle(color: secondaryColor,fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Container(
            child: Text(
              date,
              style: TextStyle(color: secondaryColor),
            ),
          )
        ],
      ),
    );
  }
}

class ActionOnPost extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback IconCallback;
  ActionOnPost(
      {required this.icon, required this.IconCallback, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
          onTap: IconCallback,
          child: Icon(
            icon,
            color: color,
            size: 30,
          )),
    );
  }
}
