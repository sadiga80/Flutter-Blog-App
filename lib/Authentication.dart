import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementation {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUser();
  Future<String> signOut();
}

class Auth implements AuthImplementation {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    if (user != null) {
      return user.uid;
    } else {
      print("User not found");
    }
  }

  Future<String> signOut() async {
    firebaseAuth.signOut();
  }
}
