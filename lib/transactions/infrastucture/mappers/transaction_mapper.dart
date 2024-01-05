import 'package:my_finances/entities/domain/entities/entity.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/transactions/domain/entities/transaction.dart';

class TransactionMapper {
  static ETransaction transactionJsonToEntity(String id,
          Map<String, dynamic> json, List<Tag> tags, List<Entity> entities) =>
      ETransaction(
        id: id,
        tag: tags.firstWhere((tag) => tag.id == json['id_tag']),
        entity: entities.firstWhere((entity) => entity.id == json['id_entity']),
        detail: json['detail'],
        amount: json['amount'],
        type: json['type'],
        date: json['date'].toDate(),
      );
}
