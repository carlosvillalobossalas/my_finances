import 'package:my_finances/csv/domain/datasources/csv_datasource.dart';
import 'package:my_finances/csv/domain/entities/tag.dart';
import 'package:my_finances/csv/domain/repositories/csv_repository.dart';

class CsvRepositoryImpl extends CsvRepository {
  final CsvDataSource dataSource;

  CsvRepositoryImpl(this.dataSource);

  @override
  Future<List<Tag>> getCsvTags() {
    return dataSource.getCsvTags();
  }
}
