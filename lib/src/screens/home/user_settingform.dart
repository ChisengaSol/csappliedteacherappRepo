import 'package:csappliedteacherapp/src/models/user.dart';
import 'package:csappliedteacherapp/src/services/database.dart';
import 'package:csappliedteacherapp/src/shared/constants.dart';
import 'package:csappliedteacherapp/src/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettingsForm extends StatefulWidget {
  @override
  _UserSettingsFormState createState() => _UserSettingsFormState();
}

class _UserSettingsFormState extends State<UserSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> tutorOrPupil = ['Tutor', 'Pupil'];
  final List<String> genders = ['Male', 'Female'];

  //form values
  String _currentfname;
  String _currentlname;
  String _currentGender;
  String _currentCompany;
  String _currentTutor_or_pupil;
  String _currentBio;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Myuser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          //check if snapshot has data from db
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Update your user details",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    TextFormField(
                      initialValue: userData.fname,
                      decoration: textInputDecoration,
                      validator: (value) =>
                          value.isEmpty ? 'Please enter first name' : null,
                      onChanged: (val) =>
                          setState(() => _currentfname = val),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    TextFormField(
                      initialValue: userData.lname,
                      decoration: textInputDecoration,
                      validator: (value) =>
                          value.isEmpty ? 'Please enter last name' : null,
                      onChanged: (val) =>
                          setState(() => _currentlname = val),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    //gender dropdown
                    DropdownButtonFormField(
                        decoration: textInputDecoration,

                        //value of the dropdown
                        //value: _currentGender ?? userData.gender,
                        items: genders.map((gender) {
                          return DropdownMenuItem(
                            //tracks the value the user selects(male or female)
                            value: gender,
                            child: new Text("$gender"),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _currentGender = val;
                            //genders.clear();
                          });
                        } // => setState(() => _currentGender = value),
                        ),
                    TextFormField(
                      initialValue: userData.company,
                      decoration: textInputDecoration,
                      validator: (val) => val.isEmpty
                          ? 'Please enter school or company'
                          : null,
                      onChanged: (value) =>
                          setState(() => _currentCompany = value),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),

                    //tutor or pupil dropdown
                    DropdownButtonFormField(
                      decoration: textInputDecoration,

                      //value of the dropdown
                      //value: _currentTutor_or_pupil ?? userData.tutor_or_pupil,
                      items: tutorOrPupil.map((status) {
                        return DropdownMenuItem(
                          //tracks the value the user selects(male or female)
                          value: status,
                          child: Text("$status"),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _currentTutor_or_pupil = val),
                    ),
                    TextFormField(
                      initialValue: userData.bio,
                      decoration: textInputDecoration,
                      validator: (val) =>
                          val.isEmpty ? 'Please enter bio' : null,
                      onChanged: (val) => setState(() => _currentBio = val),
                    ),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await DatabaseService(uid: user.uid)
                                .updateTutorData(
                              _currentfname ?? userData.fname,
                              _currentlname ?? userData.lname,
                              _currentGender ?? userData.gender,
                              _currentCompany ?? userData.company,
                              _currentTutor_or_pupil ?? userData.tutor_or_pupil,
                              _currentBio ?? userData.bio,
                            );
                            Navigator.pop(context);
                          }
                        }),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
