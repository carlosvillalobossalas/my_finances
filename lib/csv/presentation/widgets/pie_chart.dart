import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_finances/csv/presentation/providers/csv_provider.dart';
import 'package:my_finances/helpers/get_random_color.dart';

class MyPieChart extends ConsumerWidget {
  const MyPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final csvState = ref.watch(csvProvider);
    final filteredTags = csvState.tags
        .where((tag) =>
            tag.totalAmount >= csvState.rangeValues.start &&
            tag.totalAmount <= csvState.rangeValues.end)
        .toList();
    List<PieChartSectionData> secciones =
        List.generate(filteredTags.length, (index) {
      var formatter = NumberFormat.currency(locale: 'es_CR', symbol: '');
      String value = formatter.format(filteredTags[index].totalAmount);

      String title = '${filteredTags[index].name} - ₡ $value';
      return PieChartSectionData(
        color: RandomColor.get(),
        value: filteredTags[index].totalAmount.toDouble(),
        // title: csvState.tags[index].totalAmount.toStringAsFixed(2),
        title: title,
        titleStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.grey[50],
        ),
        radius: 350,
      );
    });

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            // color: Colors.red,
            height: 850,
            child: PieChart(PieChartData(
              sections: secciones,
              centerSpaceRadius: 50,
            )),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RangeSlider(
                values: csvState.rangeValues,
                max: 400000,
                divisions: 20,
                labels: RangeLabels(
                  csvState.rangeValues.start.round().toString(),
                  csvState.rangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  ref.watch(csvProvider.notifier).updateRangeValues(values);
                })
          ]),
        ],
      ),
    );
  }
}
