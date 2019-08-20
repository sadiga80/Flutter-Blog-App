import 'package:blog_app/Authentication.dart';
import 'package:blog_app/Model/Posts.dart';
import 'package:blog_app/page/UploadPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  HomePage({this.auth, this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postsList = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;

      postsList.clear();

      for (var indivisualKey in KEYS) {
        Posts posts = Posts(
          DATA[indivisualKey]['date'],
          DATA[indivisualKey]['image'],
          DATA[indivisualKey]['description'],
          DATA[indivisualKey]['time'],
        );
        postsList.add(posts);
      }

      setState(() {
        print("Total Posts : ${postsList.length}");
      });
    });
  }

  Widget postsUI(String date, String image, String description, String time) {
    return Card(
      elevation: 12.0,
      margin: EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Image.network(
              image,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: postsList.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (_, index) {
                    return postsUI(
                        postsList[index].date,
                        postsList[index].image,
                        postsList[index].description,
                        postsList[index].time);
                  },
                  itemCount: postsList.length,
                ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue[300],
          child: Container(
            height: 70.0,
            margin: EdgeInsets.only(left: 70, right: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add_a_photo),
                        iconSize: 32,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return UploadPage();
                            }),
                          );
                        }),
                    Text("Add Post",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400))
                  ],
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.exit_to_app),
                        iconSize: 32,
                        color: Colors.white,
                        onPressed: logout),
                    Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logout() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
