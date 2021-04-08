import 'package:csappliedteacherapp/src/services/auth.dart';
import 'package:csappliedteacherapp/src/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(

            // the sign up ui
            body: Padding(
            padding: EdgeInsets.all(25),
            child: Form(
              //associate global key with form
              key: _formKey,

              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Icon(
                        Icons.person_outline_outlined,
                        color: Colors.grey[300],
                        size: 140,
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Create new Account",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: TextFormField(
                          validator: (value) => value.isEmpty ? 'Enter an email' : null,
                          //updates state of email when user is typing
                          onChanged: (value) {
                            setState(() => email = value);
                          },
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.mail,
                              size: 30,
                            ),
                            labelText: "EMAIL",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          obscureText: true,
                          validator: (value) => value.length < 8 ? 'Enter atleast 8 characters' : null,
                          //updates state of password when user is typing
                          onChanged: (value) {
                            setState(() => password = value);
                          },
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 30,
                            ),
                            labelText: "PASSWORD",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.emailAndPwordReg(email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'Enter valid email';
                                  loading = false;
                                });
                              }
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text("Create Account"),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
    }
}

