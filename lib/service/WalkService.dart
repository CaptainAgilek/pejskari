import 'package:pejskari/data/Walk.dart';
import 'package:pejskari/entity/WalkEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/WalkRepositoryImpl.dart';

/// Service for operations with walk..
class WalkService {
  CrudRepository<WalkEntity> _repository = WalkRepositoryImpl();

  set repository(CrudRepository<WalkEntity> repository) {
    _repository = repository;
  }

  Future<List<Walk>> getAll() async {
    List<WalkEntity> entities = await _repository.getAll();
    var vetVisits = entities
        .map((e) =>
            Walk(e.id, e.date, e.notes, e.distance, e.time, e.dogProfilesIds))
        .toList();
    return vetVisits;
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
  }

  Future<Walk> create(Walk walk) async {
    var inserted = await _repository.insert(WalkEntity(walk.id, walk.date,
        walk.notes, walk.distance, walk.time, walk.dogProfilesIds));
    return Walk(inserted.id, inserted.date, inserted.notes, inserted.distance,
        inserted.time, inserted.dogProfilesIds);
  }

  Future<void> update(Walk walk) async {
    return await _repository.update(WalkEntity(walk.id, walk.date, walk.notes,
        walk.distance, walk.time, walk.dogProfilesIds));
  }
}
