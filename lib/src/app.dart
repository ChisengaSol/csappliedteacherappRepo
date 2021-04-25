import 'package:csappliedteacherapp/src/models/user.dart';
import 'package:csappliedteacherapp/src/screens/authenticate/helperfunctions.dart';
import 'package:csappliedteacherapp/src/screens/home/chatroom_screen.dart';
import 'package:csappliedteacherapp/src/screens/wrapper.dart';
import 'package:csappliedteacherapp/src/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool userIsLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

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
        home: userIsLoggedIn != null ? /* */ userIsLoggedIn ? Chatroom() : Wrapper() /* */ : Wrapper(),
      ),
    );
  }
}


