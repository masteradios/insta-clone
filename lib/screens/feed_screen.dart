import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:insta_clone/utils/colors.dart';

import '../widgets/PostCard.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          backgroundColor: mobileBackgroundColor,
          title: SvgPicture.asset(
            'assets/insta.svg',
            height: 40,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.message_2),
              color: primaryColor,
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished',descending: true).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) =>
                    PostCard(snap: snapshot.data!.docs[index]));
          },
        ),
      ),
    );
  }
}
