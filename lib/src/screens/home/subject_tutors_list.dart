import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeachersList extends StatefulWidget {
  @override
  _TeachersListState createState() => _TeachersListState();
}

//get teachers
class _TeachersListState extends State<TeachersList> {
  Future getTeachersForSubject() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qs = await firestore.collection("teachers").get();
    return qs.docs;
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: FutureBuilder(
    //       future: getTeachersForSubject(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return Center(
    //             child: Text("Loading..."),
    //           );
    //         } else {
    //           return ListView.builder(
    //               itemCount: snapshot.data.length,
    //               itemBuilder: (context, index) {
    //                 return ListTile(
    //                   title: Text(snapshot.data()["firstName"]),
    //                 );
    //               });
    //         }
    //       }),
    // );
    return Scaffold(
      floatingActionButton: null,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('teachers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data.docs.map((document) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 6.0,
                  child: Text(document['firstName']),
                ),
              );
            }).toList(),
          );
        },
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
    return Container(
      child: Card(
        child: ListTile(
          title: Text(widget.teacher.data()["firstName"]),
        ),
      ),
    );
  }
}
