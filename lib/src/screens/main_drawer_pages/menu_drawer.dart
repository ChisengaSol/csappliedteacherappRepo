import 'package:csappliedteacherapp/src/screens/main_drawer_pages/favourite_tutor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authenticate/login.dart';
import 'info.dart';
import '../home/my_details_screen.dart';

class MainDrawer extends StatelessWidget {
    final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://xenforo.com/community/data/avatars/o/202/202502.jpg',
                        ),
                        fit: BoxFit.fill,
                      ), //it is NetworkImage because the image is being provided from the internet
                    ),
                  ),
                  Text(
                    'Tony Chisenga',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ) //username and email
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'My details',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailsScreen()),
              );
            }, //currently do nothing when tapped
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              'My favourite tutor',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteTutorsScreen()),
              );
            }, //currently do nothing when tapped
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'About',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoScreen()),
              );
            }, //currently do nothing when tapped
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text(
              'Log out',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            // onTap: () {
            //   auth.signOut();
            //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
            // } //currently do nothing when tapped
          ),
        ],
      ),
    );
  }
}
