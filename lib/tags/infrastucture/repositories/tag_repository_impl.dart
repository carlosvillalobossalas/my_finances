import 'package:my_finances/tags/domain/datasources/tag_datasource.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/tags/domain/repositories/tag_repository.dart';

class TagRepositoryImpl extends TagRepository {
  final TagDataSource dataSource;

  TagRepositoryImpl(this.dataSource);

  @override
  Future<List<Tag>> getTags() {
    return dataSource.getTags();
  }

  @override
  Future<bool> saveTag(Tag tag) {
    return dataSource.saveTag(tag);
  }
}
