import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/helpers/currency_formatter.dart';
import 'package:my_finances/tags/domain/entities/grouped_tag.dart';

class PieChartWidget extends ConsumerWidget {
  final List<GroupedTag> dataList;
  const PieChartWidget({super.key, required this.dataList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<PieChartSectionData> data = List.generate(dataList.length, (index) {
      GroupedTag groupedTag = dataList[index];
      String title =
          '${groupedTag.tag.name} - ₡ ${CurrencyFormatter.colonFormat(groupedTag.totalAmount)}';
      return PieChartSectionData(
        color: Color(int.parse('0x${groupedTag.tag.color}')),
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
    return FadeIn(
      child: SizedBox(
        // color: Colors.red,
        height: 275,
        child: PieChart(PieChartData(
          sections: data,
          centerSpaceRadius: 75,
        )),
      ),
    );
  }
}
