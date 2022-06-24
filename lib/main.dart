import 'package:flutter/material.dart';
import "./screen/chat_screen.dart";
import 'package:firebase_core/firebase_core.dart';
import './screen/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

// void main() {
//   runApp(MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Widget usercredential = AuthScreen();
  // Widget userdetail() {
  //   FirebaseAuth.instance.authStateChanges().listen((User user) {
  //     if (user == null) {
  //       print(user);
  //     } else {
  //       print(user);
  //       usercredential = ChatScreen();
  //     }
  //   });
  //   return usercredential;
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.pink,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          )),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot);
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
