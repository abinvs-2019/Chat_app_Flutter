import 'package:chat_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Auth {
  final FirebaseAuth _emailAuth = FirebaseAuth.instance;

  UserClass _userFromFirebaseUser(User user) {
    return user != null ? UserClass(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential resultemail = await _emailAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = resultemail.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString);
      return null;
    }
  }

  Future signUpWithEmailAndPaaword(String email, String password) async {
    try {
      UserCredential resultemail = await _emailAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = resultemail.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _emailAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _emailAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
