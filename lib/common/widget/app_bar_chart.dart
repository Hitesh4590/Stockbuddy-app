import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AppBarChart extends StatelessWidget {
  AppBarChart(BarChartData barChartData);

  @override
  Widget build(BuildContext context) {
    return AppBarChart(
      BarChartData(
        gridData:
            const FlGridData(drawHorizontalLine: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }
}
