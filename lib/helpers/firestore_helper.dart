import 'package:chat_app/helpers/firebase_auth_helper.dart';
import 'package:chat_app/modals/chat_modal.dart';
import 'package:chat_app/modals/friend_model.dart';
import 'package:chat_app/modals/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:developer';

class FirebaseStoreHelper {
  FirebaseStoreHelper._();

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  static final FirebaseStoreHelper firebaseStoreHelper =
      FirebaseStoreHelper._();

  String userCollection = "Users";
  String friends = "friends";

  Future<void> addUser({required UserModal userModal}) async {
    await firebaseFireStore
        .collection(userCollection)
        .doc(userModal.email)
        .set(userModal.toMap)
        .then(
          (value) => log("created!!!"),
        );
  }

  Future<void> updateUser({required UserModal userModal}) async {
    await firebaseFireStore
        .collection(userCollection)
        .doc(userModal.email)
        .update(
          userModal.toMap,
        );
  }

  Future<void> deleteUser(
      {required UserModal userModal, required String email}) async {
    await firebaseFireStore.collection(userCollection).doc(email).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getData() {
    String email = Auth.auth.firebaseAuth.currentUser!.email as String;
    return firebaseFireStore
        .collection(userCollection)
        .where('email', isNotEqualTo: email)
        .snapshots();
  }

  getUser({required UserModal userModal}) {
    firebaseFireStore.collection(userCollection).add(userModal.toMap).then(
          (value) => log(userModal.name),
        );
  }

  Future<void> addFriend({required UserModal userModal}) async {
    String email = Auth.auth.firebaseAuth.currentUser!.email as String;
    FriendModel friendModel = FriendModel(
      id: userModal.id,
      name: userModal.name,
      email: userModal.email,
    );
    await firebaseFireStore
        .collection(userCollection)
        .doc(email)
        .collection('friends')
        .doc(userModal.email)
        .set(friendModel.toMap())
        .then((value) {
      log("friends collection added !!");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFriendsList() {
    String email = Auth.auth.firebaseAuth.currentUser!.email as String;
    return firebaseFireStore
        .collection(userCollection)
        .doc(email)
        .collection('friends')
        .snapshots();
  }

  Future<void> sentChat(
      {required ChatModal chatModal,
      required String senderId,
      required String receiverId}) async {
    Map<String, dynamic> data = chatModal.toMap;

    data.update('type', (value) => 'sent');

    await firebaseFireStore
        .collection(userCollection)
        .doc(senderId)
        .collection(receiverId)
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(data);

    data.update('type', (value) => 'rec');

    await firebaseFireStore
        .collection(userCollection)
        .doc(receiverId)
        .collection(senderId)
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(
      {required String senderId, required String receiverId}) {
    return firebaseFireStore
        .collection(userCollection)
        .doc(senderId)
        .collection(receiverId)
        .snapshots();
  }
}
