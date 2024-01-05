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
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: transactionsState.transactions.length,
                  itemBuilder: (context, index) {
                    ETransaction transaction =
                        transactionsState.transactions[index];
                    final operator = transaction.type == 'Gastos' ? '-' : '+';

                    return ExpansionTile(
                      title: Text(
                          '$operator ₡${CurrencyFormatter.colonFormat(transaction.amount)}',
                          style: TextStyle(
                              color: transaction.type == 'Gastos'
                                  ? Colors.red
                                  : Colors.green)),
                      subtitle: Text(
                        transaction.tag.name,
                        style: TextStyle(
                            color:
                                Color(int.parse('0x${transaction.tag.color}'))),
                      ),
                      trailing: IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete)),
                      expandedAlignment: Alignment.centerLeft,
                      children: [
                        ListTile(
                          title: Text(
                              '${transaction.entity.name}: ${transaction.detail}'),
                          subtitle:
                              Text(transaction.date.toString().split(' ')[0]),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                height: 75,
                color: Colors.grey[100],
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Ingresos +',
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          '₡3000',
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                    //TODO: agregar fechas
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Gastos - ',
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          '₡1000',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text('Balance ='), Text('₡2000')],
                    )
                  ],
                ),
              ),
            ],
          );
  }
}
