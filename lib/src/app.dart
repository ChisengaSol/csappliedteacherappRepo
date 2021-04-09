import 'package:csappliedteacherapp/src/models/user.dart';
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
        debugShowCheckedModeBanner: false,
        title: 'Welcome Myapp',
        theme: ThemeData(
          accentColor: Colors.orange,
          primarySwatch: Colors.green,
        ),     
        home: Wrapper(),
      ),
    );
  }
}