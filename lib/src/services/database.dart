import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/models/tutor.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference tutorsCollection =
      FirebaseFirestore.instance.collection('tutors');

  Future updateTutorData(String fname, String lname, String gender,
      String company, String bio) async {
    return await tutorsCollection.doc(uid).set({
      'fname': fname,
      'lname': lname,
      'gender': gender,
      'company': company,
      'bio': bio,
    });
  }

  //tutors list from snapshot
  // List<Tutor> _tutotListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((e) {
  //     return Tutor(
  //       fname: e.data['fname'] ?? '',
  //       lname: e.data['lname'] ?? '',
  //       gender: e.data['gender'] ?? '',
  //       company: e.data['company'] ?? '',
  //       bio: e.data['bio'] ?? '',
  //     );
  //   }).toList();
  // }

  //get tutors stream
  Stream<QuerySnapshot> get tutors {
    return tutorsCollection.snapshots();
  }
}
