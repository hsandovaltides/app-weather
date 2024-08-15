import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weatherapp/helper/date_helper.dart';
import 'package:weatherapp/model/tides_weather.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/theme/theme.dart';

class ForecastRainyChart extends HookConsumerWidget {
  const ForecastRainyChart({required this.next12HourForecast, super.key});

  final List<Next12HourForecast> next12HourForecast;

  List<BarChartGroupData> generateData() {
    var cloneNext12Hours = next12HourForecast.sublist(0, 6);

    return cloneNext12Hours
        .map((element) => BarChartGroupData(
              x: element.epochDateTime,
              barRods: [
                BarChartRodData(
                    toY: element.precipitationProbability.toDouble(),
                    width: 40,
                    color: const Color.fromARGB(255, 74, 114, 224),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ))
              ],
              showingTooltipIndicators: [0],
            ))
        .toList();
  }

  List<BarChartGroupData> generateXTitles() {
    var counter = 0;
    var cloneNext12Hours = next12HourForecast.sublist(0, 6);

    return cloneNext12Hours
        .map((element) => BarChartGroupData(
              x: counter++,
              barRods: [
                BarChartRodData(
                    color: Colors.red,
                    toY: element.precipitationProbability.toDouble(),
                    width: 40,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ))
              ],
              showingTooltipIndicators: [0],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeTidesProvider);

    final currentTheme = themeMode == ThemeMode.dark ? themeDark : themeLight;

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        gridData: const FlGridData(
          show: false,
          drawVerticalLine: false,
          drawHorizontalLine: true,
        ),
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(getCurrentDateFromEpochTime(value.toInt(), format: "HH:00"),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: currentTheme["temperatureFont"] as Color,
                    fontSize: 11,
                  ));
            },
          )),
        ),
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.transparent,
            tooltipPadding: const EdgeInsets.only(top: 5),
            tooltipMargin: 0,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                  "${rod.toY.round().toString()}%",
                  TextStyle(
                    fontWeight: FontWeight.w700,
                    color: currentTheme["temperatureFont"] as Color,
                    fontSize: 12,
                  ));
            },
          ),
        ),

        barGroups: generateData(),

        // read about it in the BarChartData section
      ),
      swapAnimationDuration: const Duration(milliseconds: 1000), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }
}
