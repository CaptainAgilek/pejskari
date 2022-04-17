import 'package:pejskari/data/Vaccination.dart';
import 'package:pejskari/entity/VaccinationEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/VaccinationRepositoryImpl.dart';

/// Service for operations with vaccination.
class VaccinationService {
  CrudRepository<VaccinationEntity> _repository =
      VaccinationRepositoryImpl();

  set repository(CrudRepository<VaccinationEntity> repository) {
    _repository = repository;
  }

  Future<List<Vaccination>> getAll() async {
    List<VaccinationEntity> entities = await _repository.getAll();
    var vaccinations = entities
        .map((e) => Vaccination(
            e.id, e.name, e.date, e.notes, e.dogProfileId))
        .toList();
    return vaccinations;
  }

  Future<Vaccination> create(Vaccination vaccination) async {
    var inserted = await _repository.insert(VaccinationEntity(
        vaccination.id,
        vaccination.name,
        vaccination.date,
        vaccination.notes,
        vaccination.dogProfileId));
    return Vaccination(inserted.id, inserted.name, inserted.date, inserted.notes, inserted.dogProfileId);
  }

  Future<void> update(Vaccination vaccination) async {
    return await _repository.update(VaccinationEntity(
        vaccination.id,
        vaccination.name,
        vaccination.date,
        vaccination.notes,
        vaccination.dogProfileId));
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
  }

}
