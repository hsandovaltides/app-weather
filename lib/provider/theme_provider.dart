import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weatherapp/shared_prefs/app_shared_prefs.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  primarySwatch: Colors.blue,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  primarySwatch: Colors.blue,
);

class ThemeTidesModeStorage extends StateNotifier<ThemeMode> {
  ThemeTidesModeStorage(super.state);

  ThemeMode getTheme() {
    return state;
  }

  void setTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.dark;
    }
    AppSharedPrefs().updateThemeMode(state);
  }
}

final themeTidesProvider = StateNotifierProvider<ThemeTidesModeStorage, ThemeMode>((ref) {
  return ThemeTidesModeStorage(AppSharedPrefs().themeMode());
});
