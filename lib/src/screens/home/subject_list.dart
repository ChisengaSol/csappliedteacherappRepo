import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/screens/home/subject_tutors_list.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class SubjectsList extends StatefulWidget {
  @override
  _SubjectsListState createState() => _SubjectsListState();
}

class _SubjectsListState extends State<SubjectsList> {
  int _navCurrentIndex = 0;
  final tabs = [
    Center(
      child: Text("chats"),
    ),
    Center(
      child: Text("profile"),
    ),
  ];

  Position _position;
  double myLatitude, myLongitude;
  StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //on init of the app, get the location of the user
    //var locationOptions =LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      setState(() {
        print(position);
        myLatitude = position.latitude;
        myLongitude = position.longitude;
        _position = position;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _positionStream.cancel();
  }

  Future getSubjects() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qs = await firestore.collection("subjects").get();
    return qs.docs;
  }

  @override
  Widget build(BuildContext context) {
    //returning list of subjects
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              Container(
                width: double.infinity,
                height: 55.0,
                margin: EdgeInsets.symmetric(horizontal: 18.0),
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "search for subject",
                        icon: Icon(Icons.search, size: 35.0,),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
              ),
              SizedBox(height: 20.0,),
              Container(
                child: FutureBuilder(
                  future: getSubjects(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text('Loading...'),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            //get id for a particular subject
                            final String subjectId = snapshot.data[index].id;
                            return ListTile(
                              key: ValueKey("subjectsKey"),
                              leading: Icon(
                                Icons.book_outlined,
                                size: 25.0,
                              ),
                              title: Text(
                                snapshot.data[index]
                                    .data()["subject_name"]
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                size: 30.0,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeachersList(
                                          subjectId: subjectId,
                                          myLatitude: myLatitude,
                                          myLongitude: myLatitude),
                                    ));
                              },
                            );
                          });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navCurrentIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Messages',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.green,
          ),
        ],
        onTap: (index) {
          setState(() {
            _navCurrentIndex = index;
          });
        },
      ),
    );
  }
}
