import 'package:my_finances/entities/domain/datasources/entity_datasource.dart';
import 'package:my_finances/entities/domain/entities/entity.dart';
import 'package:my_finances/entities/domain/repositories/entity_repository.dart';

class EntityRepositoryImpl extends EntityRepository {
  final EntityDataSource dataSource;

  EntityRepositoryImpl(this.dataSource);

  @override
  Future<List<Entity>> getEntities() {
    return dataSource.getEntities();
  }

  @override
  Future<bool> saveEntity(Entity entity) {
    return dataSource.saveEntity(entity);
  }
}
