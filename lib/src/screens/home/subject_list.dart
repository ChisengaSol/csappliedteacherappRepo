import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/screens/home/subject_tutors_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorList extends StatefulWidget {
  @override
  _TutorListState createState() => _TutorListState();
}

class _TutorListState extends State<TutorList> {
  Future getSubjects() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qs = await firestore.collection("subjects").get();
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
                  return ListTile(
                    title: Text(snapshot.data[index].data()["subject_name"]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeachersList()));
                    },
                  );
                });
          }
        },
      ),
    );
  }
}
