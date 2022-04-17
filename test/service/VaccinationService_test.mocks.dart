// Mocks generated by Mockito 5.1.0 from annotations
// in pejskari/test/service/VaccinationService_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pejskari/entity/VaccinationEntity.dart' as _i2;
import 'package:pejskari/repository/VaccinationRepositoryImpl.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeVaccinationEntity_0 extends _i1.Fake
    implements _i2.VaccinationEntity {}

/// A class which mocks [VaccinationRepositoryImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockVaccinationRepositoryImpl extends _i1.Mock
    implements _i3.VaccinationRepositoryImpl {
  MockVaccinationRepositoryImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> delete(int? id) =>
      (super.noSuchMethod(Invocation.method(#delete, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<_i2.VaccinationEntity?> get(int? id) =>
      (super.noSuchMethod(Invocation.method(#get, [id]),
              returnValue: Future<_i2.VaccinationEntity?>.value())
          as _i4.Future<_i2.VaccinationEntity?>);
  @override
  _i4.Future<List<_i2.VaccinationEntity>> getAll() =>
      (super.noSuchMethod(Invocation.method(#getAll, []),
              returnValue: Future<List<_i2.VaccinationEntity>>.value(
                  <_i2.VaccinationEntity>[]))
          as _i4.Future<List<_i2.VaccinationEntity>>);
  @override
  _i4.Future<_i2.VaccinationEntity> insert(_i2.VaccinationEntity? entity) =>
      (super.noSuchMethod(Invocation.method(#insert, [entity]),
              returnValue: Future<_i2.VaccinationEntity>.value(
                  _FakeVaccinationEntity_0()))
          as _i4.Future<_i2.VaccinationEntity>);
  @override
  _i4.Future<void> update(_i2.VaccinationEntity? entity) =>
      (super.noSuchMethod(Invocation.method(#update, [entity]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
}