import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TrackLocation extends StatefulWidget {
  final String longitude;
  final String latitude;
  TrackLocation({this.latitude, this.longitude});
  @override
  _TrackLocationState createState() => _TrackLocationState();
}

class _TrackLocationState extends State<TrackLocation> {
  Position _position;
  double myLatitude, myLongitude;

  StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //var locationOptions =LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 4)
        .listen((Position position) {
      setState(() {
        print(position);
        myLatitude = position.latitude;
        myLongitude = position.longitude;
        print(myLatitude);
        print(myLongitude);
        _position = position;

      });
    });
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            "Location ${_position?.latitude ?? '-'},${_position?.longitude ?? '-'}"),
      ),
    );
  }
}
