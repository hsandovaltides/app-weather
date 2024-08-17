import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/theme/theme.dart';

class InfoCardComponent extends HookConsumerWidget {
  const InfoCardComponent({super.key, required this.icon, required this.name, required this.value, required this.unitType});

  final IconData icon;
  final String name;
  final String value;
  final String unitType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeTidesProvider);
    final currentTheme = themeMode == ThemeMode.dark ? themeDark : themeLight;

    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(top: 20, left: 5),
      child: Container(
          alignment: Alignment.center,
          height: 100,
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
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: currentTheme["temperatureFont"] as Color,
                      size: 15,
                    ),
                    Text(" $name",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: currentTheme["temperatureFont"] as Color,
                          fontSize: 12,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("$value $unitType",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: currentTheme["temperatureFont"] as Color,
                      fontSize: 16,
                    ))
              ],
            ),
          )),
    ));
  }
}
