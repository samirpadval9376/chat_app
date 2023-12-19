import 'package:chat_app/helpers/firebase_auth_helper.dart';
import 'package:chat_app/helpers/firestore_helper.dart';
import 'package:chat_app/views/screens/chat_page.dart';
import 'package:chat_app/views/screens/home_page.dart';
import 'package:chat_app/views/screens/login_page.dart';
import 'package:chat_app/views/screens/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute:
          Auth.auth.firebaseAuth.currentUser != null ? 'home_page' : '/',
      routes: {
        '/': (context) => LoginPage(),
        'signup_page': (context) => SignupPage(),
        'home_page': (context) => HomePage(),
        'chat_page': (context) => ChatPage(),
      },
    );
  }
}
