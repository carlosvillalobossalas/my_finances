import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/full_screen_loader.dart';
import 'package:my_finances/helpers/currency_formatter.dart';
import 'package:my_finances/transactions/domain/entities/transaction.dart';
import 'package:my_finances/transactions/presentation/providers/transaction_provider.dart';

class ListTransactionScreen extends ConsumerWidget {
  const ListTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsState = ref.watch(transactionProvider);
    return transactionsState.isLoading
        ? const FullScreenLoader()
        : ListView.builder(
            itemCount: transactionsState.transactions.length,
            itemBuilder: (context, index) {
              ETransaction transaction = transactionsState.transactions[index];
              return ExpansionTile(
                title: Text(
                    '₡${CurrencyFormatter.colonFormat(transaction.amount)}',
                    style: const TextStyle(color: Colors.red)),
                subtitle: Text(
                  transaction.tag.name,
                  style: TextStyle(
                      color: Color(int.parse('0x${transaction.tag.color}'))),
                ),
                trailing: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.delete)),
                expandedAlignment: Alignment.centerLeft,
                children: [
                  ListTile(
                    title: Text(
                        '${transaction.entity.name}: ${transaction.detail}'),
                    subtitle: Text(transaction.date.toString().split(' ')[0]),
                  ),
                ],
              );
            },
          );
  }
}
