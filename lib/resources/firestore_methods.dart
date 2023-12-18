import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/models/post.dart';
import 'package:insta_clone/resources/file_storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(
      {required String uid,
      required String description,
      required Uint8List image,
      required String username,
      required profileImage}) async {
    String res = 'Some error occured';
    try {
      String photoUrl = await FileStorage().uploadImage('posts', image, true);
      String postId = Uuid().v1();
      final _post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profileImage);

      await _firestore
          .collection('posts')
          .doc(_post.postId)
          .set(_post.toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> followUser(
      {required String currentUseruid,
      required String followId,
      required String currentUseremail,
      required String followEmail}) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(currentUseruid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (!following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          "followers": FieldValue.arrayUnion([currentUseruid])
        });
        await _firestore.collection('users').doc(currentUseruid).update({
          "following": FieldValue.arrayUnion([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          "followers": FieldValue.arrayRemove([currentUseruid])
        });
        await _firestore.collection('users').doc(currentUseruid).update({
          "following": FieldValue.arrayRemove([followId])
        });
      }
    } catch (e) {}
  }

  Future<void> likePost({
    required String postId,
    required String userid,
  }) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('posts').doc(postId).get();
      List likes = (snap.data()! as dynamic)['likes'];
      if (likes.contains(userid)) {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayRemove([userid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayUnion([userid])
        });
      }
    } catch (e) {}
  }

  Future<String> deletePost({required String postId})async
  {
    String res='Post Deleted Successfully!!';
    try
    {
      await _firestore.collection('posts').doc(postId).delete();
    }catch(e)
    {
      res=e.toString();
    }
    return res;
  }

  Future<String> uploadComment({required String postId,required String username,required String profImage, required String userId,required String comment}) async
  {
    String res='Comment posted Sucessfully';
    try
    {
      String commentId= Uuid().v1();
      print('this is '+postId+'this is user '+userId);
      await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(
          {
            'likes':[],
            'commentId':commentId,
            'postId':postId,
            'userId':userId,
            'comment Date':DateTime.now(),
            'comment':comment,
            'profImage':profImage,
            'username':username
          });


    }catch(e)
    {
      res=e.toString();
    }

    return res;
  }

  Future<void> likeComment({
    required String postId,
    required String commentId,
    required String userid,
  }) async {
    try {
      DocumentSnapshot snap =
      await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).get();
      List likes = (snap.data()! as dynamic)['likes'];
      if (likes.contains(userid)) {
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
          "likes": FieldValue.arrayRemove([userid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
          "likes": FieldValue.arrayUnion([userid])
        });
      }
    } catch (e)
    {
      print(e.toString());
    }
  }

}
