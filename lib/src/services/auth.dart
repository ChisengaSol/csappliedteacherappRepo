import 'package:csappliedteacherapp/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  Myuser _userFromFirebaseUser(User user) {
    return user != null ? Myuser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<Myuser> get user {
    //mapping a stream of users to our custom Myuser class
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
        //.map(_userFromFirebaseUser);
  }

  //sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User user = userCredential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sing in with email and password

  //register with email and password

  //sign out
}
