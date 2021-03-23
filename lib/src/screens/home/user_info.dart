import 'package:csappliedteacherapp/src/models/tutor.dart';
import 'package:flutter/material.dart';

class UserInforTile extends StatelessWidget {
  final Tutor theUser;
  UserInforTile({this.theUser});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0 , 20.0, 0.0),
        child: ListTile(
          // leading: CircleAvatar(
          //   backgroundColor: Colors.black,
          // ),
          title: Text(theUser.fname),
        ),
      ),
    );
  }
}
