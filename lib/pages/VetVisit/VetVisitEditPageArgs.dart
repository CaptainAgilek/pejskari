import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Vet.dart';
import 'package:pejskari/pages/VetVisit/VetVisitEnhancedData.dart';

/// Class for transferring vet visit data between pages.
class VetVisitEditPageArgs {
  VetVisitEnhancedData? vetVisitAndDogProfile;
  List<DogProfile> dogProfiles;
  List<Vet> vets;

  VetVisitEditPageArgs(this.vetVisitAndDogProfile, this.dogProfiles, this.vets);
}