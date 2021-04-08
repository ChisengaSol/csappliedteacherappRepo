import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/screens/home/subject_tutors_list.dart';
import 'package:csappliedteacherapp/src/screens/home/track_location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// final CollectionReference subjectsRef =
//     FirebaseFirestore.instance.collection('subjects');

class TutorList extends StatefulWidget {
  @override
  _TutorListState createState() => _TutorListState();
}

class _TutorListState extends State<TutorList> {
  /////////added
  // @override
  // void initState() {
  //   //getSubjectTeachers();
  //   getSubjectsById();
  //   super.initState();
  // }
  //getting all the subjects
  // getSubjectTeachers() {
  //   subjectsRef.get().then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       print(doc.data());
  //       print(doc.id);
  //     });
  //   });
  // }
  //
  // getting subject by id
  // getSubjectsById(){

  //   subjectsRef.doc()
  // }

  ///////////
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
        //future: getSubjectTeachers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Loading...'),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final String subjectId = snapshot.data[index].id;
                  return ListTile(
                    title: Text(subjectId),
                    //title: Text(snapshot.data[index].data()["subject_name"]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeachersList(subjectId: subjectId),
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
