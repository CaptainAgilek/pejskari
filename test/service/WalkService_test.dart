import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pejskari/data/Walk.dart';
import 'package:pejskari/entity/WalkEntity.dart';
import 'package:pejskari/repository/WalkRepositoryImpl.dart';
import 'package:pejskari/service/WalkService.dart';
import 'package:test/test.dart';

import 'WalkService_test.mocks.dart';

@GenerateMocks([WalkRepositoryImpl])
void main() {
  test('Get all', () async {
    //GIVEN
    final WalkService tested = WalkService();
    final mockRepository = MockWalkRepositoryImpl();

    List<WalkEntity> walks = [
      WalkEntity(2, "17.5.2021", "poznámky", 20.5, 3000, [1, 2]),
      WalkEntity(3, "17.4.2021", "poznámky2", 25.4, 3500, [2, 3]),
    ];

    when(mockRepository.getAll()).thenAnswer((_) async => walks);
    tested.repository = mockRepository;

    //WHEN
    var result = await tested.getAll();

    //THEN
    verify(mockRepository.getAll()).called(1);
    expect(result.length, walks.length);

    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, walks[i].id);
      expect(result[i].date, walks[i].date);
      expect(result[i].notes, walks[i].notes);
      expect(result[i].distance, walks[i].distance);
      expect(result[i].time, walks[i].time);
      expect(result[i].dogProfilesIds, walks[i].dogProfilesIds);
    }
  });

  test('Delete', () async {
    //GIVEN
    final WalkService tested = WalkService();
    final mockRepository = MockWalkRepositoryImpl();

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
    final WalkService tested = WalkService();
    final mockRepository = MockWalkRepositoryImpl();

    var walk = Walk(2, "17.5.2021", "poznámky", 20.5, 3000, [1, 2]);

    when(mockRepository.insert(argThat(isA<WalkEntity>())))
        .thenAnswer((arg) async {
      return arg.positionalArguments[0];
    });

    tested.repository = mockRepository;

    //WHEN
    var result = await tested.create(walk);

    //THEN
    verify(mockRepository.insert(argThat(isA<WalkEntity>()))).called(1);
    expect(result.id, walk.id);
    expect(result.date, walk.date);
    expect(result.notes, walk.notes);
    expect(result.distance, walk.distance);
    expect(result.time, walk.time);
    expect(result.dogProfilesIds, walk.dogProfilesIds);
  });

  test('Update', () async {
    //GIVEN
    final WalkService tested = WalkService();
    final mockRepository = MockWalkRepositoryImpl();

    var walk = Walk(2, "17.5.2021", "poznámky", 20.5, 3000, [1, 2]);

    when(mockRepository.update(argThat(isA<WalkEntity>())))
        .thenAnswer((_) async {});

    tested.repository = mockRepository;

    //WHEN
    await tested.update(walk);

    //THEN
    var verificationResult =
        verify(mockRepository.update(captureThat(isA<WalkEntity>())))
          ..called(1);
    var arg = verificationResult.captured.first;

    expect(arg.id, walk.id);
    expect(arg.date, walk.date);
    expect(arg.notes, walk.notes);
    expect(arg.distance, walk.distance);
    expect(arg.time, walk.time);
    expect(arg.dogProfilesIds, walk.dogProfilesIds);
  });
}
