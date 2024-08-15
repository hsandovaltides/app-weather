import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weatherapp/helper/date_helper.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/theme/theme.dart';

class FooterComponent extends HookConsumerWidget {
  const FooterComponent({super.key, required this.epochTime, required this.url});

  final int epochTime;
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeTidesProvider);
    final currentTheme = themeMode == ThemeMode.dark ? themeDark : themeLight;

    return Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 40, top: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    debugPrint('Could not launch $url');
                  }
                },
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/accuweather.png",
                      width: 30,
                    ),
                    Text("AccuWeather",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: currentTheme["temperatureFont"] as Color,
                          fontSize: 12,
                        ))
                  ],
                )),
            Text("Actual. ${getCurrentDateFromEpochTime(epochTime, format: "d/M, HH:mm")}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: currentTheme["temperatureFont"] as Color,
                  fontSize: 12,
                )),
          ],
        ));
  }
}
