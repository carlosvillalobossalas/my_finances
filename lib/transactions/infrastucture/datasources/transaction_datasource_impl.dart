import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_finances/entities/domain/entities/entity.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/transactions/domain/datasources/transaction_datasource.dart';
import 'package:my_finances/transactions/domain/entities/transaction.dart';
import 'package:my_finances/transactions/infrastucture/mappers/transaction_mapper.dart';

class TransactionDataSourceImpl extends TransactionDataSource {
  //   late final Dio dio;
  // TagDataSourceImpl() : dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));
  final db = FirebaseFirestore.instance;
  final collectionName = 'TCTransaction';

  @override
  Future<List<ETransaction>> getTransactions(
      List<Tag> tags, List<Entity> entities) async {
    try {
      final List<ETransaction> transactions = [];
      await db.collection(collectionName).get().then((event) {
        for (var doc in event.docs) {
          Map<String, dynamic> data = doc.data();
          transactions.add(TransactionMapper.transactionJsonToEntity(
              doc.id, data, tags, entities));
        }
      });
      return transactions;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> saveTransaction(ETransaction transaction) async {
    try {
      final response = await db.collection(collectionName).add({
        'amount': transaction.amount,
        'date': transaction.date,
        'detail': transaction.detail,
        'id_entity': transaction.entity.id,
        'id_tag': transaction.tag.id
      });
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
