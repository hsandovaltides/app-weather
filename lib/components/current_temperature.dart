import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weatherapp/helper/weather.dart';
import 'package:weatherapp/model/tides_weather.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/theme/theme.dart';

class CurrentTemperatureComponent extends HookConsumerWidget {
  const CurrentTemperatureComponent({super.key, required this.data});

  final TidesWeatherModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeTidesProvider);

    final currentTheme = themeMode == ThemeMode.dark ? themeDark : themeLight;

    return Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            //height: 140,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: (currentTheme["next12HoursColorBorder"] as Color),
                    spreadRadius: 0,
                    blurRadius: 0,
                    blurStyle: BlurStyle.normal), // no shadow color set, defaults to black
              ],
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  (currentTheme["next12HoursColorA"] as Color),
                  (currentTheme["next12HoursColorB"] as Color),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 16, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.thermostat,
                        color: (currentTheme["primaryFontColor"] as Color),
                        size: 16,
                      ),
                      Text(
                        data.next5daysForecast.dailyForecasts.length == 5
                            ? "Temperatura de mañana"
                            : data.currentWeather.isDayTime
                                ? "Temperatura de hoy"
                                : "Temperatura de mañana",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: currentTheme["temperatureFont"] as Color,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getMessageOfTemperature(data),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: currentTheme["temperatureFont"] as Color,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${getDiffTemperature(data)}°",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: currentTheme["temperatureFont"] as Color,
                          fontSize: 22,
                        ),
                      ),
                      Icon(
                        getDiffTemperature(data) > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        color: (currentTheme["primaryFontColor"] as Color),
                        size: 26,
                      ),
                    ],
                  ))
                ],
              ),
            )));
  }
}
