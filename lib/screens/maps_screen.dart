import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:test_123/helpers/helpers.dart';

class MapsScreen extends StatefulWidget {
  static const String route = '/maps';

  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  Position? currentPosition;
  Location location = Location();
  LatLng? latLng;
  final Set<Marker> markers = {};

  GoogleMapController? _controller;
  LatLng initialPosition = const LatLng(0.5937, 0.9629);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    //currentPosition = await location.getLocation();
    currentPosition = await Helpers.getCurrentLocation();
    initialPosition =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        initialPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    location.onLocationChanged.listen((l) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppBarPlacesAutoCompleteTextField(),),
      body: GoogleMap(
        onTap: (value) {
          setState(() {
            latLng = value;
            markers.clear();
            markers
                .add(Marker(position: latLng!, markerId: const MarkerId("0")));
          });
        },
        markers: markers,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: initialPosition),
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
