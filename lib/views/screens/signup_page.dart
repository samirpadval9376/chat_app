import 'dart:developer';

import 'package:chat_app/controllers/firebase_controller.dart';
import 'package:chat_app/modals/user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/firebase_auth_helper.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  FirebaseController controller = Get.put(FirebaseController());

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Chat App",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: email,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter the Email";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Enter the Email",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: password,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter the Password";
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Enter the Password",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: confirmPassword,
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter the Password";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Confirm the Password",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    UserModal userModal =
                        UserModal(email: email.text, password: password.text);

                    if (formKey.currentState!.validate()) {
                      if (password.text == confirmPassword.text) {
                        Auth.auth
                            .getUserWithEmailAndPassword(userModal: userModal)
                            .then(
                              (value) =>
                                  Navigator.of(context).pushNamed('/').then(
                                        (value) => ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text("Successful"),
                                          ),
                                        ),
                                      ),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Unsuccessful"),
                          ),
                        );
                      }
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
