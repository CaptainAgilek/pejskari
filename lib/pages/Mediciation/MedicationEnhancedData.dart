import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Medication.dart';

/// Class with medication data paired with dog profile data.
class MedicationEnhancedData {
  final Medication medication;
  final DogProfile dogProfile;

  MedicationEnhancedData(this.medication, this.dogProfile);
}