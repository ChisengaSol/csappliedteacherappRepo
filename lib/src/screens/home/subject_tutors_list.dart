import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/screens/home/chatroom_screen.dart';
import 'package:csappliedteacherapp/src/services/database.dart';
import 'package:csappliedteacherapp/src/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'conversation_screen.dart';
import 'search.dart';
import 'package:flutter/material.dart';
import 'dart:math' show atan2, cos, pi, sin, sqrt;

class TeachersList extends StatefulWidget {
  final String subjectId;
  final double myLatitude, myLongitude;
  TeachersList({this.subjectId, this.myLatitude, this.myLongitude});

  @override
  _TeachersListState createState() =>
      _TeachersListState(subjectId, myLatitude, myLongitude);
}

//get teachers
class _TeachersListState extends State<TeachersList> {
  String subjectId;
  double myLatitude, myLongitude;

  _TeachersListState(
      this.subjectId, this.myLatitude, this.myLongitude); //added this code

  Future _data;

  Future getTeachersForSubject() async {
    var firestore = FirebaseFirestore.instance;

    QuerySnapshot qs = await firestore
        .collection("subjects")
        .doc(subjectId)
        .collection('teachersubject')
        .get();
    return qs.docs;
  }

  //to navigate to teacher details
  navigateToDetails(DocumentSnapshot teacher) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TeacherDetails(
                  teacher: teacher,
                )));
  }

  @override
  void initState() {
    super.initState();
    _data = getTeachersForSubject();
  }

  //function to convert to radians
  double toRad(double value) {
    return value * pi / 180;
  }

  //function to calculate distance between two points in kilometers
  double calculateDistance(lat1, lon1, lat2, lon2) {
    // var p = 0.017453292519943295;
    // var c = cos;
    // var a = 0.5 -
    //     c((lat2 - lat1) * p) / 2 +
    //     c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    // return 12742 * asin(sqrt(a));
    double latDistance = toRad(lat2 - lat1);
    double longDistance = toRad(lon2 - lon1);
    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(toRad(lat1)) *
            cos(toRad(lat2)) *
            sin(longDistance / 2) *
            sin(longDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double R = 6371.0088; // Earth's radius Km
    final double distance = R * c;
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available teachers..."),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Container(
          child: FutureBuilder(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading..."),
                );
              } else {
                //variables to hold teacher coords
                double teacherLong, teacherLat;
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      //variables to hold teacher cordinates
                      teacherLat = double.parse(
                          snapshot.data[index].data()["teacher_lat"]);
                      teacherLong = double.parse(
                          snapshot.data[index].data()["teacher_long"]);

                      //variable to store distance between a pupil and a teacher
                      double teacherDistance = calculateDistance(
                          this.myLatitude,
                          this.myLongitude,
                          teacherLat,
                          teacherLong);

                      //returning teachers only within the range of 5Km
                      if (teacherDistance < 4) {
                        return ListTile(
                          key: ValueKey("teachersKey"),
                          leading: Image(
                            image: NetworkImage(
                                'https://xenforo.com/community/data/avatars/o/202/202502.jpg'),
                          ),
                          title: Text(
                            snapshot.data[index].data()["teacherName"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          subtitle: Text(
                              "${teacherDistance.toStringAsFixed(2)} Km away from your location"),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: 30.0,
                          ),
                          onTap: () => navigateToDetails(snapshot.data[index]),
                        );
                      }
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}

//shows details for a particular teacher
class TeacherDetails extends StatefulWidget {
  final DocumentSnapshot teacher;
  TeacherDetails({this.teacher});
  @override
  _TeacherDetailsState createState() => _TeacherDetailsState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser;
final uemail = user.email;

class _TeacherDetailsState extends State<TeacherDetails> {
  //create chatroom, send user to conversation screen
  createChatroomAndStartConvo({String userEmail}) {
    if (userEmail != uemail) {
      String chatroomId = getChatrromId(userEmail, uemail);

      List<String> users = [userEmail, uemail];
      Map<String, dynamic> chatroomMap = {
        "users": users,
        "chatroomId": chatroomId,
      };
      DatabaseService().createChatRoom(chatroomId, chatroomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationsScreen(chatroomId)));
    } else {
      print("You cant send messages to yourself");
    }
    // print(user.email);
    // print(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    //teacherId = widget.teacher.data()["teacherId"];
    String teacherEmail = widget.teacher.data()["teachermail"];
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    String pupilId = user.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("About " + widget.teacher.data()["teacherName"]),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(
                top: 30,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://xenforo.com/community/data/avatars/o/202/202502.jpg',
                  ),
                  fit: BoxFit.fill,
                ), //it is NetworkImage because the image is being provided from the internet
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    widget.teacher.data()["teacherName"],
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.mail,
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    widget.teacher.data()["teachermail"],
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.school,
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    widget.teacher.data()["teacherschool"],
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            // Container(
            //   width: double.infinity,
            //   margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            //   decoration: BoxDecoration(
            //     color: Colors.green[100],
            //     borderRadius: BorderRadius.circular(8)
            //   ),
            //   child:
            //   Text(
            //     widget.teacher.data()["teacherbio"],
            //     style: TextStyle(
            //       fontSize: 20.0,

            //     ),
            //   ),
            // ),
            Container(
              height: 60,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              alignment: Alignment.center,
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                // onPressed: () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => Chatroom(
                //               teacherId: teacherId, pupilId: pupilId)));
                // },
                onPressed: () {
                  // createChatroomAndStartConvo();
                  createChatroomAndStartConvo(
                    userEmail: teacherEmail,
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  "Connect",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

getChatrromId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
