/// Base class for entities. Provides id and toMap().
abstract class BaseEntity {
  int id;

  Map<String, dynamic> toMap();

  BaseEntity(this.id);
}
