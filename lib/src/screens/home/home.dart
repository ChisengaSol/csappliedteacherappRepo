import 'package:csappliedteacherapp/src/screens/authenticate/login.dart';
import 'package:csappliedteacherapp/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: FlatButton(
      //       onPressed: () {
      //         auth.signOut();
      //         Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(builder: (context) => LoginScreen()));
      //       },
      //       child: Text('Log out')),
      // ),
      appBar: AppBar(
        title: Text('My Subjects'),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.logOut();
            },
            icon: Icon(Icons.person),
            label: Text('Logout'),
          )
        ],
      ),
    );
  }
}
