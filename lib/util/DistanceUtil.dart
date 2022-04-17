import 'dart:math';

/// Utility class for calculating distance between two coordinates.
class DistanceUtil {
  //https://www.fluttercampus.com/guide/248/calculate-distance-between-location-google-map-flutter/
  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}