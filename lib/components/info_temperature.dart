import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/model/tides_weather.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/theme/theme.dart';

class InfoTemperatureComponent extends HookConsumerWidget {
  const InfoTemperatureComponent({super.key, required this.data});

  final TidesWeatherModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeTidesProvider);

    final currentTheme = themeMode == ThemeMode.dark ? themeDark : themeLight;

    return Center(
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: (currentTheme["primaryFontColor"] as Color),
                      size: 16,
                    ),
                    Text("Información",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: currentTheme["temperatureFont"] as Color,
                          fontSize: 14,
                        )),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(data.next5daysForecast.headline.text,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: currentTheme["temperatureFont"] as Color,
                            fontSize: 14,
                          )),
                    ),
                    Lottie.asset("assets/lottie/information.json", repeat: true, width: 80)
                  ],
                )
              ],
            )));
  }
}
