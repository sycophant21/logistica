import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedPlaceDetails {
  PlaceDetails placeDetails;
  LatLng latLng;

  SelectedPlaceDetails(this.placeDetails, this.latLng);
}