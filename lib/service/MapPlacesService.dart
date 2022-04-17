import 'package:pejskari/client/PejskariGeoApiClient.dart';
import 'package:pejskari/data/DogTrainingPlace.dart';

import '../data/DogPark.dart';

/// Service for operations with map places.
class MapPlacesService {
  PejskariGeoApiClient _client = PejskariGeoApiClient();

  set client(PejskariGeoApiClient client) {
    _client = client;
  }

  Future<List<DogTrainingPlace>> getDogTrainingPlaces() async {
     var dogTrainingPlaces = await _client.getDogTrainingPlaces();
     return dogTrainingPlaces.map((e) => DogTrainingPlace(e.id!, e.name!, e.address!.latLng![0], e.address!.latLng![1], e.address?.street ?? "" , e.address?.city?.name ?? "")).toList();
  }

  Future<List<DogPark>> getDogParks() async {
    var dogParks = await _client.getDogParks();
    return dogParks.map((e) => DogPark(e.id!, e.name!, e.address!.latLng![0], e.address!.latLng![1], e.address?.street ?? "" , e.address?.city?.name ?? "")).toList();
  }

}