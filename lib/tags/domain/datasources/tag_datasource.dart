import 'package:my_finances/tags/domain/entities/tag.dart';

abstract class TagDataSource {
  Future<List<Tag>> getTags();
  Future<bool> saveTag(Tag tag);
}
