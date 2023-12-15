import 'package:chat_app/modals/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:developer';

class FirebaseStoreHelper {
  FirebaseStoreHelper._();

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  static final FirebaseStoreHelper firebaseStoreHelper =
      FirebaseStoreHelper._();

  String userCollection = "Users";

  Future<void> addUser(
      {required UserModal userModal, required String? email}) async {
    await firebaseFireStore
        .collection(userCollection)
        .doc(email)
        .set(userModal.toMap)
        .then(
          (value) => log("created!!!"),
        );
  }

  Future<void> updateUser(
      {required UserModal userModal, required String email}) async {
    await firebaseFireStore
        .collection(userCollection)
        .doc(email)
        .update(userModal.toMap);
  }

  Future<void> deleteUser(
      {required UserModal userModal, required String email}) async {
    await firebaseFireStore.collection(userCollection).doc(email).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getData() {
    return firebaseFireStore.collection(userCollection).snapshots();
  }

  getUser({required UserModal userModal}) {
    firebaseFireStore.collection(userCollection).add(userModal.toMap).then(
          (value) => log(userModal.name),
        );
  }
}
