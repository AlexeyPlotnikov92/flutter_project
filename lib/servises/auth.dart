import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_project/servises/user_project.dart';

class AuthService{
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<UserProject?> signInWithEmail(String email, String password) async {
    try{
      UserCredential result =  await _fAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return UserProject.fromFirebase(user!);
    }catch(e) {
       return null;
    }
  }

  Future<UserProject?> registerInWithEmail(String email, String password) async {
    try{
      UserCredential result =  await _fAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user == null) return null;
      return UserProject.fromFirebase(user);
    }catch(e) {
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();

  }

  Stream<UserProject?> get currentUser {
    return _fAuth.authStateChanges().map((User? user) => user != null ? UserProject.fromFirebase(user) : null);
  }

}