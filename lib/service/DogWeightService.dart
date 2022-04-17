import 'package:pejskari/data/DogWeight.dart';
import 'package:pejskari/entity/DogWeightEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/DogWeightRepositoryImpl.dart';

/// Service for operations with dog weight.
class DogWeightService {
  CrudRepository<DogWeightEntity> _repository = DogWeightRepositoryImpl();

  set repository(CrudRepository<DogWeightEntity> repository) {
    _repository = repository;
  }

  Future<List<DogWeight>> getAll() async {
    List<DogWeightEntity> entities = await _repository.getAll();
    var dogWeights = entities
        .map((e) => DogWeight(e.id, e.weight, e.date, e.notes, e.dogProfileId))
        .toList();
    return dogWeights;
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
  }

  Future<DogWeight> create(DogWeight dogWeight) async {
    var inserted = await _repository.insert(DogWeightEntity(
        dogWeight.id,
        dogWeight.weight,
        dogWeight.date,
        dogWeight.notes,
        dogWeight.dogProfileId));
    return DogWeight(inserted.id, inserted.weight, inserted.date,
        inserted.notes, dogWeight.dogProfileId);
  }

  Future<void> update(DogWeight dogWeight) async {
    return await _repository.update(DogWeightEntity(
        dogWeight.id,
        dogWeight.weight,
        dogWeight.date,
        dogWeight.notes,
        dogWeight.dogProfileId));
  }
}
