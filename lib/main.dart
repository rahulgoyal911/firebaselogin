import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  String myText = null;
  final DocumentReference documentReference =
      Firestore.instance.document("myData/dummy");

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken);
    print("User Name: ${user.displayName}");
    return user;
  }

  void _signOut() {
    googleSignIn.signOut();
    print("userSignedOut");
  }

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "Rahul Goyal",
      "desc": "Flutter Developer"
    };
    documentReference.setData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }

  void _update() {
    Map<String, String> data = <String, String>{
      "name": "Rahul Goyal updated",
      "desc": "Flutter Developer updated"
    };
    documentReference.updateData(data).whenComplete(() {
      print("Document Updated");
    }).catchError((e) => print(e));
  }

  void _delete() {
    documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
      setState(() {});
    }).catchError((e) => print(e));
  }

  void _fetch() {
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myText = datasnapshot.data['desc'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Firebase Demo"),
        ),
        body: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new RaisedButton(
                  onPressed: () => _signIn()
                      .then((FirebaseUser user) => print(user))
                      .catchError((e) => print(e)),
                  child: new Text("Sign in"),
                  color: Colors.green,
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                ),
                new RaisedButton(
                  onPressed: () => _signOut(),
                  child: new Text("Sign Out"),
                  color: Colors.red,
                ),
                new RaisedButton(
                  onPressed: () => _add(),
                  child: new Text("Add"),
                  color: Colors.cyan,
                ),
                new RaisedButton(
                  onPressed: () => _update(),
                  child: new Text("Update"),
                  color: Colors.lightBlue,
                ),
                new RaisedButton(
                  onPressed: () => _delete(),
                  child: new Text("Delete"),
                  color: Colors.orange,
                ),
                new RaisedButton(
                  onPressed: () => _fetch(),
                  child: new Text("Fetch"),
                  color: Colors.lime,
                ),
                myText == null
                    ? new Container()
                    : new Text(
                        myText,
                        style: new TextStyle(fontSize: 20.0),
                      )
              ],
            )));
  }
}
