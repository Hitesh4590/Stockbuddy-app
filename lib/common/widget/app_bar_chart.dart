import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppBarChart extends StatelessWidget {
  AppBarChart(BarChartData barChartData);

  @override
  Widget build(BuildContext context) {
    return AppBarChart(
      BarChartData(
        gridData:
            const FlGridData(drawHorizontalLine: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        /*barGroups: List.generate(filteredData.length, (index) {
          return BarChartGroupData(
            x: filteredData[index]["id"],
            barRods: [
              BarChartRodData(
                toY: filteredData[index]["value"],
                color: _selectedOption == 'Sales'
                    ? Colors.deepOrangeAccent
                    : Colors.green,
                width: 25,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),*/
      ),
    );
  }
}
