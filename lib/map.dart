import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';

import 'SideMenu.dart';

import 'locations.dart' as locations;

class MyMap extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//final LatLng _center = const LatLng(57.7089, 11.9746);

class _MyAppState extends State<MyMap> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),

        // floatingActionButton: Container(
        //   height: 400,
        //   width: 70,
        //   child: Align(
        //     alignment: Alignment.centerLeft,
        //     child: Transform.scale(
        //       scale: 1.8,
        //       child: RaisedButton(
        //         elevation: 15.0,
        //         onPressed: () {
        //           _scaffoldKey.currentState.openDrawer();
        //         },
        //         child: Icon(
        //           Icons.menu,
        //           size: 23,
        //         ),
        //         color: Colors.red[400],
        //         padding: EdgeInsets.only(left: (35)),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.only(
        //             topRight: Radius.circular(30.0),
        //             bottomRight: Radius.circular(30.0),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        //  decoration: BoxDecoration(
        //       borderRadius: BorderRadius.only(
        //           topRight: Radius.circular(35.0),
        //           bottomRight: Radius.circular(35.0)),
        //       border: Border.all(
        //           width: 3, color: Colors.green, style: BorderStyle.solid)),

        //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        // body:GoogleMap(
        //   onMapCreated: _onMapCreated,
        //   initialCameraPosition: CameraPosition(
        //     target: const LatLng(0, 0),
        //     zoom: 2,
        //   ),
        //   markers: _markers.values.toSet(),

        // ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: const LatLng(0, 0),
                zoom: 2,
              ),
              markers: _markers.values.toSet(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  onPressed: () => print('button pressed'),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.red[400],
                  child: const Icon(Icons.map, size: 36.0),
                ),
              ),
            ),
            // to customize the position of the weidght, we use Positioned
            Positioned(
              bottom: 210,
              height: 75, // Horizontal positioning
              width: 75,
              child: RaisedButton(
                elevation: 15.0,
                padding: const EdgeInsets.all(16.0),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  size: 20,
                ),
                color: Colors.red[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
