import 'package:chat_app/views/screens/home_page.dart';
import 'package:chat_app/views/screens/login_page.dart';
import 'package:chat_app/views/screens/signup_page.dart';
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
      routes: {
        '/': (context) => LoginPage(),
        'signup_page': (context) => SignupPage(),
        'home_page': (context) => HomePage(),
      },
    );
  }
}
