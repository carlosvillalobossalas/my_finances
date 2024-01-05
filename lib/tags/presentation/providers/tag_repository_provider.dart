import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/tags/domain/repositories/tag_repository.dart';
import 'package:my_finances/tags/infrastucture/datasources/tag_datasource_impl.dart';
import 'package:my_finances/tags/infrastucture/repositories/tag_repository_impl.dart';

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final tagRepository = TagRepositoryImpl(TagDataSourceImpl());
  return tagRepository;
});
