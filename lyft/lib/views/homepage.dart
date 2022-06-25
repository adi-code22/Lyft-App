import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lyft/views/bookingPage.dart';
import 'package:lyft/views/travelCard.dart';
import 'package:permission_handler/permission_handler.dart';
import 'directions_model.dart';
import 'directions_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(11.7617503, 75.5143856),
    zoom: 11.5,
  );

  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Marker? _initial = Marker(markerId: MarkerId("Initial"));
  Directions? _info;

  @override
  void dispose() {
    //_googleMapController!.dispose();
    super.dispose();
  }

  Placemark place = Placemark();

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position, String str) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    setState(() {
      place = placemarks[0];
      _initial = Marker(
        markerId: MarkerId(position.toString()),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: str,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
    });
  }

  double lat = 0;
  double lon = 0;
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyD5lBq4UXgtMWFIScEX0lGI0VIiFtRW7z0";
  Map<PolylineId, Polyline> polylines = {};
  LatLng startLocation = LatLng(27.6683619, 85.3101895);
  LatLng endLocation = LatLng(27.6688312, 85.3077329);
  //GoogleMapController? mapController; //contrller for Google map
  //Set<Marker> markers = Set(); //markers for google map
  LatLng showLocation = LatLng(11.7617503, 75.5143856);

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  initialiseLocation() async {
    Position pos = await _getGeoLocationPosition();
    setState(() async {
      // lat = pos.latitude;
      // lon = pos.longitude;
      // print("lati= " + lat.toString() + "long=" + lon.toString());
      // showLocation = await LatLng(lat, lon);
    });
    await GetAddressFromLatLong(pos, "Initial");
  }

  @override
  void initState() {
    initialiseLocation();
    _getGeoLocationPosition();

    super.initState();

    getDirections();

    print(place.subAdministrativeArea.toString());
  }

  void _addMarker(LatLng pos) async {
    if (true) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        _destination = null;

        // Reset info
        _info = null;
      });
    }
    // } else {
    //   // Origin is already set
    //   // Set destination
    //   setState(() {
    //     _destination = Marker(
    //       markerId: const MarkerId('destination'),
    //       infoWindow: const InfoWindow(title: 'Destination'),
    //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    //       position: pos,
    //     );
    //   });

    //   // Get directions
    //   final directions = await DirectionsRepository()
    //       .getDirections(origin: _origin!.position, destination: pos);
    //   setState(() => _info = directions);
    // }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double distance = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            if (_origin != null)
              TextButton(
                onPressed: () => _googleMapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _origin!.position,
                      zoom: 14.5,
                      tilt: 50.0,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.green,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text('DEST'),
              ),
            if (_destination != null)
              TextButton(
                onPressed: () => _googleMapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _destination!.position,
                      zoom: 14.5,
                      tilt: 50.0,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text('DEST'),
              ),
            IconButton(
              icon: Icon(
                Icons.account_circle_rounded,
                color: Theme.of(context).primaryColorLight,
                size: 35,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TravelCard(),
                    ));
              },
            ),
          ],
          titleSpacing: 0.0,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Container(
                height: 120,
                child: Image(image: AssetImage("assets/logo.png"))),
          ),
          elevation: 30,
          shadowColor: Colors.black26,
          backgroundColor: Colors.white,
          // actions: [

          // ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 335,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Book a ",
                          style: GoogleFonts.roboto(
                            color: Theme.of(context).primaryColor,
                            fontSize: 40,
                          )),
                      TextSpan(
                          text: "LyfT",
                          style: GoogleFonts.roboto(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorLight))
                    ])),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !(place.subAdministrativeArea.toString() == "null")
                          ? Text(
                              "You're in\n" + place.locality.toString(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )
                          : CircularProgressIndicator(
                              color: Theme.of(context).primaryColorLight,
                            ),
                      GestureDetector(
                        onTap: () async {
                          Position pos = await _getGeoLocationPosition();

                          await GetAddressFromLatLong(pos, "Initial");
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Theme.of(context).primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                children: [
                                  Text(
                                    "  Refresh now ",
                                    style: GoogleFonts.inconsolata(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          focusColor: Theme.of(context).primaryColorLight,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: new BorderSide(color: Colors.teal)),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Where to?",
                          fillColor: Colors.white70),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Position pos = Position(
                              longitude: 75.578522,
                              latitude: 11.759342,
                              timestamp: DateTime.now(),
                              accuracy: 89,
                              altitude: 45,
                              heading: 544,
                              speed: 34,
                              speedAccuracy: 12);
                          await GetAddressFromLatLong(pos, "Panoor");
                          getDirections();
                        },
                        child: Text("Panoor"),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() async {
                            Position pos = Position(
                                longitude: 74.145874,
                                latitude: 16.640120,
                                timestamp: DateTime.now(),
                                accuracy: 89,
                                altitude: 45,
                                heading: 544,
                                speed: 34,
                                speedAccuracy: 12);
                            await GetAddressFromLatLong(pos, "Mahe");
                            getDirections();
                          });
                        },
                        child: Text("Mahe"),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Position pos = Position(
                              longitude: 75.5655,
                              latitude: 11.8319,
                              timestamp: DateTime.now(),
                              accuracy: 89,
                              altitude: 45,
                              heading: 544,
                              speed: 34,
                              speedAccuracy: 12);
                          await GetAddressFromLatLong(pos, "Kuthuparambu");
                          getDirections();
                        },
                        child: Text("Kuthuparambu"),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 400,
                    width: 400,
                    // child: GoogleMap(
                    //   //Map widget from google_maps_flutter package
                    //   zoomGesturesEnabled: true, //enable Zoom in, out on map
                    //   initialCameraPosition: CameraPosition(
                    //     //innital position in map
                    //     target: showLocation, //initial position
                    //     zoom: 10.0, //initial zoom level
                    //   ),
                    //   markers: markers, //markers to show on map
                    //   polylines: Set<Polyline>.of(polylines.values),
                    //   mapType: MapType.normal, //map type
                    //   onMapCreated: (controller) {
                    //     //method called when map is created
                    //     setState(() {
                    //       mapController = controller;
                    //     });
                    //   },
                    // ),
                    // child: GoogleMap(
                    //   myLocationButtonEnabled: false,
                    //   zoomControlsEnabled: false,
                    //   initialCameraPosition: _initialCameraPosition,
                    //   onMapCreated: (controller) =>
                    //       _googleMapController = controller,
                    //   markers: {
                    //     if (_origin != null) _origin!,
                    //     if (_destination != null) _destination!
                    //   },
                    //   polylines: {
                    //     if (_info != null)
                    //       Polyline(
                    //         polylineId: const PolylineId('overview_polyline'),
                    //         color: Colors.red,
                    //         width: 5,
                    //         points: _info!.polylinePoints
                    //             .map((e) => LatLng(e.latitude, e.longitude))
                    //             .toList(),
                    //       ),
                    //   },
                    //   onLongPress: _addMarker,
                    // ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GoogleMap(
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          initialCameraPosition: _initialCameraPosition,
                          onMapCreated: (controller) =>
                              _googleMapController = controller,
                          markers: {
                            if (_origin != null) _origin!,
                            if (_destination != null) _destination!,
                            _initial!
                          },
                          polylines: {
                            if (_info != null)
                              Polyline(
                                polylineId:
                                    const PolylineId('overview_polyline'),
                                color: Colors.red,
                                width: 5,
                                points: _info!.polylinePoints
                                    .map((e) => LatLng(e.latitude, e.longitude))
                                    .toList(),
                              ),
                          },
                          onLongPress: _addMarker,
                        ),
                        if (_info == null)
                          Positioned(
                            top: 20.0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  distance = calculateDistance(
                                      _origin!.position.latitude,
                                      _origin!.position.longitude,
                                      _initial!.position.latitude,
                                      _initial!.position.longitude);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 12.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 6.0,
                                    )
                                  ],
                                ),
                                child: Text(
                                  double.parse(distance.toStringAsFixed(2)) ==
                                          0.0
                                      ? "Calculate Distance"
                                      : '${double.parse(distance.toStringAsFixed(2))}' +
                                          " KM",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (distance != 0)
                          Positioned(
                            bottom: 20.0,
                            left: 200,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Booking(
                                              distance: distance,
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 12.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).primaryColor,
                                      offset: Offset(0, 2),
                                      blurRadius: 6.0,
                                    )
                                  ],
                                ),
                                child: Text(
                                  "Book Now!",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
