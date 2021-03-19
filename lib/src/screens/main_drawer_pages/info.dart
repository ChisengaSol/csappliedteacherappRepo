import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('about this app',),
            //RaisedButton(onPressed: null)
          ],
        ),

      ),
    );
  }
}