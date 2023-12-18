import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
class FileStorage
{
  final FirebaseStorage _storage=FirebaseStorage.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  Future<String> uploadImage(String childName,Uint8List file,bool isPost) async
  {
    Reference _ref=_storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(isPost)
    {
      String pid=Uuid().v1();
      Reference _ref=_storage.ref().child(childName).child(_auth.currentUser!.email!).child(pid);
      UploadTask uploadTask=_ref.putData(file);
      TaskSnapshot taskSnapshot=await uploadTask;
      String downloadUrl=await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }


    UploadTask uploadTask=_ref.putData(file);
    TaskSnapshot taskSnapshot=await uploadTask;
   String downloadUrl=await taskSnapshot.ref.getDownloadURL();
   return downloadUrl;
  }
}