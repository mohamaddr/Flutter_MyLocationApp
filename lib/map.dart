import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'SideMenu.dart';

import 'locations.dart' as locations;

class MyMap extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyMap> with TickerProviderStateMixin {
  final Map<String, Marker> _markers = {};

  GoogleMapController mapController;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
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

// Currentlocation
  void _currentLocation() async {
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

    // Now move the camera postion to currentLocations
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 15.0,
          tilt: 50.0,
          bearing: 45.0,
        ),
      ),
    );
  }

  void showAsBottomSheet() async {
    final result = await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return Container(
            height: 700,
            child: Center(
              child: Material(
                child: InkWell(
                  onTap: () => Navigator.pop(context, 'This is the result.'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'This is the content of the sheet',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        headerBuilder: (context, state) {
          return Container(
            height: 40,
            width: double.infinity,
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_upward,
              size: 15,
            ),
          );
        },
      );
    });

    print(result); // This is the result.
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
            // Without a button
            // SlidingSheet(
            //   color: Colors.blueAccent,
            //   elevation: 8,
            //   cornerRadius: 16,
            //   snapSpec: const SnapSpec(
            //     snap: true,
            //     snappings: [112, 400, double.infinity],
            //     positioning: SnapPositioning.pixelOffset,
            //   ),
            //   builder: (context, state) {
            //     return Container(
            //       height: 500,
            //       child: Center(
            //         child: Text(
            //           'This is the content of the sheet',
            //           style: Theme.of(context).textTheme.body1,
            //         ),
            //       ),
            //     );
            //   },
            //   headerBuilder: (context, state) {
            //     return Container(
            //       height: 40,
            //       width: double.infinity,
            //       alignment: Alignment.center,
            //     );
            //   },

            //   // footerBuilder: (context, state) {
            //   //   return Container(
            //   //     height: 56,
            //   //     width: double.infinity,
            //   //     color: Colors.yellow,
            //   //     alignment: Alignment.center,
            //   //     child: Text(
            //   //       'This is the footer',
            //   //       style: Theme.of(context)
            //   //           .textTheme
            //   //           .body1
            //   //           .copyWith(color: Colors.black),
            //   //     ),
            //   //   );
            //   // },
            // ),
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
                // color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36.0),
                    bottomLeft: Radius.circular(36.0),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  elevation: 90.0,
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () {
                    showAsBottomSheet();
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,

                    height: 80, // Horizontal positioning
                    width: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red[400], Colors.red[300]],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(300.0),
                        topRight: Radius.circular(300.0),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Icon(
                      Icons.explore,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(300.0),
                      topRight: Radius.circular(300.0),
                    ),
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
