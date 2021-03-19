import 'package:flutter/material.dart';

class FavoriteTutorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('My favourite tutors',),
            //RaisedButton(onPressed: null)
          ],
        ),

      ),
    );
  }
}