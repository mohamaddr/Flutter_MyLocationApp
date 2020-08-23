import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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
  GoogleMapController controller;
  final Map<String, Marker> _markers = {};
  Completer<GoogleMapController> completer;
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
        // _markers[office.name] = marker;
      }
    });
  }

  void _currentLocation() async {
    //var controller = Completer<GoogleMapController>();

    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId('curr_loc'),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers['Current Location'] = marker;
    });
    print(currentLocation.latitude);
    print(currentLocation.longitude);

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude, currentLocation.latitude),
          zoom: 17.0,
        ),
      ),
    );
  }

  MapType _currentMapType = MapType.normal;
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              //myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: _currentMapType,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: const LatLng(0, 0),
                zoom: 3,
              ),
              markers: _markers.values.toSet(),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Align(
            //     alignment: Alignment.topRight,
            //     child: FloatingActionButton(
            //       onPressed: () => print('button pressed'),
            //       materialTapTargetSize: MaterialTapTargetSize.padded,
            //       backgroundColor: Colors.red[400],
            //       child: const Icon(Icons.map, size: 36.0),
            //     ),
            //   ),
            // ),
            // to customize the position of the weidght, we use Positioned
            Positioned(
              bottom: 300,
              height: 70, // Horizontal positioning
              width: 70,
              child: RaisedButton(
                elevation: 17.0,
                padding: const EdgeInsets.all(16.0),
                onPressed: () {
                  _onMapTypeButtonPressed();
                },
                child: Icon(
                  Icons.layers,
                  size: 25,
                ),
                color: Colors.red[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(36.0),
                    bottomRight: Radius.circular(36.0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              height: 70, // Horizontal positioning
              width: 70,
              child: RaisedButton(
                elevation: 20.0,
                padding: const EdgeInsets.all(16.0),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  size: 25,
                ),
                color: Colors.red[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(36.0),
                    bottomRight: Radius.circular(36.0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              height: 70, // Horizontal positioning
              width: 70,
              right: 0,
              child: RaisedButton(
                elevation: 20.0,
                padding: const EdgeInsets.all(16.0),
                onPressed: _currentLocation,
                child: Icon(
                  Icons.location_on,
                  size: 25,
                ),
                color: Colors.red[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36.0),
                    bottomLeft: Radius.circular(36.0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              height: 70, // Horizontal positioning
              width: 70,
              right: 0,
              child: RaisedButton(
                elevation: 20.0,
                padding: const EdgeInsets.all(16.0),
                onPressed: () {},
                child: Icon(
                  Icons.search,
                  size: 25,
                ),
                color: Colors.red[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36.0),
                    bottomLeft: Radius.circular(36.0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 300,
              height: 70, // Horizontal positioning
              width: 70,
              right: 0,
              child: RaisedButton(
                elevation: 20.0,
                padding: const EdgeInsets.all(16.0),
                onPressed: () {},
                child: Icon(
                  Icons.directions,
                  size: 25,
                  // color: Colors.white,
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36.0),
                    bottomLeft: Radius.circular(36.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
