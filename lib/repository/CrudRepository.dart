import 'package:pejskari/entity/BaseEntity.dart';

/// Interface for CRUD repository.
abstract class CrudRepository<T extends BaseEntity> {
  Future<T> insert(T entity);
  Future<T?> get(int id);
  Future<List<T>> getAll();
  Future<void> update(T entity);
  Future<void> delete(int id);
}