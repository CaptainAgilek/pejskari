// Mocks generated by Mockito 5.1.0 from annotations
// in pejskari/test/service/DogWeightService_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pejskari/entity/DogWeightEntity.dart' as _i2;
import 'package:pejskari/repository/DogWeightRepositoryImpl.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeDogWeightEntity_0 extends _i1.Fake implements _i2.DogWeightEntity {}

/// A class which mocks [DogWeightRepositoryImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockDogWeightRepositoryImpl extends _i1.Mock
    implements _i3.DogWeightRepositoryImpl {
  MockDogWeightRepositoryImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> delete(int? id) =>
      (super.noSuchMethod(Invocation.method(#delete, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<_i2.DogWeightEntity?> get(int? id) =>
      (super.noSuchMethod(Invocation.method(#get, [id]),
              returnValue: Future<_i2.DogWeightEntity?>.value())
          as _i4.Future<_i2.DogWeightEntity?>);
  @override
  _i4.Future<List<_i2.DogWeightEntity>> getAll() => (super.noSuchMethod(
          Invocation.method(#getAll, []),
          returnValue:
              Future<List<_i2.DogWeightEntity>>.value(<_i2.DogWeightEntity>[]))
      as _i4.Future<List<_i2.DogWeightEntity>>);
  @override
  _i4.Future<_i2.DogWeightEntity> insert(_i2.DogWeightEntity? entity) =>
      (super.noSuchMethod(Invocation.method(#insert, [entity]),
              returnValue:
                  Future<_i2.DogWeightEntity>.value(_FakeDogWeightEntity_0()))
          as _i4.Future<_i2.DogWeightEntity>);
  @override
  _i4.Future<void> update(_i2.DogWeightEntity? entity) =>
      (super.noSuchMethod(Invocation.method(#update, [entity]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
}
