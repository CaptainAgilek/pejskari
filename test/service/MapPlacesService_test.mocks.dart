// Mocks generated by Mockito 5.1.0 from annotations
// in pejskari/test/service/MapPlacesService_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pejskari/client/PejskariGeoApiClient.dart' as _i2;
import 'package:pejskari/client/data/DogPark.dart' as _i5;
import 'package:pejskari/client/data/DogTrainingPlace.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [PejskariGeoApiClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockPejskariGeoApiClient extends _i1.Mock
    implements _i2.PejskariGeoApiClient {
  MockPejskariGeoApiClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.DogTrainingPlace>> getDogTrainingPlaces() =>
      (super.noSuchMethod(Invocation.method(#getDogTrainingPlaces, []),
              returnValue: Future<List<_i4.DogTrainingPlace>>.value(
                  <_i4.DogTrainingPlace>[]))
          as _i3.Future<List<_i4.DogTrainingPlace>>);
  @override
  _i3.Future<List<_i5.DogPark>> getDogParks() =>
      (super.noSuchMethod(Invocation.method(#getDogParks, []),
              returnValue: Future<List<_i5.DogPark>>.value(<_i5.DogPark>[]))
          as _i3.Future<List<_i5.DogPark>>);
}
