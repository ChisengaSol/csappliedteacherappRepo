import 'package:csappliedteacherapp/src/models/user.dart';
import 'package:csappliedteacherapp/src/screens/authenticate/helperfunctions.dart';
import 'package:csappliedteacherapp/src/screens/home/chatroom_screen.dart';
import 'package:csappliedteacherapp/src/screens/home/my_details_screen.dart';
import 'package:csappliedteacherapp/src/screens/home/subject_list.dart';
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

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;
  final List<Widget> _list = [
    SubjectsList(),
    Chatroom(),
    DetailsScreen(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _list[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        child: BottomNavigationBar(
          iconSize: 40,
          selectedIconTheme: IconThemeData(color: Colors.green),
          unselectedIconTheme: IconThemeData(color: Colors.black12),
          currentIndex: _currentIndex,
          onTap: onTappedBar,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.home)),
              title: Text(
                "Home",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.chat_bubble)),
              title: Text(
                "Messages",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.person)),
              title: Text(
                "Profile",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}