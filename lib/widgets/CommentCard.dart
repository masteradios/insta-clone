import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final Commentsnap;
  CommentCard({required this.Commentsnap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {

  @override
  Widget build(BuildContext context) {
    String date =
        DateFormat('MMMM').format(widget.Commentsnap['comment Date'].toDate()) +
            ' ' +
            widget.Commentsnap['comment Date'].toDate().day.toString() +
            ', ' +
            widget.Commentsnap['comment Date'].toDate().year.toString();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.Commentsnap['profImage']),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        uid: widget.Commentsnap['userId'])));
                          },
                          child: Text(
                            '${widget.Commentsnap['username']} ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Text(
                        '${date}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 12),
                      )
                    ],
                  ),
                  Text(
                    '${widget.Commentsnap['comment']}',
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: ()async{
                await FirestoreMethods().likeComment(postId: widget.Commentsnap['postId'], commentId: widget.Commentsnap['commentId'], userid: FirebaseAuth.instance.currentUser!.uid);
              },color: widget.Commentsnap['likes']
                  .contains(FirebaseAuth.instance.currentUser!.uid)
                  ? Colors.red
                  : Colors.white,
                icon: widget.Commentsnap['likes']
                    .contains(FirebaseAuth.instance.currentUser!.uid)
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),),
              Text('${widget.Commentsnap['likes'].length}',style: TextStyle(fontSize: 12),)
            ],
          )
        ],
      ),
    );
  }
}
