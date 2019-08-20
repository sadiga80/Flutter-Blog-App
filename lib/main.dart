import 'package:blog_app/Authentication.dart';
import 'package:blog_app/Mapping.dart';
import 'package:flutter/material.dart';

void main() => runApp(BlogApp());

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blog App",
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.cyan,
          primaryColorDark: Colors.blue),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
