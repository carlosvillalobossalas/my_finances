import 'package:my_finances/tags/domain/entities/tag.dart';

class TagMapper {
  static Tag tagJsonToEntity(String id, Map<String, dynamic> json) =>
      Tag(id: id, name: json['nombre'], color: json['color']);
}
