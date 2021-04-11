import 'package:flutter/material.dart';

class Chatroom extends StatefulWidget {
  final String teacherId, pupilId;
  Chatroom({this.teacherId, this.pupilId});
  //Chatroom(this.teacherId, this.pupilId);
  @override
  _ChatroomState createState() => _ChatroomState(teacherId, pupilId);
}

class _ChatroomState extends State<Chatroom> {
  String teacherId, pupilId;
  _ChatroomState(this.teacherId, this.pupilId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IDs for chatroom"),
      ),
      body: Text("TeacherId: " + teacherId + " Pupils Id: " + pupilId),
    );
  }
}
