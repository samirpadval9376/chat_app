import 'package:chat_app/helpers/firestore_helper.dart';
import 'package:chat_app/modals/chat_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FirebaseStoreHelper.firebaseStoreHelper
              .getChats(receiverId: user.email!,senderId: user.email!),
          builder: (context, snapShot) {
            QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;

            List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs = data?.docs ?? [];

            List<ChatModal> allChats = allDocs.map((e) => ChatModal.fromMap(data: e.data())).toList();

            if (snapShot.hasData) {
              return ListView.builder(
                itemCount: allChats.length,
                itemBuilder: (context, index) {

                  ChatModal chatModal = allChats[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(chatModal.msg),
                      TextField(
                        onSubmitted: (val) {
                          // FirebaseStoreHelper.firebaseStoreHelper.sentChat(chatModal: chatModal, senderId: user.email!, receiverId: receiverId)
                        },
                        decoration: InputDecoration(
                          labelText: "Type a msg",
                        ),
                      ),
                    ],
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
    );
  }
}
