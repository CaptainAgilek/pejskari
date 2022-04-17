import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pejskari/data/VetVisit.dart';
import 'package:pejskari/entity/VetVisitEntity.dart';
import 'package:pejskari/repository/VetVisitRepositoryImpl.dart';
import 'package:pejskari/service/VetVisitService.dart';
import 'package:test/test.dart';

import 'VetVisitService_test.mocks.dart';


@GenerateMocks([VetVisitRepositoryImpl])
void main() {
  test('Get all', () async {
    //GIVEN
    final VetVisitService tested = VetVisitService();
    final mockRepository = MockVetVisitRepositoryImpl();

    List<VetVisitEntity> vetVisits = [
      VetVisitEntity(2, "17.5.2021", "poznámky", 1, 2, ["/path/document1", "/path/document2"]),
      VetVisitEntity(3, "17.3.2021", "poznámky2", 2, 3, ["/path2/document1", "/path2/document2"]),
    ];

    when(mockRepository.getAll()).thenAnswer((_) async => vetVisits);
    tested.repository = mockRepository;

    //WHEN
    var result = await tested.getAll();

    //THEN
    verify(mockRepository.getAll()).called(1);
    expect(result.length, vetVisits.length);

    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, vetVisits[i].id);
      expect(result[i].date, vetVisits[i].date);
      expect(result[i].notes, vetVisits[i].notes);
      expect(result[i].vetId, vetVisits[i].vetId);
      expect(result[i].dogProfileId, vetVisits[i].dogProfileId);
      expect(result[i].documentPaths, vetVisits[i].documentPaths);
    }
  });

  test('Delete', () async {
    //GIVEN
    final VetVisitService tested = VetVisitService();
    final mockRepository = MockVetVisitRepositoryImpl();

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
    final VetVisitService tested = VetVisitService();
    final mockRepository = MockVetVisitRepositoryImpl();

    var vetVisit = VetVisit(2, "17.5.2021", "poznámky", 1, 2, ["/path/document1", "/path/document2"]);

    when(mockRepository.insert(argThat(isA<VetVisitEntity>())))
        .thenAnswer((arg) async {
      return arg.positionalArguments[0];
    });

    tested.repository = mockRepository;

    //WHEN
    var result = await tested.create(vetVisit);

    //THEN
    verify(mockRepository.insert(argThat(isA<VetVisitEntity>()))).called(1);
    expect(result.id, vetVisit.id);
    expect(result.date, vetVisit.date);
    expect(result.notes, vetVisit.notes);
    expect(result.vetId, vetVisit.vetId);
    expect(result.dogProfileId, vetVisit.dogProfileId);
    expect(result.documentPaths, vetVisit.documentPaths);
  });

  test('Update', () async {
    //GIVEN
    final VetVisitService tested = VetVisitService();
    final mockRepository = MockVetVisitRepositoryImpl();

    var vetVisit = VetVisit(2, "17.5.2021", "poznámky", 1, 2, ["/path/document1", "/path/document2"]);

    when(mockRepository.update(argThat(isA<VetVisitEntity>())))
        .thenAnswer((_) async {});

    tested.repository = mockRepository;

    //WHEN
    await tested.update(vetVisit);

    //THEN
    var verificationResult =
        verify(mockRepository.update(captureThat(isA<VetVisitEntity>())))
          ..called(1);
    var arg = verificationResult.captured.first;

    expect(arg.id, vetVisit.id);
    expect(arg.date, vetVisit.date);
    expect(arg.notes, vetVisit.notes);
    expect(arg.vetId, vetVisit.vetId);
    expect(arg.dogProfileId, vetVisit.dogProfileId);
    expect(arg.documentPaths, vetVisit.documentPaths);
  });
}
