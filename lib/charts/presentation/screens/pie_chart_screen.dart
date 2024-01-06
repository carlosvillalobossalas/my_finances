import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/full_screen_loader.dart';
import 'package:my_finances/helpers/currency_formatter.dart';
import 'package:my_finances/helpers/get_random_color.dart';
import 'package:my_finances/tags/domain/entities/grouped_tag.dart';
import 'package:my_finances/transactions/presentation/providers/transaction_provider.dart';

class PieChartScreen extends ConsumerWidget {
  const PieChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsState = ref.watch(transactionProvider);
    final expensesList = transactionsState.groupedTransactions
        .where((group) => group.totalAmount < 0)
        .toList();
    final initialDateController =
        ref.watch(transactionProvider.notifier).initialDateTxtController;
    final endDateController =
        ref.watch(transactionProvider.notifier).endDateTxtController;
    final colors = Theme.of(context).colorScheme;

    List<PieChartSectionData> data =
        List.generate(expensesList.length, (index) {
      GroupedTag groupedTag = expensesList[index];
      String title =
          '${groupedTag.tag.name} - ₡ ${CurrencyFormatter.colonFormat(groupedTag.totalAmount)}';
      return PieChartSectionData(
        color: RandomColor.get(),
        value: groupedTag.totalAmount,
        title: title,
        titleStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.grey[50],
        ),
        radius: 50,
      );
    });

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
                      ],
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                  // color: Colors.red,
                  height: 350,
                  child: PieChart(PieChartData(
                    sections: data,
                    centerSpaceRadius: 50,
                  )),
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
