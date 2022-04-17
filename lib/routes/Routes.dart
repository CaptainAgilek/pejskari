import 'package:pejskari/pages/Articles/ArticlesPage.dart';
import 'package:pejskari/pages/DogProfile/DogProfileDetailPage.dart';
import 'package:pejskari/pages/DogProfile/DogProfileEditPage.dart';
import 'package:pejskari/pages/DogProfile/DogProfilesPage.dart';
import 'package:pejskari/pages/DogWeight/DogWeightDetailPage.dart';
import 'package:pejskari/pages/DogWeight/DogWeightEditPage.dart';
import 'package:pejskari/pages/DogWeight/DogWeightPage.dart';
import 'package:pejskari/pages/Help/HelpPage.dart';
import 'package:pejskari/pages/HomePage/HomePage.dart';
import 'package:pejskari/pages/Mediciation/MedicationDetailPage.dart';
import 'package:pejskari/pages/Mediciation/MedicationEditPage.dart';
import 'package:pejskari/pages/Mediciation/MedicationsPage.dart';
import 'package:pejskari/pages/Notification/NotificationEditPage.dart';
import 'package:pejskari/pages/Notification/NotificationsPage.dart';
import 'package:pejskari/pages/Vaccination/VaccinationDetailPage.dart';
import 'package:pejskari/pages/Vaccination/VaccinationEditPage.dart';
import 'package:pejskari/pages/Vaccination/VaccinationsPage.dart';
import 'package:pejskari/pages/Vet/VetDetailPage.dart';
import 'package:pejskari/pages/Vet/VetEditPage.dart';
import 'package:pejskari/pages/Vet/VetsPage.dart';
import 'package:pejskari/pages/VetVisit/VetVisitDetailPage.dart';
import 'package:pejskari/pages/VetVisit/VetVisitEditPage.dart';
import 'package:pejskari/pages/VetVisit/VetVisitPage.dart';
import 'package:pejskari/pages/Walk/WalkDetailPage.dart';
import 'package:pejskari/pages/Walk/WalkEditPage.dart';
import 'package:pejskari/pages/Walk/WalkPage.dart';
import 'package:pejskari/pages/Walk/WalksPage.dart';

class Routes {
  static const String homePage = HomePage.routeName;

  static const String dogProfiles = DogProfilesPage.routeName;
  static const String dogProfileEdit = DogProfileEditPage.routeName;
  static const String dogProfileDetail = DogProfileDetailPage.routeName;

  static const String dogWeightPage = DogWeightPage.routeName;
  static const String dogWeightEditPage = DogWeightEditPage.routeName;
  static const String dogWeightDetailPage = DogWeightDetailPage.routeName;

  static const String vetVisitPage = VetVisitPage.routeName;
  static const String vetVisitEditPage = VetVisitEditPage.routeName;
  static const String vetVisitDetailPage = VetVisitDetailPage.routeName;

  static const String walkPage = WalkPage.routeName;
  static const String walksPage = WalksPage.routeName;
  static const String walkEditPage = WalkEditPage.routeName;
  static const String walkDetailPage = WalkDetailPage.routeName;

  static const String vaccinationsPage = VaccinationsPage.routeName;
  static const String vaccinationEditPage = VaccinationEditPage.routeName;
  static const String vaccinationDetailPage = VaccinationDetailPage.routeName;

  static const String notificationsPage = NotificationsPage.routeName;
  static const String notificationsEditPage = NotificationEditPage.routeName;

  static const String vetsPage = VetsPage.routeName;
  static const String vetEditPage = VetEditPage.routeName;
  static const String vetDetailPage = VetDetailPage.routeName;

  static const String medicationsPage = MedicationsPage.routeName;
  static const String medicationEditPage = MedicationEditPage.routeName;
  static const String medicationDetailPage = MedicationDetailPage.routeName;

  static const String articlesPage = ArticlesPage.routeName;

  static const String helpPage = HelpPage.routeName;

}