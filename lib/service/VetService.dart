import 'package:pejskari/data/Vet.dart';
import 'package:pejskari/entity/VetEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/VetRepositoryImpl.dart';

/// Service for operations with vet.
class VetService {
  CrudRepository<VetEntity> _repository = VetRepositoryImpl();

  set repository(CrudRepository<VetEntity> repository) {
    _repository = repository;
  }

  Future<List<Vet>> getAll() async {
    List<VetEntity> entities = await _repository.getAll();
    var vets =
        entities.map((e) => Vet(e.id, e.name, e.phone, e.notes)).toList();
    return vets;
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
  }

  Future<Vet> create(Vet vet) async {
    var inserted = await _repository.insert(VetEntity(
      vet.id,
      vet.name,
      vet.phone,
      vet.notes,
    ));
    return Vet(inserted.id, inserted.name, inserted.phone, inserted.notes);
  }

  Future<void> update(Vet vet) async {
    return await _repository.update(VetEntity(
      vet.id,
      vet.name,
      vet.phone,
      vet.notes,
    ));
  }
}
