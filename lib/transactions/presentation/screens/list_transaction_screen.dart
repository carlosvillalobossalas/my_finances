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
    final initialDateController =
        ref.watch(transactionProvider.notifier).initialDateTxtController;
    final endDateController =
        ref.watch(transactionProvider.notifier).endDateTxtController;
    return transactionsState.isLoading
        ? const FullScreenLoader()
        : Column(
            children: [
              SizedBox(
                height: 75,
                // color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextSelectionTheme(
                          data: const TextSelectionThemeData(
                              selectionColor: Colors.transparent),
                          child: TextFormField(
                            controller: initialDateController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today),
                                labelStyle: TextStyle(fontSize: 19),
                                labelText: 'Desde'),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                ref
                                    .read(transactionProvider.notifier)
                                    .onInitialDateChange(DateTime(
                                        pickedDate.year,
                                        pickedDate.month,
                                        pickedDate.day,
                                        0,
                                        1));
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextSelectionTheme(
                          data: const TextSelectionThemeData(
                              selectionColor: Colors.transparent),
                          child: TextFormField(
                            controller: endDateController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today),
                                labelStyle: TextStyle(fontSize: 19),
                                labelText: 'Hasta'),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                // final time = DateTime.now();
                                ref
                                    .read(transactionProvider.notifier)
                                    .onEndDateChange(DateTime(
                                        pickedDate.year,
                                        pickedDate.month,
                                        pickedDate.day,
                                        23,
                                        59));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          '+ Ingresos',
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          '₡${transactionsState.income}',
                          style: const TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          '- Gastos ',
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          '₡${transactionsState.expenses}',
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '= Balance',
                          style: TextStyle(
                              color: transactionsState.balance > 0
                                  ? Colors.green
                                  : Colors.red),
                        ),
                        Text('₡${transactionsState.balance}',
                            style: TextStyle(
                                color: transactionsState.balance > 0
                                    ? Colors.green
                                    : Colors.red))
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
  }
}
