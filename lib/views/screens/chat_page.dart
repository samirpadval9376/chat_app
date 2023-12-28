import 'package:chat_app/helpers/firebase_auth_helper.dart';
import 'package:chat_app/helpers/firestore_helper.dart';
import 'package:chat_app/modals/chat_modal.dart';
import 'package:chat_app/modals/friend_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  User? user = Auth.auth.firebaseAuth.currentUser;
  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FriendModel? friendModel =
        ModalRoute.of(context)!.settings.arguments as FriendModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FirebaseStoreHelper.firebaseStoreHelper.getChats(
              receiverId: friendModel.email, senderId: user?.email as String),
          builder: (context, snapShot) {
            QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;

            List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                data?.docs ?? [];

            List<ChatModal> allChats =
                allDocs.map((e) => ChatModal.fromMap(data: e.data())).toList();

            if (snapShot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: allChats.length,
                      itemBuilder: (context, index) {
                        ChatModal chatModal = allChats[index];

                        return (chatModal.type == 'sent')
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: Text(chatModal.msg),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(chatModal.msg),
                                  ),
                                ],
                              );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: chatController,
                          decoration: const InputDecoration(
                            hintText: "Message",
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FloatingActionButton(
                          onPressed: () {
                            ChatModal chatModal = ChatModal(
                                chatController.text, DateTime.now(), 'sent');

                            FirebaseStoreHelper.firebaseStoreHelper
                                .sentChat(
                                    chatModal: chatModal,
                                    senderId: user?.email as String,
                                    receiverId: friendModel.email)
                                .then(
                                  (value) => chatController.clear(),
                                );
                          },
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                ],
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
