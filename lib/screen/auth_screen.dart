import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widget/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var _isLoading = false;
  void submitformData(
    String useremail,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential userCredential;
      if (isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(
          email: useremail,
          password: password,
        );
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: useremail,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user.uid)
            .set(
          {
            "username": username,
            "email": useremail,
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      var message = "";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.message != null) {
        message = e.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitformData, _isLoading),
    );
  }
}
