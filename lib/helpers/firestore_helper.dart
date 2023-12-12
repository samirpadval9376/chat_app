import 'package:chat_app/modals/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:developer';

class FirebaseStoreHelper {
  FirebaseStoreHelper._();

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  static final FirebaseStoreHelper firebaseStoreHelper =
      FirebaseStoreHelper._();

  String userCollection = "Users";

  getUser({required UserModal userModal}) async {
    await firebaseFireStore
        .collection(userCollection)
        .doc(userModal.email)
        .set(userModal.toMap)
        .then(
          (value) => log("created!!!"),
        );
  }
}
