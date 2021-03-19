import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/models/tutor.dart';
import 'package:csappliedteacherapp/src/screens/home/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TheUsers extends StatefulWidget {
  @override
  _TheUsersState createState() => _TheUsersState();
}

class _TheUsersState extends State<TheUsers> {
  @override
  Widget build(BuildContext context) {
    final theUsers = Provider.of<List<Tutor>>(context) ?? [];

    return ListView.builder(
        itemCount: theUsers.length,
        itemBuilder: (context, index) {
          return UserInforTile(theUser: theUsers[index]);
        });
  }
}
