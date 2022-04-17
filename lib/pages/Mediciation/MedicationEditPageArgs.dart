import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Medication.dart';

/// Class for transferring data between pages.
class MedicationEditPageArgs {
  final Medication medication;
  final List<DogProfile> dogProfiles;

  MedicationEditPageArgs(this.medication, this.dogProfiles);
}