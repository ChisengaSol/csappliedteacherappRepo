import 'package:csappliedteacherapp/src/models/user.dart';
import 'package:csappliedteacherapp/src/screens/home.dart';
import 'package:csappliedteacherapp/src/screens/home/home.dart';
import 'package:csappliedteacherapp/src/services/auth.dart';
import 'package:csappliedteacherapp/src/shared/constants.dart';
import 'package:csappliedteacherapp/src/shared/loading.dart';
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
  final Function toggleView;
  LoginScreen({this.toggleView});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            onPressed: () {
              widget.toggleView();
            },
            label: Text('Register'),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          //associate global key with form
          key: _formKey,

          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (value) => value.isEmpty ? 'Enter an email' : null,
                //updates state of email when user is typing
                onChanged: (value) {
                  setState(() => email = value);
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value.length < 8 ? 'Enter atleast 8 characters' : null,

                //updates state of password when user is typing
                onChanged: (value) {
                  setState(() => password = value);
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result =
                        await _auth.emailAndPwordSignIn(email, password);
                    if (result == null) {
                      setState(() {
                        error = 'Sign in failed. Please check your credentials';
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
