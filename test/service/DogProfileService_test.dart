import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/entity/DogProfileEntity.dart';
import 'package:pejskari/repository/DogProfileRepositoryImpl.dart';
import 'package:pejskari/service/DogProfileService.dart';
import 'package:test/test.dart';

import '../DogProfileRepositoryImpl_test.mocks.dart';

@GenerateMocks([DogProfileRepositoryImpl])
void main() {

  test('Get all', () async {
    //GIVEN
    final DogProfileService tested = DogProfileService();
    final mockRepository = MockDogProfileRepositoryImpl();

    List<DogProfileEntity> dogProfiles = [
      DogProfileEntity(2, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020", 50,
          "profileImagePath", 1, 1),
      DogProfileEntity(3, "Čiko", "Husky", "553456789", "17.5.2021", 45,
          "profileImagePath2", 0, 0)
    ];

    when(mockRepository.getAll()).thenAnswer((_) async => dogProfiles);
    tested.repository = mockRepository;

    //WHEN
    var result = await tested.getAll();

    //THEN
    verify(mockRepository.getAll()).called(1);

    expect(result.length, dogProfiles.length);

    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, dogProfiles[i].id);
      expect(result[i].name, dogProfiles[i].name);
      expect(result[i].breed, dogProfiles[i].breed);
      expect(result[i].chipId, dogProfiles[i].chipId);
      expect(result[i].dateOfBirth, dogProfiles[i].dateOfBirth);
      expect(result[i].height, dogProfiles[i].height);
      expect(result[i].profileImagePath, dogProfiles[i].profileImagePath);
      expect(result[i].castrated, dogProfiles[i].castrated);
    }
  });

  test('Delete', () async {
    //GIVEN
    final DogProfileService tested = DogProfileService();
    final mockRepository = MockDogProfileRepositoryImpl();

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
    final DogProfileService tested = DogProfileService();
    final mockRepository = MockDogProfileRepositoryImpl();

    DogProfile dogProfile = DogProfile(3, "Kiko", "Zlatý retrívr", "123456789",
        "17.5.2020", 50, "profileImagePath", 1, 1);

    when(mockRepository.insert(argThat(isA<DogProfileEntity>())))
        .thenAnswer((arg) async {
      return arg.positionalArguments[0];
    });

    tested.repository = mockRepository;

    //WHEN
    var result = await tested.create(dogProfile);

    //THEN
    verify(mockRepository.insert(argThat(isA<DogProfileEntity>()))).called(1);
    expect(result.id, dogProfile.id);
    expect(result.name, dogProfile.name);
    expect(result.breed, dogProfile.breed);
    expect(result.chipId, dogProfile.chipId);
    expect(result.dateOfBirth, dogProfile.dateOfBirth);
    expect(result.height, dogProfile.height);
    expect(result.profileImagePath, dogProfile.profileImagePath);
    expect(result.castrated, dogProfile.castrated);
  });

  test('Update', () async {
    //GIVEN
    final DogProfileService tested = DogProfileService();
    final mockRepository = MockDogProfileRepositoryImpl();

    DogProfile dogProfile = DogProfile(3, "Kiko", "Zlatý retrívr", "123456789",
        "17.5.2020", 50, "profileImagePath", 1, 0);

    when(mockRepository.update(argThat(isA<DogProfileEntity>())))
        .thenAnswer((_) async {});

    tested.repository = mockRepository;

    //WHEN
    await tested.update(dogProfile);

    //THEN
    var verificationResult =
        verify(mockRepository.update(captureThat(isA<DogProfileEntity>())))
          ..called(1);
    var arg = verificationResult.captured.first;

    expect(arg.id, dogProfile.id);
    expect(arg.name, dogProfile.name);
    expect(arg.breed, dogProfile.breed);
    expect(arg.chipId, dogProfile.chipId);
    expect(arg.dateOfBirth, dogProfile.dateOfBirth);
    expect(arg.height, dogProfile.height);
    expect(arg.profileImagePath, dogProfile.profileImagePath);
    expect(arg.castrated, dogProfile.castrated);
  });
}
