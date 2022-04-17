import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/pages/DogWeight/DogWeightRecordsTab.dart';

/// Class for transferring data between pages.
class DogWeightEditPageArgs {
  DogWeightAndProfile? dogWeightAndProfile;
  List<DogProfile> dogProfiles;

  DogWeightEditPageArgs(this.dogWeightAndProfile, this.dogProfiles);
}