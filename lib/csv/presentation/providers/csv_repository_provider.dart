import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/csv/domain/repositories/csv_repository.dart';
import 'package:my_finances/csv/infrastructure/datasources/csv_datasource_impl.dart';
import 'package:my_finances/csv/infrastructure/repositories/csv_repository_impl.dart';

final csvRepositoryProvider = Provider<CsvRepository>((ref) {
  final csvRepository = CsvRepositoryImpl(CsvDataSourceImpl());
  return csvRepository;
});
