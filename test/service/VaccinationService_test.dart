import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pejskari/data/Vaccination.dart';
import 'package:pejskari/entity/VaccinationEntity.dart';
import 'package:pejskari/repository/VaccinationRepositoryImpl.dart';
import 'package:pejskari/service/VaccinationService.dart';
import 'package:test/test.dart';

import 'VaccinationService_test.mocks.dart';


@GenerateMocks([VaccinationRepositoryImpl])
void main() {
  test('Get all', () async {
    //GIVEN
    final VaccinationService tested = VaccinationService();
    final mockRepository = MockVaccinationRepositoryImpl();

    List<VaccinationEntity> vaccinations = [
      VaccinationEntity(2, "nazev vakcinace", "17.5.2020", "poznámky", 2),
      VaccinationEntity(3, "nazev vakcinace2", "17.5.2021", "poznámky2", 3)
    ];

    when(mockRepository.getAll()).thenAnswer((_) async => vaccinations);
    tested.repository = mockRepository;

    //WHEN
    var result = await tested.getAll();

    //THEN
    verify(mockRepository.getAll()).called(1);
    expect(result.length, vaccinations.length);

    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, vaccinations[i].id);
      expect(result[i].name, vaccinations[i].name);
      expect(result[i].date, vaccinations[i].date);
      expect(result[i].notes, vaccinations[i].notes);
      expect(result[i].dogProfileId, vaccinations[i].dogProfileId);
    }
  });

  test('Delete', () async {
    //GIVEN
    final VaccinationService tested = VaccinationService();
    final mockRepository = MockVaccinationRepositoryImpl();

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
    final VaccinationService tested = VaccinationService();
    final mockRepository = MockVaccinationRepositoryImpl();

    var vaccination = Vaccination(2, "nazev vakcinace", "17.5.2020", "poznámky", 2);

    when(mockRepository.insert(argThat(isA<VaccinationEntity>())))
        .thenAnswer((arg) async {
      return arg.positionalArguments[0];
    });

    tested.repository = mockRepository;

    //WHEN
    var result = await tested.create(vaccination);

    //THEN
    verify(mockRepository.insert(argThat(isA<VaccinationEntity>()))).called(1);
    expect(result.id, vaccination.id);
    expect(result.name, vaccination.name);
    expect(result.date, vaccination.date);
    expect(result.notes, vaccination.notes);
    expect(result.dogProfileId, vaccination.dogProfileId);
  });

  test('Update', () async {
    //GIVEN
    final VaccinationService tested = VaccinationService();
    final mockRepository = MockVaccinationRepositoryImpl();

    var vaccination = Vaccination(2, "nazev vakcinace", "17.5.2020", "poznámky", 2);

    when(mockRepository.update(argThat(isA<VaccinationEntity>())))
        .thenAnswer((_) async {});

    tested.repository = mockRepository;

    //WHEN
    await tested.update(vaccination);

    //THEN
    var verificationResult =
        verify(mockRepository.update(captureThat(isA<VaccinationEntity>())))
          ..called(1);
    var arg = verificationResult.captured.first;

    expect(arg.id, vaccination.id);
    expect(arg.name, vaccination.name);
    expect(arg.date, vaccination.date);
    expect(arg.notes, vaccination.notes);
    expect(arg.dogProfileId, vaccination.dogProfileId);
  });
}
