import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tuple/tuple.dart';
import 'package:weatherapp/components/current_temperature.dart';
import 'package:weatherapp/components/footer_component.dart';

import 'package:weatherapp/components/forecast_hours_component.dart';
import 'package:weatherapp/components/forecast_rainy_chart.dart';
import 'package:weatherapp/components/info_card_component.dart';
import 'package:weatherapp/components/info_component.dart';
import 'package:weatherapp/components/info_temperature.dart';
import 'package:weatherapp/components/lottie_error.dart';
import 'package:weatherapp/components/lottie_loading.dart';
import 'package:weatherapp/components/menu_component.dart';
import 'package:weatherapp/helper/date_helper.dart';
import 'package:weatherapp/helper/weather.dart';
import 'package:weatherapp/model/tides_weather.dart';
import 'package:weatherapp/provider/position_provider.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/theme/theme.dart';

class MyHomePage extends HookConsumerWidget {
  final Function(ThemeMode) onThemeModeChanged;

  const MyHomePage({super.key, required this.onThemeModeChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = useState(const Tuple2<double, double>(0, 0));
    final visible = useState(false);

    final tidesPositionWeather = ref.watch(tidesPositionWeatherProvider);

    final themeMode = ref.watch(themeTidesProvider);

    final currentTheme = themeMode == ThemeMode.dark ? themeDark : themeLight;

    final pageController = usePageController();
    final currentPageIndex = useState(0);

    showMenu() {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return MenuComponent(position: position.value, onThemeModeChanged: onThemeModeChanged);
        },
      );
    }

    Widget generateHeader(data) {
      return Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: (currentTheme["primaryFontColor"] as Color),
              size: 30,
            ),
            tooltip: 'Ver opciones',
            onPressed: () {
              showMenu();
            },
          ),
          Icon(
            Icons.location_pin,
            size: 22,
            color: currentTheme["primaryFontColor"] as Color,
          ),
          Text(
            data.position.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: currentTheme["primaryFontColor"] as Color,
              fontSize: 22,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Lottie.asset(getImageByWeatherAndHour(data.currentWeather.isDayTime, data.currentWeather.weatherIcon), repeat: true, width: 60),
          )
        ],
      );
    }

    Widget generateTemperaturaAnimation(TidesWeatherModel data) {
      return Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, top: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${data.currentWeather.temperature.metric.value.toInt()}°",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: currentTheme["temperatureFont"] as Color,
                      fontSize: 65,
                    ),
                  ),
                  Text(
                    data.currentWeather.weatherText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: currentTheme["primaryFontColor"] as Color,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Text(
                    'Sensación Térmica de ${data.currentWeather.realFeelTemperature.metric.value.toInt()}°',
                    style: TextStyle(
                      color: currentTheme["primaryFontColor"] as Color,
                      fontSize: 14,
                    ),
                  )
                ],
              )),
              Lottie.asset("assets/lottie/person_walking.json", repeat: true, width: 160)
            ],
          ));
    }

    Widget generateCurrentWeather(data) {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 200,
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
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pronóstico próximas 12 horas",
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
                  Expanded(
                      child: ForecastHoursComponent(
                    next12HourForecast: data.next12HourForecast,
                  )),
                ],
              ),
            )),
      );
    }

    Widget generateTemperatureMessage(TidesWeatherModel data) {
      return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
              alignment: Alignment.topCenter,
              height: 190,
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
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      currentPageIndex.value = index;
                    },
                    children: <Widget>[
                      CurrentTemperatureComponent(data: data),
                      InfoTemperatureComponent(data: data),
                      Center(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Probabilidades de lluvia",
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
                                Expanded(child: ForecastRainyChart(next12HourForecast: data.next12HourForecast))
                              ],
                            )),
                      ),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 20),
                        child: InfoComponent(currentWeather: data.currentWeather),
                      ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: 4, //Array length
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Colors.blue,
                        dotColor: Colors.grey,
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 5.0,
                      ),
                    ),
                  )
                ],
              )));
    }

    Widget generateWidgetOfDays(TidesWeatherModel data) {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            //height: 260,
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
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 29),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.next5daysForecast.dailyForecasts.asMap().entries.map((entry) {
                    bool firstPosition = entry.key == 0;
                    bool forecastFullData = data.next5daysForecast.dailyForecasts.length == 6;
                    DailyForecasts e = entry.value;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                                forecastFullData && firstPosition
                                    ? "Ayer"
                                    : !forecastFullData && firstPosition
                                        ? "Hoy"
                                        : forecastFullData && entry.key == 1
                                            ? "Hoy"
                                            : dayEnglishToSpanish(getCurrentDateFromEpochTime(e.epochDate, format: "EEEE")),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: (!firstPosition ? currentTheme["temperatureFont"] : currentTheme["percentOfPrecipitation"]) as Color,
                                  fontSize: 14,
                                )),
                            const Spacer(),
                            forecastFullData && firstPosition
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 20),
                                    child: Image.asset(
                                      getIconsByWeatherAndHour(true, e.day.icon),
                                      width: 40,
                                    ),
                                  ),
                            forecastFullData && firstPosition
                                ? const SizedBox()
                                : Image.asset(
                                    getIconsByWeatherAndHour(false, e.night.icon),
                                    width: 40,
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, right: 10),
                              child: Text("${e.temperature.maximum.value.toInt()}°",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: (!firstPosition ? currentTheme["temperatureFont"] : currentTheme["percentOfPrecipitation"]) as Color,
                                    fontSize: 15,
                                  )),
                            ),
                            Text("${e.temperature.minimum.value.toInt()}°",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: (!firstPosition ? currentTheme["temperatureFont"] : currentTheme["percentOfPrecipitation"]) as Color,
                                  fontSize: 15,
                                )),
                          ],
                        )
                      ],
                    );
                  }).toList()),
            )),
      );
    }

    Widget generateWidgetsInfo(CurrentWeatherModel currentWeather) {
      return Column(
        children: [
          Row(
            children: [
              InfoCardComponent(
                icon: Icons.sunny,
                name: "Indice UV",
                value: currentWeather.uvIndexText,
                unitType: "",
              ),
              InfoCardComponent(
                icon: Icons.water_drop,
                name: "Humedad",
                value: "${currentWeather.relativeHumidity}",
                unitType: "%",
              ),
            ],
          ),
          Row(
            children: [
              InfoCardComponent(
                icon: Icons.air_rounded,
                name: "Viento",
                value: "${currentWeather.windGust.speed.metric.value}",
                unitType: " ${currentWeather.windGust.speed.metric.unit}",
              ),
              InfoCardComponent(
                icon: Icons.water_drop,
                name: "Punto de rocio",
                value: "${currentWeather.dewPoint.metric.value}",
                unitType: "°",
              ),
            ],
          ),
          Row(
            children: [
              InfoCardComponent(
                icon: Icons.compare_arrows,
                name: "Presión",
                value: "${currentWeather.pressure.metric.value}",
                unitType: " ${currentWeather.pressure.metric.unit}",
              ),
              InfoCardComponent(
                icon: Icons.remove_red_eye,
                name: "Visibilidad",
                value: "${currentWeather.visibility.metric.value}",
                unitType: " ${currentWeather.visibility.metric.unit}",
              ),
            ],
          )
        ],
      );
    }

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [
            0.150,
            0.9,
          ],
          colors: [
            (currentTheme["backGroundColor"] as Color),
            (currentTheme["backGroundColorLight"] as Color),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 15),
          child: tidesPositionWeather.when(
            data: (data) {
              position.value = Tuple2<double, double>(data?.position.geoposition.latitude ?? 0, data?.position.geoposition.longitude ?? 0);
              if (!visible.value) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  visible.value = true;
                });
              }
              return AnimatedOpacity(
                opacity: visible.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1500),
                child: RefreshIndicator(
                  onRefresh: () => ref.refresh(tidesPositionWeatherProvider.future),
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      generateHeader(data!),
                      generateTemperaturaAnimation(data),
                      generateCurrentWeather(data),
                      generateTemperatureMessage(data),
                      generateWidgetOfDays(data),
                      generateWidgetsInfo(data.currentWeather),
                      FooterComponent(epochTime: data.currentWeather.epochTime, url: data.next12HourForecast[0].link)
                    ],
                  )),
                ),
              );
            },
            error: (error, stackTrace) {
              debugPrint("Error: $error $stackTrace");
              return const LottieError("Error getting ubication data");
            },
            loading: () => const LottieLoading(),
          ),
        ),
      ),
    ));
  }
}
