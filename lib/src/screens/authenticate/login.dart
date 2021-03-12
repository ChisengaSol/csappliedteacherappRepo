import 'package:csappliedteacherapp/src/models/user.dart';
import 'package:csappliedteacherapp/src/screens/home.dart';
import 'package:csappliedteacherapp/src/screens/home/home.dart';
import 'package:csappliedteacherapp/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   String _email, _password;
//   final auth = FirebaseAuth.instance;

//   //create user object based on firebase user
//   Myuser _userFromFirebaseUser(User user) {
//     return user != null ? Myuser(uid: user.uid) : null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(hintText: 'Email'),
//               onChanged: (value) {
//                 setState(() {
//                   _email = value.trim();
//                 });
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               obscureText: true,
//               decoration: InputDecoration(hintText: 'Password'),
//               onChanged: (value) {
//                 setState(() {
//                   _password = value.trim();
//                 });
//               },
//             ),
//           ),
//           Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//             RaisedButton(
//                 child: Text('Signin'),
//                 onPressed: () {
//                   auth
//                       .signInWithEmailAndPassword(
//                           email: _email, password: _password)
//                       .then((_) {
//                     Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (context) => HomeScreen()));
//                   });
//                 }),
//             RaisedButton(
//               child: Text('Signup'),
//               onPressed: () {
//                 auth
//                     .createUserWithEmailAndPassword(
//                         email: _email, password: _password)
//                     .then((_) {
//                   Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (context) => HomeScreen()));
//                 });
//               },
//             )
//           ])
//         ],
//       ),
//     );
//   }
// }


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: RaisedButton(
            child: Text('Sign in Anonynous'),
            onPressed: () async {
              dynamic result = await _auth.signInAnon();
              if (result == null) {
                print("Error signing in");
              } else {
                print("Signed in successfully");
                print(result.uid);
              }
            }),
      ),
    );
  }
}

