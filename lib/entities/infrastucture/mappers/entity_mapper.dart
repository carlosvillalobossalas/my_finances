import 'package:my_finances/entities/domain/entities/entity.dart';

class EntityMapper {
  static Entity entityJsonToEntity(String id, Map<String, dynamic> json) =>
      Entity(id: id, name: json['nombre'], tag: json['id_tag']);
}
