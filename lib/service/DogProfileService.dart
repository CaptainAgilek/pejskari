import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/entity/DogProfileEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/DogProfileRepositoryImpl.dart';

/// Service for operations with dog profile.
class DogProfileService {
  CrudRepository<DogProfileEntity> _repository = DogProfileRepositoryImpl();

  set repository(CrudRepository<DogProfileEntity> repository) {
    _repository = repository;
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
  }

  Future<List<DogProfile>> getAll() async {
    List<DogProfileEntity> entities = await _repository.getAll();
    var dogProfiles = entities
        .map((e) => DogProfile(e.id, e.name, e.breed, e.chipId, e.dateOfBirth,
            e.height, e.profileImagePath, e.gender, e.castrated))
        .toList();
    return dogProfiles;
  }

  Future<DogProfile> create(DogProfile dogProfile) async {
    var inserted = await _repository.insert(DogProfileEntity(
        dogProfile.id,
        dogProfile.name,
        dogProfile.breed,
        dogProfile.chipId,
        dogProfile.dateOfBirth,
        dogProfile.height,
        dogProfile.profileImagePath,
        dogProfile.gender,
        dogProfile.castrated));
    return DogProfile(
        inserted.id,
        inserted.name,
        inserted.breed,
        inserted.chipId,
        inserted.dateOfBirth,
        inserted.height,
        inserted.profileImagePath,
        inserted.gender,
        inserted.castrated);
  }

  Future<void> update(DogProfile dogProfile) async {
    return await _repository.update(DogProfileEntity(
        dogProfile.id,
        dogProfile.name,
        dogProfile.breed,
        dogProfile.chipId,
        dogProfile.dateOfBirth,
        dogProfile.height,
        dogProfile.profileImagePath,
        dogProfile.gender,
        dogProfile.castrated));
  }
}
