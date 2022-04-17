import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pejskari/data/Vet.dart';
import 'package:pejskari/entity/VetEntity.dart';
import 'package:pejskari/repository/VetRepositoryImpl.dart';
import 'package:pejskari/service/VetService.dart';
import 'package:test/test.dart';

import 'VetService_test.mocks.dart';


@GenerateMocks([VetRepositoryImpl])
void main() {
  test('Get all', () async {
    //GIVEN
    final VetService tested = VetService();
    final mockRepository = MockVetRepositoryImpl();

    List<VetEntity> vets = [
      VetEntity(2, "Karel Novák", "728256896", "poznámky"),
      VetEntity(3, "Karel Ocásek", "725252843", "poznámky2"),
    ];

    when(mockRepository.getAll()).thenAnswer((_) async => vets);
    tested.repository = mockRepository;

    //WHEN
    var result = await tested.getAll();

    //THEN
    verify(mockRepository.getAll()).called(1);
    expect(result.length, vets.length);

    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, vets[i].id);
      expect(result[i].name, vets[i].name);
      expect(result[i].phone, vets[i].phone);
      expect(result[i].notes, vets[i].notes);
    }
  });

  test('Delete', () async {
    //GIVEN
    final VetService tested = VetService();
    final mockRepository = MockVetRepositoryImpl();

    when(mockRepository.delete(any)).thenAnswer((_) async {});
    tested.repository = mockRepository;

    int id = 25;

    //WHEN
    var result = await tested.delete(id);

    //THEN
    verify(mockRepository.delete(id)).called(1);
  });

  test('Create', () async {
    //GIVEN
    final VetService tested = VetService();
    final mockRepository = MockVetRepositoryImpl();

    var vet = Vet(2, "Karel Novák", "728256896", "poznámky");

    when(mockRepository.insert(argThat(isA<VetEntity>())))
        .thenAnswer((arg) async {
      return arg.positionalArguments[0];
    });

    tested.repository = mockRepository;

    //WHEN
    var result = await tested.create(vet);

    //THEN
    verify(mockRepository.insert(argThat(isA<VetEntity>()))).called(1);
    expect(result.id, vet.id);
    expect(result.name, vet.name);
    expect(result.phone, vet.phone);
    expect(result.notes, vet.notes);
  });

  test('Update', () async {
    //GIVEN
    final VetService tested = VetService();
    final mockRepository = MockVetRepositoryImpl();

    var vet = Vet(2, "Karel Novák", "728256896", "poznámky");

    when(mockRepository.update(argThat(isA<VetEntity>())))
        .thenAnswer((_) async {});

    tested.repository = mockRepository;

    //WHEN
    await tested.update(vet);

    //THEN
    var verificationResult =
        verify(mockRepository.update(captureThat(isA<VetEntity>())))
          ..called(1);
    var arg = verificationResult.captured.first;

    expect(arg.id, vet.id);
    expect(arg.name, vet.name);
    expect(arg.phone, vet.phone);
    expect(arg.notes, vet.notes);
  });
}
