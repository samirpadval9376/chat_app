import 'dart:developer';

import 'package:chat_app/helpers/firebase_auth_helper.dart';
import 'package:chat_app/helpers/firestore_helper.dart';
import 'package:chat_app/modals/friend_model.dart';
import 'package:chat_app/modals/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = Auth.auth.firebaseAuth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        actions: [
          IconButton(
            onPressed: () {
              Auth.auth.signOut().then(
                    (value) => Navigator.of(context).pushReplacementNamed('/'),
                  );
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FirebaseStoreHelper.firebaseStoreHelper.getFriendsList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
              List<QueryDocumentSnapshot<Map<String, dynamic>>>? alldocs =
                  data?.docs;

              List<FriendModel> allFriends = alldocs
                      ?.map((e) => FriendModel.fromMap(data: e.data()))
                      .toList() ??
                  [];
              return ListView.builder(
                  itemCount: allFriends.length,
                  itemBuilder: (context, index) {
                    FriendModel friendModel = allFriends[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          'chat_page',
                          arguments: user,
                        );
                      },
                      title: Text(friendModel.name),
                      subtitle: Text(friendModel.email),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add User"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 100,
                      child: StreamBuilder(
                        stream:
                            FirebaseStoreHelper.firebaseStoreHelper.getData(),
                        builder: (context, snapShot) {
                          QuerySnapshot? data = snapShot.data;
                          List<QueryDocumentSnapshot> allData =
                              data?.docs ?? [];
                          List<UserModal> allUsers = allData
                              .map((e) =>
                                  UserModal.fromMap(data: e.data() as Map))
                              .toList();

                          if (snapShot.hasData) {
                            return ListView.builder(
                              itemCount: allUsers.length,
                              itemBuilder: (context, index) {
                                UserModal userModal = allUsers[index];
                                log("${allUsers[index]}");
                                return ListTile(
                                  onTap: () async {
                                    if (allUsers.contains(userModal)) {
                                      await FirebaseStoreHelper
                                          .firebaseStoreHelper
                                          .addFriend(userModal: userModal)
                                          .then(
                                            (value) =>
                                                allUsers.remove(userModal),
                                          );
                                    }
                                    Navigator.pop(context);
                                  },
                                  leading: CircleAvatar(
                                    foregroundImage: NetworkImage(
                                      user?.photoURL ??
                                          "https://comprasalternativas.com.br/wp-content/uploads/2021/05/perfil-1988x2048.png",
                                    ),
                                  ),
                                  title: Text(userModal.name),
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
