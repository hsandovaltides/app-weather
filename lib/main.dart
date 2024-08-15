import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/pages/home.dart';
import 'package:weatherapp/shared_prefs/app_shared_prefs.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppSharedPrefs.ensureInitialized();
  setup();
  runApp(const ProviderScope(child: MyApp()));
}

void setup() async {
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeTidesProvider);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        themeMode: themeMode,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Montserrat',
        ),
        home: MyHomePage(
          onThemeModeChanged: (newMode) {
            ref.read(themeTidesProvider.notifier).setTheme();
          },
        ));
  }
}
