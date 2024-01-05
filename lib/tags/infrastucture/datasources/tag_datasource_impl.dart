import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_finances/tags/domain/datasources/tag_datasource.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/tags/infrastucture/mappers/tag_mapper.dart';

class TagDataSourceImpl extends TagDataSource {
  CollectionReference tagsRef = FirebaseFirestore.instance.collection('TCTags');

  @override
  Future<List<Tag>> getTags() async {
    try {
      final List<Tag> tags = [];
      await tagsRef.get().then((event) {
        for (var doc in event.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          tags.add(TagMapper.tagJsonToEntity(doc.id, data));
        }
      });
      return tags;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> saveTag(Tag tag) async {
    try {
      final response = await tagsRef.add({
        'nombre': tag.name,
        'color': tag.color,
      });
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
