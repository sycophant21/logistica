class CoOrdinates {
  final double longitude;
  final double latitude;

  CoOrdinates(this.longitude, this.latitude);

  static CoOrdinates fromJson(json) {
    double longitude = json['longitude'];
    double latitude = json['latitude'];
    return CoOrdinates(longitude, latitude);
  }

  static Map toJson(CoOrdinates coOrdinates) {
    return {
      'longitude': coOrdinates.longitude,
      'latitude': coOrdinates.latitude
    };
  }

  static CoOrdinates empty() {
    return CoOrdinates(0, 0);
  }
}
