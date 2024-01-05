import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/entities/domain/repositories/entity_repository.dart';
import 'package:my_finances/entities/infrastucture/datasources/entity_datasource_impl.dart';
import 'package:my_finances/entities/infrastucture/repositories/entity_repository_impl.dart';

final entityRepositoryProvider = Provider<EntityRepository>((ref) {
  final entityRepository = EntityRepositoryImpl(EntityDataSourceImpl());
  return entityRepository;
});
