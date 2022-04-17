import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pejskari/client/data/DogPark.dart';
import 'package:pejskari/client/data/DogTrainingPlace.dart';

/// Client for consuming Pejskari REST API.
class PejskariGeoApiClient {
  static const String API_URL = "api.pejskari.cz";

  Future<List<DogTrainingPlace>> getDogTrainingPlaces() async {
    List<DogTrainingPlace> places = [];
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.https(API_URL, 'v1/training', {"l": "0"}),
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var list = List<DogTrainingPlace>.from(decodedResponse["data"]
            .map((jsonObject) => DogTrainingPlace.fromJson(jsonObject)));
        places.addAll(list);
      }
    } finally {
      client.close();
    }
    return places;
  }

  Future<List<DogPark>> getDogParks() async {
    List<DogPark> parks = [];
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.https(API_URL, 'v1/dogparks', {"l": "0"}),
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var list = List<DogPark>.from(decodedResponse["data"]
            .map((jsonObject) => DogPark.fromJson(jsonObject)));
        parks.addAll(list);
      }
    } finally {
      client.close();
    }
    return parks;
  }
}
