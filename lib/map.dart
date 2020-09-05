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
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 10,
        cornerRadius: 20,
        shadowColor: Colors.grey.shade100,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        headerBuilder: (context, state) {
          return Container(
            margin: const EdgeInsets.only(left: 0.0, right: 0.0),
            height: 56,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              'My locations list',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Color(0xFF212121), fontSize: 16.0),
            ),
          );
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: 3000,
            child: Center(
              child: Material(
                child: InkWell(
                  // onTap: () => Navigator.pop(context, 'This is the result.'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ReorderableListView(
                      //padding: EdgeInsets.symmetric(horizontal: 10),
                      onReorder: (int oldIndex, int newIndex) {},
                      children: [
                        // for (final item in myItems)
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Color(0xFF212121),
                          elevation: 10,
                          key: ValueKey('dd'),
                          child: ListTile(
                            leading:
                                Icon(Icons.location_pin, color: Colors.white),
                            title: Text(
                              'Welcome to Flutter Tutorial.',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () => {},
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Color(0xFF212121),
                          elevation: 10,
                          key: ValueKey('dd'),
                          child: ListTile(
                            leading:
                                Icon(Icons.location_pin, color: Colors.white),
                            title: Text(
                              'Welcome to Flutter Tutorial.',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () => {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  //slide function
  void slideSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.50,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36), topRight: Radius.circular(36)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[Text('Row1')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[Text('Row2')],
            )
          ],
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
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Color(0xFF212121),
        accentColor: Colors.cyan[600],
      ),
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
            //   color: Colors.black.withRed(12),
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
                child: Icon(Icons.layers, size: 25, color: Colors.white),
                color: Colors.grey[850],
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
                color: Colors.grey[850],
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
                color: Colors.grey[850],
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
                color: Colors.grey[850],
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
                color: Colors.grey[850],
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
                ),
                color: Colors.grey[850],
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
                    //slideSheet();
                    showAsBottomSheet();
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,

                    height: 80, // Horizontal positioning
                    width: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red[300],
                          Colors.red[600],
                        ],
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
