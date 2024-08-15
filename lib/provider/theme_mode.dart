import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeStorage {
  static const _key = 'theme_mode';
  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    return value != null ? ThemeMode.values[int.parse(value)] : ThemeMode.light;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.index.toString());
  }
}

final themeModeFutureProvider = FutureProvider<ThemeMode>((ref) async {
  final storage = ref.read(themeModeStorageProvider);
  return await storage.getThemeMode();
});

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

final themeModeStorageProvider = Provider((_) => ThemeModeStorage());
