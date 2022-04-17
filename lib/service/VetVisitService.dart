import 'package:pejskari/data/VetVisit.dart';
import 'package:pejskari/entity/VetVisitEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/VetVisitRepositoryImpl.dart';

/// Service for operations with vet visit..
class VetVisitService {
  CrudRepository<VetVisitEntity> _repository = VetVisitRepositoryImpl();

  set repository(CrudRepository<VetVisitEntity> repository) {
    _repository = repository;
  }

  Future<List<VetVisit>> getAll() async {
    List<VetVisitEntity> entities = await _repository.getAll();
    var vetVisits = entities
        .map((e) => VetVisit(
            e.id, e.date, e.notes, e.vetId, e.dogProfileId, e.documentPaths))
        .toList();
    return vetVisits;
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
  }

  Future<VetVisit> create(VetVisit vetVisit) async {
    var inserted = await _repository.insert(VetVisitEntity(
        vetVisit.id,
        vetVisit.date,
        vetVisit.notes,
        vetVisit.vetId,
        vetVisit.dogProfileId,
        vetVisit.documentPaths));
    return VetVisit(inserted.id, inserted.date, inserted.notes, inserted.vetId,
        inserted.dogProfileId, inserted.documentPaths);
  }

  Future<void> update(VetVisit vetVisit) async {
    return await _repository.update(VetVisitEntity(
        vetVisit.id,
        vetVisit.date,
        vetVisit.notes,
        vetVisit.vetId,
        vetVisit.dogProfileId,
        vetVisit.documentPaths));
  }
}
