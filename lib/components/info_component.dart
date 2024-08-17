import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weatherapp/model/tides_weather.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/theme/theme.dart';

class InfoComponent extends HookConsumerWidget {
  const InfoComponent({super.key, required this.currentWeather});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeTidesProvider);

    final currentTheme = themeMode == ThemeMode.dark ? themeDark : themeLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Informacion",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: currentTheme["temperatureFont"] as Color,
            fontSize: 14,
          ),
        ),
        Divider(
          thickness: 2,
          color: currentTheme["primaryFontColor"] as Color,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Icon(
              Icons.air_rounded,
              color: currentTheme["temperatureFont"] as Color,
              size: 20,
            ),
            Text("Velocidad Viento",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: currentTheme["temperatureFont"] as Color,
                  fontSize: 14,
                )),
            const Spacer(),
            Text("${currentWeather.windGust.speed.metric.value} ${currentWeather.windGust.speed.metric.unit}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: currentTheme["temperatureFont"] as Color,
                  fontSize: 14,
                ))
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Icon(
              Icons.sunny,
              color: currentTheme["temperatureFont"] as Color,
              size: 20,
            ),
            Text("Indice UV",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: currentTheme["temperatureFont"] as Color,
                  fontSize: 14,
                )),
            const Spacer(),
            Text(currentWeather.uvIndexText,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: currentTheme["temperatureFont"] as Color,
                  fontSize: 14,
                ))
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Icon(
              Icons.remove_red_eye,
              color: currentTheme["temperatureFont"] as Color,
              size: 20,
            ),
            Text("Visibilidad",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: currentTheme["temperatureFont"] as Color,
                  fontSize: 14,
                )),
            const Spacer(),
            Text("${currentWeather.visibility.metric.value} ${currentWeather.visibility.metric.unit}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: currentTheme["temperatureFont"] as Color,
                  fontSize: 14,
                ))
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Icon(
              Icons.water_drop,
              color: currentTheme["temperatureFont"] as Color,
              size: 20,
            ),
            Text("Punto de rocio",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: currentTheme["temperatureFont"] as Color,
                  fontSize: 14,
                )),
            const Spacer(),
            Text("${currentWeather.dewPoint.metric.value}°",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: currentTheme["temperatureFont"] as Color,
                  fontSize: 14,
                ))
          ],
        ),
      ],
    );
  }

  final CurrentWeatherModel currentWeather;
}
