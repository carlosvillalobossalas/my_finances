import 'package:my_finances/entities/domain/entities/entity.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';

class ETransaction {
  final String id;
  final Tag tag;
  final Entity entity;
  final String detail;
  final double amount;
  final DateTime date;
  final String type;

  ETransaction(
      {required this.id,
      required this.tag,
      required this.entity,
      required this.detail,
      required this.amount,
      required this.date,
      required this.type});
}
