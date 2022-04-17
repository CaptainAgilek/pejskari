import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Walk.dart';

/// Class for transferring walk data between pages.
class WalkEditPageArgs {
  final Walk walk;
  final List<DogProfile> dogProfiles;

  WalkEditPageArgs(this.walk, this.dogProfiles);
}