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
    // return Scaffold(
    // floatingActionButton: null,
    // body: StreamBuilder(
    //   stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    //     if(!snapshot.hasData){
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //     return ListView(
    //       children: snapshot.data.docs.map((document){
    //         return Center(
    //           child: Container(
    //             width: MediaQuery.of(context).size.width / 1.2,
    //             height: MediaQuery.of(context).size.height / 6.0,
    //             child: Text(document['subject_name']),
    //           ),
    //         );
    //       }).toList(),
    //     );
    //   },
    // ),

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
                     // return TeachersList();
                    },
                  );
                });
          }
        },
      ),
    );
  }
}
