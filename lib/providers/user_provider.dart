import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:flutter/foundation.dart';
class UserProvider extends ChangeNotifier {
  ModelUser? _user;
  ModelUser get getUser=>_user!;

  final Auth _auth=Auth();

  Future<void> refreshUser()async
  {
    ModelUser user= await _auth.getUserDetails();
     _user=user;
     print('eeeeeee'+user.username);
     notifyListeners();
  }
  }

