import 'package:my_finances/csv/domain/entities/tag.dart';

abstract class CsvDataSource {
  Future<List<Tag>> getCsvTags();
}
