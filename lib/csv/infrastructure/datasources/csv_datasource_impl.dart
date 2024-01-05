import 'package:my_finances/config/constants/environment.dart';
import 'package:my_finances/csv/domain/datasources/csv_datasource.dart';
import 'package:my_finances/csv/domain/entities/tag.dart';
import 'package:dio/dio.dart';
// import 'package:my_finances/csv/infrastructure/mappers/tag_mapper.dart';

class CsvDataSourceImpl extends CsvDataSource {
  late final Dio dio;
  CsvDataSourceImpl() : dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<List<Tag>> getCsvTags() async {
    try {
      final List<Tag> tags = [];
      print(Environment.apiUrl);
      // final response = await dio.get<List>('/getData');
      // for (var tag in response.data ?? []) {
      //   // tags.add(TagMapper.tagJsonToEntity(tag));
      // }
      return tags;
    } catch (e) {
      throw Exception(e);
    }
  }
}
