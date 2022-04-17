import 'package:pejskari/data/Medication.dart';
import 'package:pejskari/entity/MedicationEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/MedicationRepositoryImpl.dart';

/// Service for operations with medication.
class MedicationService {
  CrudRepository<MedicationEntity> _repository =
      MedicationRepositoryImpl();

  set repository(CrudRepository<MedicationEntity> repository) {
    _repository = repository;
  }

  Future<List<Medication>> getAll() async {
    List<MedicationEntity> entities = await _repository.getAll();
    var medications = entities
        .map((e) =>
            Medication(e.id, e.name, e.dateTime, e.notes, e.dogProfileId))
        .toList();
    return medications;
  }

  Future<Medication> create(Medication medication) async {
    var inserted = await _repository.insert(MedicationEntity(
        medication.id,
        medication.name,
        medication.dateTime,
        medication.notes,
        medication.dogProfileId));
    return Medication(inserted.id, inserted.name, inserted.dateTime,
        inserted.notes, inserted.dogProfileId);
  }

  Future<void> update(Medication medication) async {
    return await _repository.update(MedicationEntity(
        medication.id, medication.name, medication.dateTime, medication.notes, medication.dogProfileId));
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
  }
}
