import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/screens/home/subject_tutors_list.dart';
import 'package:csappliedteacherapp/src/services/auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import 'subject_search.dart';

class SubjectsList extends StatefulWidget {
  @override
  _SubjectsListState createState() => _SubjectsListState();
}

class _SubjectsListState extends State<SubjectsList> {
  final AuthService _auth = AuthService();

  //for the search
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizeValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      SubjectSearchService()
          .searchBySubject(value)
          .then((QuerySnapshot documents) {
        for (int i = 0; i < documents.docs.length; ++i) {
          queryResultSet.add(documents.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['subject_name'].startsWith(capitalizeValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                height: 55.0,
                margin: EdgeInsets.symmetric(horizontal: 18.0),
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15.0)),
                child: Center(
                  child: TextField(
                    onChanged: (val) {
                      initiateSearch(val);
                    },
                    decoration: InputDecoration(
                      hintText: "search for subject",
                      icon: Icon(
                        Icons.search,
                        size: 35.0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // GridView.count(
              //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
              //   crossAxisCount: 2,
              //   crossAxisSpacing: 4.0,
              //   mainAxisSpacing: 4.0,
              //   primary: false,
              //   shrinkWrap: true,
              //   children: tempSearchStore.map<Widget>((element) {
              //     return buildResultCard(element);
              //   }).toList(),
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
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
                                          myLongitude: myLongitude),
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
    );
  }

  buildResultCard(data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
        child: Center(
          child: Text(
            data['subject_name'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
