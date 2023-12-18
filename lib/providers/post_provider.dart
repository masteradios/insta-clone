import 'package:insta_clone/resources/auth_methods.dart';
import 'package:flutter/foundation.dart';

import '../models/post.dart';
class PostProvider extends ChangeNotifier {
  Post? _post;
  Post get getUser=>_post!;

  final Auth _auth=Auth();

  Future<void> refreshUser()async
  {
    Post post= await _auth.getPostDetails();
    _post=post;
    print('eeeeeee'+post.username);
    notifyListeners();
  }
}