import 'package:csappliedteacherapp/src/screens/authenticate/helperfunctions.dart';
import 'package:csappliedteacherapp/src/screens/home/conversation_screen.dart';
import 'package:csappliedteacherapp/src/screens/home/search.dart';
import 'package:csappliedteacherapp/src/services/database.dart';
import 'package:csappliedteacherapp/src/shared/constants.dart';
import 'package:flutter/material.dart';

class Chatroom extends StatefulWidget {
  final String teacherId, pupilId;
  Chatroom({this.teacherId, this.pupilId});
  @override
  _ChatroomState createState() => _ChatroomState(teacherId, pupilId);
}

class _ChatroomState extends State<Chatroom> {
  String teacherId, pupilId;
  _ChatroomState(this.teacherId, this.pupilId);

  DatabaseService databaseService = new DatabaseService();

  Stream chatroomsStream;

  Widget chatroomList() {
    return StreamBuilder(
        stream: chatroomsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomsTile(snapshot.data.docs[index]
                        .data()["chatroomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myEmail, ""),
                        snapshot.data.docs[index]
                        .data()["chatroomId"],
                        );
                  },
                )
              : Container();
        });
  }

  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    databaseService.getChatrooms(Constants.myEmail).then((value) {
      setState(() {
        chatroomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IDs for chatroom"),
      ),
      //body: Text("TeacherId: " + teacherId + " Pupils Id: " + pupilId),
      body: chatroomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userEmail;
  final String chatroomId;

  ChatRoomsTile(this.userEmail, this.chatroomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationsScreen(chatroomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text("${userEmail.substring(0, 1)}"),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(userEmail),
          ],
        ),
      ),
    );
  }
}
