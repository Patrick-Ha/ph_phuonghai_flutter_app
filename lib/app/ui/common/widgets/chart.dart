import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    Key? key,
    required this.dateList,
    required this.valueList,
  }) : super(key: key);

  final List<String> dateList;
  final List<double> valueList;

  final List<Color> gradientColors = const [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      clipData: const FlClipData.all(),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (c, v) => const SizedBox(),
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            //reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            //interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      minX: 0,
      //minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: valueList.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value);
          }).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    ));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;

    if (value.toInt() == dateList.length ~/ 3) {
      text = Text(dateList[value.toInt()].substring(11, 16));
    } else if (value.toInt() == (dateList.length ~/ 3) * 2) {
      text = Text(dateList[value.toInt()].substring(11, 16));
    } else if (value.toInt() == dateList.length - 1) {
      text = Text(dateList[value.toInt()].substring(11, 16));
    } else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold);
    String text;
    if (value % 1 == 0) {
      // So nguyen
      text = NumberFormat.compact().format(value.toInt()).toString();
    } else {
      text = '';
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
