import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:weatherapp/provider/theme_mode.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/theme/theme.dart';

class MenuComponent extends HookConsumerWidget {
  final Function(ThemeMode) onThemeModeChanged;

  const MenuComponent({super.key, required this.onThemeModeChanged, required this.position});

  final Tuple2<double, double> position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeTidesProvider);
    final currentTheme = themeMode == ThemeMode.dark ? themeDark : themeLight;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: (currentTheme["next12HoursColorBorder"] as Color),
              spreadRadius: 0,
              blurRadius: 0,
              blurStyle: BlurStyle.normal), // no shadow color set, defaults to black
        ],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (currentTheme["next12HoursColorA"] as Color),
            (currentTheme["next12HoursColorB"] as Color),
          ],
        ),
      ),
      height: 230,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Configuración",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: currentTheme["primaryFontColor"] as Color,
                fontSize: 16,
              ),
            ),
            Divider(thickness: 2, color: currentTheme["primaryFontColor"] as Color),
            Row(
              children: [
                const Text("Tema Actual:", style: fontTitleBottomSheetDetails),
                IconButton(
                  icon: Icon(
                    color: themeMode == ThemeMode.dark ? Colors.yellow : Colors.white,
                    Icons.dark_mode,
                    size: 30,
                  ),
                  onPressed: () {
                    if (ref.watch(themeModeProvider) != ThemeMode.light) {
                      onThemeModeChanged(ref.watch(themeModeProvider) == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
                    }

                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(
                    color: themeMode == ThemeMode.light ? Colors.yellow : Colors.white,
                    size: 30,
                    Icons.light_mode,
                  ),
                  onPressed: () {
                    if (ref.watch(themeModeProvider) != ThemeMode.dark) {
                      onThemeModeChanged(ref.watch(themeModeProvider) == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
                    }
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            const Spacer(),
            Text("Ubicacion: ${position.item1},${position.item2}",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: currentTheme["primaryFontColor"] as Color,
                  fontSize: 14,
                )),
          ],
        ),
      ),
    );
  }
}
