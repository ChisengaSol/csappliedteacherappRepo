//import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/models/tutor.dart';
import 'package:csappliedteacherapp/src/screens/home/tutor_list.dart';
import 'package:csappliedteacherapp/src/screens/home/user_settingform.dart';
//import 'package:csappliedteacherapp/src/screens/home/subject_list.dart';
import 'package:csappliedteacherapp/src/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  //String fname, lname;
  @override
  Widget build(BuildContext context) {
    void _showSettingsPannel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: UserSettingsForm(),
            );
          });
    }

    return StreamProvider<List<Tutor>>.value(
      value: DatabaseService().tutors,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text("User Details"),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () => _showSettingsPannel(),
              icon: Icon(Icons.settings),
              label: Text("Settings"),
            )
          ],
        ),
        body: TheUsers(),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("The details"),
    //   ),
    //   body: Center(
    //     child: FutureBuilder(
    //         future: Provider.of(context).getCurrentUserInfo(),
    //         builder: (context, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.done)
    //             return Text("Loaading");
    //           return Text("$fname");
    //           // Column(
    //           //   children: <Widget>[
    //           //     Text(fname),
    //           //     //Text(lname),
    //           //   ],
    //           // );
    //         }),
    //   ),
    // );
  }

  //get current user info
  // Future getCurrentUserInfo() async {
  //   final fbUser = FirebaseAuth.instance.currentUser;
  //   if (fbUser != null) {
  //     await FirebaseFirestore.instance
  //         .collection('tutors')
  //         .doc(fbUser.uid)
  //         .get()
  //         .then((value) {
  //       fname = value.data()['fname'];
  //       lname = value.data()['lname'];
  //       print(fname);
  //     }).catchError((e) {
  //       print(e);
  //     });
  //   }
  // }
}
