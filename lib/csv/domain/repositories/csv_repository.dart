import 'package:my_finances/csv/domain/entities/tag.dart';

abstract class CsvRepository {
  Future<List<Tag>> getCsvTags();
}
