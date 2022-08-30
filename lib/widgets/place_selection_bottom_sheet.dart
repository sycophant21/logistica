import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/helpers/selected_place_details.dart';
import 'package:test_123/screens/location_selection_from_map_screen.dart';

class PlaceSelectionBottomSheet extends PlacesAutocompleteWidget {
  PlaceSelectionBottomSheet({Key? key})
      : super(
          key: key,
          apiKey: Helpers.apiKey,
          sessionToken: Uuid().generateV4(),
          language: "en",
          components: [Component(Component.country, "us")],
          types: [],
          strictbounds: false,
        );

  @override
  _PlaceSelectionBottomSheetState createState() =>
      _PlaceSelectionBottomSheetState();
}

class _PlaceSelectionBottomSheetState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: 0,
        leading: const SizedBox(),
        title: AppBarPlacesAutoCompleteTextField(
          textDecoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 16),
            constraints: const BoxConstraints(maxHeight: 45),
            hintText: 'Search Places',
            hintStyle: const TextStyle(fontSize: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (ctx) {
                    return CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          child: const Text('Use Current location'),
                          onPressed: () async {
                            Position? position =
                                await Helpers.getCurrentLocation();
                            String placeId = await APIHandler.getAPIHandler()
                                .getAddress(LatLng(
                                    position!.latitude, position.longitude));
                            GoogleMapsPlaces _places = GoogleMapsPlaces(
                              apiKey: widget.apiKey,
                              apiHeaders:
                                  await const GoogleApiHeaders().getHeaders(),
                            );
                            PlacesDetailsResponse detail =
                                await _places.getDetailsByPlaceId(placeId);
                            final lat = detail.result.geometry!.location.lat;
                            final lng = detail.result.geometry!.location.lng;
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(SelectedPlaceDetails(
                                detail.result, LatLng(lat, lng)));
                          },
                          isDefaultAction: true,
                        ),
                        CupertinoActionSheetAction(
                            child: const Text('Select on Map'),
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute<LatLng>(
                                  builder: (ctx) {
                                    return const LocationSelectionFromMapScreen();
                                  },
                                ),
                              ).then((value) async {
                                if (value != null) {
                                  String placeId =
                                      await APIHandler.getAPIHandler()
                                          .getAddress(LatLng(value.latitude,
                                              value.longitude));
                                  GoogleMapsPlaces _places = GoogleMapsPlaces(
                                    apiKey: widget.apiKey,
                                    apiHeaders: await const GoogleApiHeaders()
                                        .getHeaders(),
                                  );
                                  PlacesDetailsResponse detail = await _places
                                      .getDetailsByPlaceId(placeId);
                                  final lat =
                                      detail.result.geometry!.location.lat;
                                  final lng =
                                      detail.result.geometry!.location.lng;
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop(
                                      SelectedPlaceDetails(
                                          detail.result, LatLng(lat, lng)));
                                }
                              });
                            }),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    );
                  });
            },
            icon: const Icon(
              CupertinoIcons.ellipsis_circle,
              color: CupertinoColors.systemBlue,
            ),
          ),
        ],
      ),
      body: PlacesAutocompleteResult(
        logo: Container(),
        onTap: (prediction) async {
          GoogleMapsPlaces _places = GoogleMapsPlaces(
            apiKey: widget.apiKey,
            apiHeaders: await const GoogleApiHeaders().getHeaders(),
          );
          PlacesDetailsResponse detail =
              await _places.getDetailsByPlaceId(prediction.placeId!);
          final lat = detail.result.geometry!.location.lat;
          final lng = detail.result.geometry!.location.lng;
          Navigator.of(context)
              .pop(SelectedPlaceDetails(detail.result, LatLng(lat, lng)));
        },
      ),
    );
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
