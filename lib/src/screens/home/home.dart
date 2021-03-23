import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/models/tutor.dart';
import 'package:csappliedteacherapp/src/screens/authenticate/login.dart';
import 'package:csappliedteacherapp/src/screens/home/subject_list.dart';
import 'package:csappliedteacherapp/src/screens/home/subject_tutors_list.dart';
import 'package:csappliedteacherapp/src/screens/main_drawer_pages/menu_drawer.dart';
import 'package:csappliedteacherapp/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:csappliedteacherapp/src/services/database.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Tutor>>.value(
      value: DatabaseService().tutors,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text('I want a teacher for...'),
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
        drawer: Drawer(
          child: MainDrawer(),
        ),
        body: TutorList(),
        //body: TeachersList(),
      ),
    );
  }
}
