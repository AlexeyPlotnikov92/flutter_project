import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_project/servises/auth.dart';

class UserProject {
  String id = '';

  UserProject.fromFirebase(User user) {
    this.id = user.uid;
  }

}