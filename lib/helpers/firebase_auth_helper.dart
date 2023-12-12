import 'dart:developer';

import 'package:chat_app/modals/user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth._();

  static final Auth auth = Auth._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential?> getUserWithEmailAndPassword(
      {required UserModal userModal}) async {
    UserCredential? credential;
    try {
      credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: userModal.email,
        password: userModal.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log("$e");
    }

    return credential;
  }

  Future<UserCredential?> signInUserWithEmailPassword(
      {required UserModal userModal}) async {
    UserCredential? credential;

    try {
      credential = await firebaseAuth.signInWithEmailAndPassword(
          email: userModal.email, password: userModal.password);
    } on FirebaseAuthException catch (e) {
      log(e.code);
    }
    return credential;
  }

  getUserWithCredential() async {
    OAuthCredential? credential;
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await firebaseAuth.signInWithCredential(credential);
  }
}
