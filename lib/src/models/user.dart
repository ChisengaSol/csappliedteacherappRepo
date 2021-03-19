class Myuser {
  final String uid;

  Myuser({this.uid});
}

class UserData {
  final String uid;
  final String fname;
  final String lname;
  final String gender;
  final String company;
  final String tutor_or_pupil;
  final String bio;

  UserData(
      {this.uid,
      this.fname,
      this.lname,
      this.gender,
      this.company,
      this.tutor_or_pupil,
      this.bio
      });
}
