import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Vaccination.dart';

/// Vaccination data with dog profile.
class VaccinationAndDogProfile {
  final Vaccination vaccination;
  final DogProfile dogProfile;

  VaccinationAndDogProfile(this.vaccination, this.dogProfile);
}