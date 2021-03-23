import 'package:csappliedteacherapp/src/services/auth.dart';
import 'package:csappliedteacherapp/src/shared/constants.dart';
import 'package:csappliedteacherapp/src/shared/loading.dart';
import 'package:flutter/material.dart';

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
      //backgroundColor: Colors.blue[100],
      appBar: AppBar(
        //backgroundColor: Colors.blue[400],
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
                color: Colors.blue[400],
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
