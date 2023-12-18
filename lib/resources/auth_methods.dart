import 'dart:typed_data';
import 'package:insta_clone/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/resources/file_storage_methods.dart';

import '../models/post.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List imagefile}) async {
    String res = 'Some error took place';
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(cred.user!.email);
      String photoUrl =
          await FileStorage().uploadImage('profilePic', imagefile, false);

      model.ModelUser user = model.ModelUser(
          email: email,
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          bio: bio,
          followers: [],
          following: []);
      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());
      res = 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        res = 'There already exists an account with the given email address';
      } else if (e.code == 'invalid-email') {
        res = 'the email address is not valid';
      } else if (e.code == 'weak-password') {
        res = 'Password should be of atleast 6 letters';
      }
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error took place';
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('New User' + cred.user!.email!);
      res = 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        res = 'The password is invalid for the given email';
      } else if (e.code == 'invalid-email') {
        res = 'the email address is not valid';
      } else if (e.code == 'user-not-found') {
        res = 'User doesn\'t exist';
      }
    }
    return res;
  }

  Future<model.ModelUser> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    print('sssssssss' + snap['email']);
    return model.ModelUser.fromSnap(snap);
  }

  Future<Post> getPostDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('posts').doc(currentUser.uid).get();
    print('sssssssss' + snap['email']);
    return Post.fromSnap(snap);
  }

  Future<String> sendPasswordResetMail({required String email}) async {
    String res = 'Password mail sent successfully';
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e)
    {
      res=e.toString();
    }
    return res;
  }
}
