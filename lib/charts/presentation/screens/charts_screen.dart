import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/charts/presentation/widget/pie_chart_widget.dart';
import 'package:my_finances/full_screen_loader.dart';
import 'package:my_finances/transactions/presentation/providers/transaction_provider.dart';

class ChartsScreen extends ConsumerWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsState = ref.watch(transactionProvider);
    final dataList = transactionsState.groupedTransactions
        .where((group) => transactionsState.changeView
            ? group.totalAmount < 0
            : group.totalAmount > 0)
        .toList();

    final initialDateController =
        ref.watch(transactionProvider.notifier).initialDateTxtController;
    final endDateController =
        ref.watch(transactionProvider.notifier).endDateTxtController;
    final colors = Theme.of(context).colorScheme;

    return transactionsState.isLoading
        ? const FullScreenLoader()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Gráfico'),
              titleTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 20),
              backgroundColor: colors.primary,
              leading: IconButton(
                  onPressed: () {
                    // ref.read(orderFormProvider.notifier).clearForm();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
            body: Column(
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
                        IconButton(
                            onPressed: () {
                              ref
                                  .read(transactionProvider.notifier)
                                  .onTransactionViewChange();
                            },
                            icon: Icon(
                              Icons.monetization_on,
                              color: transactionsState.changeView
                                  ? Colors.red
                                  : Colors.green,
                              size: 30,
                            ))
                      ],
                    ),
                  ),
                ),
                const Divider(),
                dataList.isNotEmpty
                    ? Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              transactionsState.changeView
                                  ? 'Gastos'
                                  : 'Ingresos',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            PieChartWidget(
                              dataList: dataList,
                            ),
                          ],
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: Text('Sin data',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 20)),
                        ),
                      ),
                // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //   RangeSlider(
                //       values: csvState.rangeValues,
                //       max: 400000,
                //       divisions: 20,
                //       labels: RangeLabels(
                //         csvState.rangeValues.start.round().toString(),
                //         csvState.rangeValues.end.round().toString(),
                //       ),
                //       onChanged: (RangeValues values) {
                //         ref
                //             .watch(csvProvider.notifier)
                //             .updateRangeValues(values);
                //       })
                // ]),
              ],
            ),
          );
  }
}
