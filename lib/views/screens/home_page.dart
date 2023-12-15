import 'dart:developer';

import 'package:chat_app/helpers/firebase_auth_helper.dart';
import 'package:chat_app/helpers/firestore_helper.dart';
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
                    (value) => Navigator.of(context).pushNamed('/'),
                  );
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FirebaseStoreHelper.firebaseStoreHelper.getData(),
          builder: (context, snapShot) {
            QuerySnapshot? data = snapShot.data;
            List<QueryDocumentSnapshot> allData = data!.docs;
            List<UserModal> allUsers = allData
                .map((e) => UserModal.fromMap(data: e.data() as Map))
                .toList();

            if (snapShot.hasData) {
              return ListView.builder(
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  UserModal userModal = allUsers[index];
                  log("${allUsers.length}");
                  return ListTile(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UserModal user1 = UserModal(
            id: 101,
            age: 19,
            name: "Samir",
          );

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add User"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (val) {
                        user1.id = int.parse(val);
                      },
                      decoration: const InputDecoration(
                        labelText: "Id",
                      ),
                    ),
                    TextField(
                      onChanged: (val) {
                        user1.name = val;
                      },
                      decoration: const InputDecoration(
                        labelText: "Name",
                      ),
                    ),
                    TextField(
                      onChanged: (val) {
                        user1.age = int.parse(val);
                      },
                      decoration: const InputDecoration(
                        labelText: "Age",
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      FirebaseStoreHelper.firebaseStoreHelper
                          .addUser(userModal: user1, email: user!.email)
                          .then(
                            (value) => Navigator.pop(context),
                          );
                    },
                    child: const Text("Done"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
