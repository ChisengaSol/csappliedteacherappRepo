import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //collection reference
  final CollectionReference subjectsCollection = FirebaseFirestore.instance.collection('subjects');
  
}
