import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectSearchService {
  searchBySubject(String searchField) {
    return FirebaseFirestore.instance
        .collection('subjects')
        .where('searchkey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }
}
