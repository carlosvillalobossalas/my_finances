import 'package:my_finances/csv/domain/entities/transaction.dart';

class TransactionMapper {
  static Transaction transactionJsonToEntity(Map<String, dynamic> json) =>
      Transaction(
          name: json['nombre'], date: json['fecha'], amount: json['monto']);
}
