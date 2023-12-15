import 'dart:developer';

import 'package:chat_app/modals/user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth._();

  static final Auth auth = Auth._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignInAccount? googleUser;

  Future<User?> getUserWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential? credential;
    try {
      credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
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

    if (credential != null) {
      return credential.user;
    } else {
      return null;
    }
  }

  Future<User?> signInUserWithEmailPassword(
      {required String email, required String password}) async {
    UserCredential? credential;

    try {
      credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log(e.code);
    }

    if (credential != null) {
      return credential.user;
    } else {
      return null;
    }
  }

  Future<AuthCredential?> getUserWithCredential() async {
    googleUser = await GoogleSignIn(scopes: ['email']).signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    firebaseAuth.signInWithCredential(credential);
    return credential;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }
}
