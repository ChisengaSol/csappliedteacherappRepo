import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/screens/home/chatroom_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;

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
    // TODO: implement initState
    super.initState();
    _data = getTeachersForSubject();
  }

  //function to calculate distance between two points in kilometers
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available teachers..."),
      ),
      body: Container(
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
                        myLatitude, myLongitude, teacherLat, teacherLong);

                    return ListTile(
                      // title: Text(snapshot.data[index].data()["firstName"] +
                      //     ' ' +
                      //     snapshot.data[index].data()["lastName"]),
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
                  });
            }
          },
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

class _TeacherDetailsState extends State<TeacherDetails> {
  @override
  Widget build(BuildContext context) {
    String teacherId = widget.teacher.data()["teacherId"];
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    String pupilId = user.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("About " + widget.teacher.data()["teacherName"]),
      ),
      body: Column(
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
          Center(
            child: Text(
              "Name: " + widget.teacher.data()["teacherName"],
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Email: " + widget.teacher.data()["teachermail"],
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Gender: " + widget.teacher.data()["teachersex"],
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "School: " + widget.teacher.data()["teacherschool"],
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Bio: " + widget.teacher.data()["teacherbio"],
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 55,
            width: double.infinity,
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Chatroom(teacherId: teacherId,pupilId: pupilId)));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
    );
  }
}
