import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pejskari/data/DogWeight.dart';
import 'package:pejskari/entity/DogWeightEntity.dart';
import 'package:pejskari/repository/DogWeightRepositoryImpl.dart';
import 'package:pejskari/service/DogWeightService.dart';
import 'package:test/test.dart';

import 'DogWeightService_test.mocks.dart';

@GenerateMocks([DogWeightRepositoryImpl])
void main() {
  test('Get all', () async {
    //GIVEN
    final DogWeightService tested = DogWeightService();
    final mockRepository = MockDogWeightRepositoryImpl();

    List<DogWeightEntity> dogWeights = [
      DogWeightEntity(2, 45, "17.5.2020", "poznámky", 1),
      DogWeightEntity(3, 55, "17.6.2020", "poznámky", 1)
    ];

    when(mockRepository.getAll()).thenAnswer((_) async => dogWeights);
    tested.repository = mockRepository;

    //WHEN
    var result = await tested.getAll();

    //THEN
    verify(mockRepository.getAll()).called(1);
    expect(result.length, dogWeights.length);

    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, dogWeights[i].id);
      expect(result[i].weight, dogWeights[i].weight);
      expect(result[i].date, dogWeights[i].date);
      expect(result[i].notes, dogWeights[i].notes);
      expect(result[i].dogProfileId, dogWeights[i].dogProfileId);
    }
  });

  test('Delete', () async {
    //GIVEN
    final DogWeightService tested = DogWeightService();
    final mockRepository = MockDogWeightRepositoryImpl();

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
    final DogWeightService tested = DogWeightService();
    final mockRepository = MockDogWeightRepositoryImpl();

    DogWeight dogWeight = DogWeight(2, 45, "17.5.2020", "poznámky", 1);

    when(mockRepository.insert(argThat(isA<DogWeightEntity>())))
        .thenAnswer((arg) async {
      return arg.positionalArguments[0];
    });

    tested.repository = mockRepository;

    //WHEN
    var result = await tested.create(dogWeight);

    //THEN
    verify(mockRepository.insert(argThat(isA<DogWeightEntity>()))).called(1);
    expect(result.id, dogWeight.id);
    expect(result.weight, dogWeight.weight);
    expect(result.date, dogWeight.date);
    expect(result.notes, dogWeight.notes);
    expect(result.dogProfileId, dogWeight.dogProfileId);
  });

  test('Update', () async {
    //GIVEN
    final DogWeightService tested = DogWeightService();
    final mockRepository = MockDogWeightRepositoryImpl();

    DogWeight dogWeight = DogWeight(2, 45, "17.5.2020", "poznámky", 1);

    when(mockRepository.update(argThat(isA<DogWeightEntity>())))
        .thenAnswer((_) async {});

    tested.repository = mockRepository;

    //WHEN
    await tested.update(dogWeight);

    //THEN
    var verificationResult =
        verify(mockRepository.update(captureThat(isA<DogWeightEntity>())))
          ..called(1);
    var arg = verificationResult.captured.first;

    expect(arg.id, dogWeight.id);
    expect(arg.weight, dogWeight.weight);
    expect(arg.date, dogWeight.date);
    expect(arg.notes, dogWeight.notes);
    expect(arg.dogProfileId, dogWeight.dogProfileId);
  });
}
