import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weatherapp/model/tides_weather.dart';

class InfoComponent extends HookConsumerWidget {
  const InfoComponent({super.key, required this.currentWeather});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        Text("Velocidad Viento"),
        Text("Indice UV"),
        Text("Visibilidad"),
        Text("Punto de rocio"),
      ],
    );
  }

  final CurrentWeatherModel currentWeather;
}
