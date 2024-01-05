import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_finances/entities/domain/datasources/entity_datasource.dart';
import 'package:my_finances/entities/domain/entities/entity.dart';
import 'package:my_finances/entities/infrastucture/mappers/entity_mapper.dart';

class EntityDataSourceImpl extends EntityDataSource {
  //   late final Dio dio;
  // TagDataSourceImpl() : dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));
  final db = FirebaseFirestore.instance;
  final collectionName = 'TCEntity';

  @override
  Future<List<Entity>> getEntities() async {
    try {
      final List<Entity> entities = [];
      await db.collection(collectionName).get().then((event) {
        for (var doc in event.docs) {
          Map<String, dynamic> data = doc.data();
          entities.add(EntityMapper.entityJsonToEntity(doc.id, data));
        }
      });
      return entities;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> saveEntity(Entity entity) async {
    try {
      final response = await db.collection(collectionName).add({
        'nombre': entity.name,
        'id_tag': entity.tag,
      });
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
