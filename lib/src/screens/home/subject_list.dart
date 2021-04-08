import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/screens/home/subject_tutors_list.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class TutorList extends StatefulWidget {
  @override
  _TutorListState createState() => _TutorListState();
}

class _TutorListState extends State<TutorList> {
  
  Position _position;
  double myLatitude, myLongitude;
  StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //var locationOptions =LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 4)
        .listen((Position position) {
      setState(() {
        print(position);
        myLatitude = position.latitude;
        myLongitude = position.longitude;
        print(myLatitude);
        print(myLongitude);
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
    print(qs.docs);
    return qs.docs;
  }

  @override
  Widget build(BuildContext context) {
    //returning list of subjects
    return Container(
      child: FutureBuilder(
        future: getSubjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Loading...'),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {

                  //get id for a particular subject
                  final String subjectId = snapshot.data[index].id;
                  return ListTile(
                    title: Text(snapshot.data[index].data()["subject_name"]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeachersList(subjectId: subjectId, myLatitude: myLatitude, myLongitude: myLatitude),
                              ));
                    },
                  );
                });
          }
        },
      ),
    );
  }
}
