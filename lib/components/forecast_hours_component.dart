import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weatherapp/helper/date_helper.dart';
import 'package:weatherapp/helper/weather.dart';
import 'package:weatherapp/model/tides_weather.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/theme/theme.dart';

class ForecastHoursComponent extends HookConsumerWidget {
  final List<Next12HourForecast> next12HourForecast;

  const ForecastHoursComponent({super.key, required this.next12HourForecast});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeTidesProvider);
    final currentTheme = themeMode == ThemeMode.dark ? themeDark : themeLight;

    return ListView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children: next12HourForecast
          .map((e) => Padding(
                padding: const EdgeInsets.only(left: 0, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getCurrentDateFromEpochTime(e.epochDateTime, format: "HH:00"),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: currentTheme["primaryFontColor"] as Color,
                          fontSize: 10,
                        )),
                    Image.asset(
                      getIconsByWeatherAndHour(e.isDayLight, e.weatherIcon),
                      width: 42,
                    ),
                    Text("${e.temperature.value.toInt()}°",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: currentTheme["primaryFontColor"] as Color,
                          fontSize: 12,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.water_drop,
                            size: 16,
                            color: currentTheme["percentOfPrecipitation"] as Color,
                          ),
                          Text("${e.precipitationProbability} %",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: currentTheme["percentOfPrecipitation"] as Color,
                                fontSize: 12,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
