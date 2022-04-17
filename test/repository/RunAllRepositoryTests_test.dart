import './DogProfileRepositoryImpl_test.dart' as DogProfileRepositoryImplTest;
import './DogWeightRepositoryImpl_test.dart' as DogWeightRepositoryImplTest;
import './MedicationRepositoryImpl_test.dart' as MedicationRepositoryImplTest;
import './NotificationRepositoryImpl_test.dart' as NotificationRepositoryImplTest;
import './VaccinationRepositoryImpl_test.dart' as VaccinationRepositoryImplTest;
import './VetRepositoryImpl_test.dart' as VetRepositoryImplTest;
import './VetVisitRepositoryImpl_test.dart' as VetVisitRepositoryImplTest;
import './WalkRepositoryImpl_test.dart' as WalkRepositoryImplTest;

//RUN VIA COMMAND ON DEVICE: flutter run test/repository/RunAllRepositoryTests_test.dart
Future<void> main() async {
  DogProfileRepositoryImplTest.main();

  DogWeightRepositoryImplTest.main();

  MedicationRepositoryImplTest.main();

  NotificationRepositoryImplTest.main();

  VaccinationRepositoryImplTest.main();

  VetRepositoryImplTest.main();

  VetVisitRepositoryImplTest.main();

  WalkRepositoryImplTest.main();

}