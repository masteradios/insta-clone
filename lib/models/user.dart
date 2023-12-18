import 'package:cloud_firestore/cloud_firestore.dart';

class ModelUser
{
  final String email;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final String photoUrl;
  final String uid;
  ModelUser({required this.email,required this.username,required this.uid,required this.photoUrl,required this.bio,required this.followers,required this.following});

Map<String,dynamic> toJson()=>
  {
    'email': email,
    'username': username,
    'bio': bio,
    'followers': [],
    'following': [],
    'ProfilePhotoUrl':photoUrl,
    'uid':uid

};

static ModelUser fromSnap(DocumentSnapshot snap)
{
  var snapshot=snap.data() as Map<String,dynamic>;

  return ModelUser(email: snapshot['email'], username: snapshot['username'], uid: snapshot['uid'], photoUrl: snapshot['ProfilePhotoUrl'], bio: snapshot['bio'], followers: snapshot['followers'], following: snapshot['following']);
}
}