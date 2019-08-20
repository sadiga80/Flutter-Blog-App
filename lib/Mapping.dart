import 'package:blog_app/Authentication.dart';
import 'package:blog_app/page/HomePage.dart';
import 'package:blog_app/page/LoginRegisterPage.dart';
import 'package:flutter/material.dart';

enum AuthSatus { notSignedIn, signedIn }

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;
  MappingPage({this.auth});
  @override
  _MappingPageState createState() => _MappingPageState();
}

class _MappingPageState extends State<MappingPage> {
  AuthSatus authStatus = AuthSatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        authStatus =
            firebaseUserId == null ? AuthSatus.notSignedIn : AuthSatus.signedIn;
      });
    });
  }

  void signedIn() {
    setState(() {
      authStatus = AuthSatus.signedIn;
    });
  }

  void signedOut() {
    setState(() {
      authStatus = AuthSatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthSatus.notSignedIn:
        return LoginRegisterPage(auth: widget.auth, onSignedIn: signedIn);
      case AuthSatus.signedIn:
        return HomePage(auth: widget.auth, onSignedOut: signedOut);
    }
    return null;
  }
}
