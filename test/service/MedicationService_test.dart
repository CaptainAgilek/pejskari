import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pejskari/data/Medication.dart';
import 'package:pejskari/entity/MedicationEntity.dart';
import 'package:pejskari/repository/MedicationRepositoryImpl.dart';
import 'package:pejskari/service/MedicationService.dart';
import 'package:test/test.dart';

import 'MedicationService_test.mocks.dart';

@GenerateMocks([MedicationRepositoryImpl])
void main() {
  test('Get all', () async {
    //GIVEN
    final MedicationService tested = MedicationService();
    final mockRepository = MockMedicationRepositoryImpl();

    List<MedicationEntity> medications = [
      MedicationEntity(2, "nazev medikace", "17.5.2020", "poznámky", 1),
      MedicationEntity(3, "nazev medikace2", "17.5.2021", "poznámky2", 2)
    ];

    when(mockRepository.getAll()).thenAnswer((_) async => medications);
    tested.repository = mockRepository;

    //WHEN
    var result = await tested.getAll();

    //THEN
    verify(mockRepository.getAll()).called(1);

    expect(result.length, medications.length);

    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, medications[i].id);
      expect(result[i].name, medications[i].name);
      expect(result[i].dateTime, medications[i].dateTime);
      expect(result[i].notes, medications[i].notes);
      expect(result[i].dogProfileId, medications[i].dogProfileId);
    }
  });

  test('Delete', () async {
    //GIVEN
    final MedicationService tested = MedicationService();
    final mockRepository = MockMedicationRepositoryImpl();

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
    final MedicationService tested = MedicationService();
    final mockRepository = MockMedicationRepositoryImpl();

    var medication = Medication(2, "nazev medikace", "17.5.2020", "poznámky", 1);

    when(mockRepository.insert(argThat(isA<MedicationEntity>())))
        .thenAnswer((arg) async {
      return arg.positionalArguments[0];
    });

    tested.repository = mockRepository;

    //WHEN
    var result = await tested.create(medication);

    //THEN
    verify(mockRepository.insert(argThat(isA<MedicationEntity>()))).called(1);
    expect(result.id, medication.id);
    expect(result.name, medication.name);
    expect(result.dateTime, medication.dateTime);
    expect(result.notes, medication.notes);
    expect(result.dogProfileId, medication.dogProfileId);
  });

  test('Update', () async {
    //GIVEN
    final MedicationService tested = MedicationService();
    final mockRepository = MockMedicationRepositoryImpl();

    var medication = Medication(2, "nazev medikace", "17.5.2020", "poznámky", 1);

    when(mockRepository.update(argThat(isA<MedicationEntity>())))
        .thenAnswer((_) async {});

    tested.repository = mockRepository;

    //WHEN
    await tested.update(medication);

    //THEN
    var verificationResult =
        verify(mockRepository.update(captureThat(isA<MedicationEntity>())))
          ..called(1);
    var arg = verificationResult.captured.first;

    expect(arg.id, medication.id);
    expect(arg.name, medication.name);
    expect(arg.dateTime, medication.dateTime);
    expect(arg.notes, medication.notes);
    expect(arg.dogProfileId, medication.dogProfileId);
  });
}
