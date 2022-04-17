import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Vet.dart';
import 'package:pejskari/data/VetVisit.dart';

/// Class with vet visit data paired with dog profile and vet data.
class VetVisitEnhancedData {
  VetVisit vetVisit;
  DogProfile dogProfile;
  Vet vet;

  VetVisitEnhancedData(this.vetVisit, this.dogProfile, this.vet);
}