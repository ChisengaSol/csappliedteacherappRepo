import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeachersList extends StatefulWidget {
  //getting the longitudes and latitudes to find the distance
  // String long, lat;
  // TeachersList({this.lat, this.long});
  @override
  _TeachersListState createState() =>
      _TeachersListState(); //added lat and long
}

//get teachers
class _TeachersListState extends State<TeachersList> {
  String long, lat;
  _TeachersListState();//added this code

  Future _data;

  Future getTeachersForSubject() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qs = await firestore.collection("teachers").get();
    return qs.docs;
  }

  //to navigate to teacher details
  navigateToDetails(DocumentSnapshot teacher) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TeacherDetails(
                  teacher: teacher,
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = getTeachersForSubject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data[index].data()["firstName"] + ' ' + snapshot.data[index].data()["lastName"] ),
                      subtitle: Text("200 meters away"),
                      onTap: () => navigateToDetails(snapshot.data[index]),
                    );
                  });
            }
          },
        ),
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
          subtitle: Text(widget.teacher.data()["lastName"]),
        ),
      ),
    );
  }
}
