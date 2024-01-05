import 'package:my_finances/entities/domain/entities/entity.dart';

abstract class EntityRepository {
  Future<List<Entity>> getEntities();
  Future<bool> saveEntity(Entity entity);
}
