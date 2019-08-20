import 'package:blog_app/Authentication.dart';
import 'package:blog_app/component/DialogBox.dart';
import 'package:flutter/material.dart';

enum FormType { login, Register }

class LoginRegisterPage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  LoginRegisterPage({this.auth, this.onSignedIn});

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  DialogBox dialogBox = new DialogBox();

  final formKey = GlobalKey<FormState>();
  FormType formType = FormType.login;
  String email = "";
  String password = "";

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (formType == FormType.login) {
          String userId = await widget.auth.signIn(email, password);
//          dialogBox.information(
//              context, "Congrats", "You have signedIn successfully");
          print("login user ID : $userId");
        } else {
          String userId = await widget.auth.signUp(email, password);
//          dialogBox.information(context, "Congragts",
//              "Your account have been created successfully");
          print("Register user ID : $userId");
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, "Error", e.toString());
        print("Error:  ${e.toString()}");
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();

    setState(() {
      formType = FormType.Register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();

    setState(() {
      formType = FormType.login;
    });
  }

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 8.0,
      ),
      logo(),
      SizedBox(
        height: 16.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Email"),
        validator: (value) {
          return value.isEmpty ? 'Email is required' : null;
        },
        onSaved: (value) {
          email = value;
        },
      ),
      SizedBox(
        height: 8.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Password"),
        obscureText: true,
        validator: (value) {
          return value.isEmpty ? 'Password is required' : null;
        },
        onSaved: (value) {
          password = value;
        },
      ),
      SizedBox(
        height: 16.0,
      ),
    ];
  }

  List<Widget> createButtons() {
    if (formType == FormType.login) {
      return [
        RaisedButton(
          color: Colors.blue[300],
          child: Text(
            "Login",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            "Do not have an account? Create Account ?",
            style: TextStyle(fontSize: 14, color: Colors.blueAccent),
          ),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          color: Colors.blue[300],
          child: Text(
            "Create Account",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            "Already have an account? Login",
            style: TextStyle(fontSize: 14, color: Colors.blueAccent),
          ),
          onPressed: moveToLogin,
        ),
      ];
    }
  }

  Hero logo() {
    return Hero(
      tag: "",
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 120.0,
        child: Image.asset('assets/images/blog-logo.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blog App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createInputs() + createButtons(),
              )),
        ),
      ),
    );
  }
}
