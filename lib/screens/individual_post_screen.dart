import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/PostCard.dart';
class IndividualPostScreen extends StatelessWidget {
  final snap;
  IndividualPostScreen({required this.snap});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PostCard(snap: snap,),);
  }
}
