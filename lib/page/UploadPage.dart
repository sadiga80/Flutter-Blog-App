import 'dart:io';

import 'package:blog_app/page/HomePage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File sampleImage;
  String statusMessage;
  String url;
  final formKey = new GlobalKey<FormState>();

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("Post Images");

      var timeKey = DateTime.now();

      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = imageUrl.toString();
      print("Image URL : $url");
      gotoHomePage();
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url) {
    var dbTimeKey = DateTime.now();

    var formatDate = DateFormat('MMM  d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference reference = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "description": statusMessage,
      "date": date,
      "time": time
    };

    reference.child("Posts").push().set(data);
  }

  void gotoHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Upload",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: sampleImage == null ? Text("Select an Image") : enableUpload(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Add Image',
          child: Center(child: Icon(Icons.add_a_photo)),
          backgroundColor: Colors.cyan,
        ),
      ),
    );
  }

  Widget enableUpload() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Image.file(
                sampleImage,
                height: 320.0,
                width: 640.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                validator: (value) {
                  return value.isEmpty ? "Description is required" : null;
                },
                onSaved: (value) {
                  return statusMessage = value;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                elevation: 12.0,
                child: Text("Add a post"),
                textColor: Colors.white,
                color: Colors.cyan,
                onPressed: uploadStatusImage,
              )
            ],
          ),
        ),
      ),
    );
  }
}
