import 'dart:ffi';

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  final bool isLoading;
  final dynamic Function(
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = true;
  var userEmail = "";
  var userName = "";
  var password = "";
  void trySubmit() {
    final isValid = _formKey.currentState.validate();
    //keyboard hatane ke liye
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        userEmail,
        userName,
        password,
        isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                    ),
                    validator: (value) {
                      if (value.isEmpty || !value.contains("@")) {
                        return "please enter a valid email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userEmail = value;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey("username"),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return "please enter atleast 4 letter character";
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "Username"),
                      onSaved: (value) {
                        userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return "please enter 7 letter password";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "password"),
                    obscureText: true,
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: trySubmit,
                      child: Text(
                        isLogin ? "Login" : "signup",
                      ),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(isLogin
                            ? "create new account"
                            : "Already have an account"),
                        onPressed: () {
                          setState(
                            () {
                              isLogin = !isLogin;
                            },
                          );
                        }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
