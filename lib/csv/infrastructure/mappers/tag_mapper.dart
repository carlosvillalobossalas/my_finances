import 'package:my_finances/csv/domain/entities/tag.dart';
import 'package:my_finances/csv/domain/entities/transaction.dart';
import 'package:my_finances/csv/infrastructure/mappers/transaction_mapper.dart';

class TagMapper {
  static Tag tagJsonToEntity(String id, Map<String, dynamic> json) => Tag(
      name: json['nombre'],
      transactions: List<Transaction>.from(json['transacciones']
          .map((x) => TransactionMapper.transactionJsonToEntity(x))),
      totalAmount: json['montoTotal']);
}
