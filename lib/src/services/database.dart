import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/models/tutor.dart';
import 'package:csappliedteacherapp/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      'userId': uid,
    });
  }

  //creating a sub-collection
  Future addSubjects(String subject) async {
    return await FirebaseFirestore.instance
        .collection('subjects')
        .doc(uid)
        .collection("tutor_subjects")
        .add({
      //add your data that you want to upload
      'subject': subject,
    });
  }

  //tutors list from snapshot
  List<Tutor> _tutotListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return Tutor(
        fname: e.data()['fname'] ?? '',
        lname: e.data()['lname'] ?? '',
        gender: e.data()['gender'] ?? '',
        company: e.data()['company'] ?? '',
        bio: e.data()['bio'] ?? '',
      );
    }).toList();
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      fname: snapshot.data()['fname'],
      lname: snapshot.data()['lname'],
      gender: snapshot.data()['gender'],
      company: snapshot.data()['company'],
      bio: snapshot.data()['bio'],
    );
  }

  //get tutors stream
  Stream<List<Tutor>> get tutors {
    return tutorsCollection.snapshots().map(_tutotListFromSnapshot);
    //return tutorsCollection.
  }

  //get user doc stream
  Stream<UserData> get userData {
    return tutorsCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //get user details

  //get user for search in chatting
  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: email)
        .get();
  }

  //upload user info for chats
  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  //
  createChatRoom(String chatroomId, chatroomMap) {
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomId)
        .set(chatroomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConvoMessages(String chatroomId, messageMap) {
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConvoMessages(String chatroomId) async {
    return await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatrooms(String userEmail) async{
    return await FirebaseFirestore.instance
        .collection('chatroom')
        .where('users', arrayContains: userEmail)
        .snapshots();
  }
}
