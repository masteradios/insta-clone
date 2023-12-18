import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/snackBar.dart';
import 'package:insta_clone/widgets/button.dart';
import 'package:provider/provider.dart';
import '../widgets/CommentCard.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  CommentScreen({required this.snap});
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  void popKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    ModelUser _user = Provider.of<UserProvider>(context).getUser;
    void uploadComment() async {
      try {
        print(widget.snap['postId']);
        String res = await FirestoreMethods().uploadComment(
            username: _user.username,
            profImage: _user.photoUrl,
            comment: _commentController.text.trim(),
            postId: widget.snap['postId'],
            userId: FirebaseAuth.instance.currentUser!.uid);
        showSnackBar(context: context, content: res);
        _commentController.clear();
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.snap['postId'])
                    .collection('comments').orderBy('comment Date',descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: const CircularProgressIndicator(
                        color: blueColor,
                      ),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return CommentCard(
                            Commentsnap: snapshot.data!.docs[index]);
                      });
                }),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('${_user.photoUrl}'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                  child: TextField(
                    controller: _commentController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 20,
                    decoration: InputDecoration(
                        hintText: 'Comment as ${_user.username}',
                        labelStyle: TextStyle(color: primaryColor),
                        contentPadding: EdgeInsets.all(10),
                        focusColor: secondaryColor),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    if (_commentController.text.trim().isEmpty) {
                      showSnackBar(
                          context: context, content: 'Comment can\'t be empty');
                    } else {
                      uploadComment();
                      popKeyboard(context);
                    }
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(color: blueColor),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
