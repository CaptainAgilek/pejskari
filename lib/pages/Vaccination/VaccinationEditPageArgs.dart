import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Vaccination.dart';

/// Class for transferring vaccination data between pages.
class VaccinationEditPageArgs {
  final Vaccination vaccination;
  final List<DogProfile> dogProfiles;

  VaccinationEditPageArgs(this.vaccination, this.dogProfiles);
}