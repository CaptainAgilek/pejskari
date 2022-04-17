import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pejskari/client/PejskariGeoApiClient.dart';
import 'package:pejskari/client/data/Address.dart';
import 'package:pejskari/client/data/City.dart';
import 'package:pejskari/client/data/DogPark.dart' as DogParkDto;
import 'package:pejskari/client/data/DogTrainingPlace.dart'
    as DogTrainingPlaceDto;
import 'package:pejskari/data/DogPark.dart';
import 'package:pejskari/data/DogTrainingPlace.dart';
import 'package:pejskari/service/MapPlacesService.dart';

import 'MapPlacesService_test.mocks.dart';

@GenerateMocks([PejskariGeoApiClient])
void main() {
  test('Get dog training places', () async {
    //GIVEN
    final MapPlacesService tested = MapPlacesService();
    final mockClient = MockPejskariGeoApiClient();

    List<DogTrainingPlaceDto.DogTrainingPlace> dogTrainingPlaces = [
      DogTrainingPlaceDto.DogTrainingPlace(
          name: "Cvičák Brno",
          type: 0,
          id: 2,
          slug: "cvičák-brno",
          addressId: 3,
          address: Address(
              street: "ulice",
              zip: "zip",
              latLng: [10.0, 25.0],
              cityId: 5,
              city: City(name: "Brno", id: 5, districtId: 6))),
      DogTrainingPlaceDto.DogTrainingPlace(
          name: "Cvičák Ostrava",
          type: 0,
          id: 3,
          slug: "cvičák-ostrava",
          addressId: 4,
          address: Address(
              street: "ulice",
              zip: "zip",
              latLng: [15.0, 27.0],
              cityId: 6,
              city: City(name: "Ostrava", id: 6, districtId: 7))),
    ];

    when(mockClient.getDogTrainingPlaces())
        .thenAnswer((_) async => dogTrainingPlaces);
    tested.client = mockClient;

    //WHEN
    List<DogTrainingPlace> result = await tested.getDogTrainingPlaces();

    //THEN
    verify(mockClient.getDogTrainingPlaces()).called(1);
    expect(result.length, dogTrainingPlaces.length);

    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, dogTrainingPlaces[i].id);
      expect(result[i].name, dogTrainingPlaces[i].name);
      expect(result[i].latitude, dogTrainingPlaces[i].address!.latLng![0]);
      expect(result[i].longitude, dogTrainingPlaces[i].address!.latLng![1]);
      expect(result[i].street, dogTrainingPlaces[i].address!.street);
      expect(result[i].city, dogTrainingPlaces[i].address!.city!.name);
    }
  });

  test('Get dog parks', () async {
    //GIVEN
    final MapPlacesService tested = MapPlacesService();
    final mockClient = MockPejskariGeoApiClient();

    List<DogParkDto.DogPark> dogParks = [
      DogParkDto.DogPark(
          name: "Psí park Brno",
          type: 0,
          id: 2,
          slug: "psí-park-brno",
          addressId: 3,
          address: Address(
              street: "ulice",
              zip: "zip",
              latLng: [10.0, 25.0],
              cityId: 5,
              city: City(name: "Brno", id: 5, districtId: 6))),
      DogParkDto.DogPark(
          name: "Psí park Ostrava",
          type: 0,
          id: 3,
          slug: "psí-park-brno",
          addressId: 4,
          address: Address(
              street: "ulice",
              zip: "zip",
              latLng: [18.0, 27.0],
              cityId: 6,
              city: City(name: "Brno", id: 6, districtId: 7))),
    ];

    when(mockClient.getDogParks()).thenAnswer((_) async => dogParks);
    tested.client = mockClient;

    //WHEN
    List<DogPark> result = await tested.getDogParks();

    //THEN
    verify(mockClient.getDogParks()).called(1);
    expect(result.length, dogParks.length);

    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, dogParks[i].id);
      expect(result[i].name, dogParks[i].name);
      expect(result[i].latitude, dogParks[i].address!.latLng![0]);
      expect(result[i].longitude, dogParks[i].address!.latLng![1]);
      expect(result[i].street, dogParks[i].address!.street);
      expect(result[i].city, dogParks[i].address!.city!.name);
    }
  });
}
