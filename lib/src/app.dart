import 'package:csappliedteacherapp/src/models/user.dart';
import 'package:csappliedteacherapp/src/screens/authenticate/login.dart';
import 'package:csappliedteacherapp/src/screens/wrapper.dart';
import 'package:csappliedteacherapp/src/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Myuser>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
        title: 'Welcome Myapp',
        theme: ThemeData(
          accentColor: Colors.orange,
          primarySwatch: Colors.blue,
        ),    
        //home: LoginScreen(), 
        home: Wrapper(),
      ),
    );
  }
}