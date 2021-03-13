/*This is a wrapper for login and signup */

//import 'package:cs_applied_project/src/screens/authenticate/sign_in.dart';
import 'package:csappliedteacherapp/src/screens/authenticate/login.dart';
import 'package:csappliedteacherapp/src/screens/authenticate/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  
  //function allows to toggle between signin and register forms
  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {

    if (showSignIn) {
      return LoginScreen(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
