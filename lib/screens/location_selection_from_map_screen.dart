import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_123/helpers/helpers.dart';

class LocationSelectionFromMapScreen extends StatefulWidget {
  const LocationSelectionFromMapScreen({Key? key}) : super(key: key);

  @override
  State<LocationSelectionFromMapScreen> createState() =>
      _LocationSelectionFromMapScreenState();
}

class _LocationSelectionFromMapScreenState
    extends State<LocationSelectionFromMapScreen> {
  final List<Marker> markers = List.empty(growable: true);
  GoogleMapController? _controller;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    Helpers.getCurrentLocation().then((value) {
      setState(() {
        if (value != null) {
          _controller!.animateCamera(
            CameraUpdate.newLatLng(LatLng(value.latitude, value.longitude)),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CupertinoNavigationBarBackButton(),
        actions: [
          CupertinoButton(
            child: const Text('Done'),
            onPressed: () {
              if (markers.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No place selected'),
                  ),
                );
              }
              else {
                Navigator.of(context).pop(markers.first.position);
              }
            },
          )
        ],
      ),
      body: GoogleMap(
        onTap: (value) {
          setState(() {
            markers.add(
              Marker(
                markerId: const MarkerId('1'),
                position: value,
              ),
            );
          });
        },
        myLocationEnabled: true,
        markers: Set.of(markers),
        mapType: MapType.normal,
        initialCameraPosition:
            const CameraPosition(target: LatLng(0, 0), zoom: 19),
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
