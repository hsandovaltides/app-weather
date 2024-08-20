import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
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

    Future<void> _launchUrl(url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    Widget getMoreInformation(String url) {
      return InkWell(
        onTap: () => _launchUrl(Uri.parse(url)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Más información",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: currentTheme["temperatureFont"] as Color,
                  fontSize: 13,
                )),
            const Icon(Icons.link),
          ],
        ),
      );
    }

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
                      InfoTemperatureComponent(data: data),
                      CurrentTemperatureComponent(data: data),
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

    Widget spacer(height) {
      return SizedBox(
        height: height,
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
                widget: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Indice UV", style: fontTitleBottomSheetDetails),
                            Text("${currentWeather.uvIndex} - ${currentWeather.uvIndexText}", style: fontTitleBottomSheetDetails),
                          ],
                        ),
                        Divider(thickness: 2, color: currentTheme["primaryFontColor"] as Color),
                        spacer(10.0),
                        const Text(
                            "El índice UV es una medida que indica la intensidad de la radiación ultravioleta (UV) proveniente del sol en la superficie terrestre.",
                            style: fontLongText),
                        spacer(10.0),
                        const Text("• 0-2 (Bajo): Riesgo mínimo de daño por exposición al sol. Es recomendable usar gafas de sol en días soleados.",
                            style: fontLongText),
                        spacer(10.0),
                        const Text("• 3-5 (Moderado): Riesgo moderado. Se recomienda buscar sombra durante el mediodía y usar protector solar.",
                            style: fontLongText),
                        spacer(10.0),
                        const Text(
                            "• 6-7 (Alto): Riesgo alto. Es importante proteger la piel y los ojos, y reducir el tiempo al sol entre las 10 a.m. y las 4 p.m.",
                            style: fontLongText),
                        spacer(10.0),
                        const Text(
                            "• 8-10 (Muy alto): Riesgo muy alto. Se deben tomar precauciones adicionales, como usar ropa protectora y sombreros de ala ancha.",
                            style: fontLongText),
                        spacer(10.0),
                        const Text(
                            "• 11+ (Extremo): Riesgo extremo. La piel y los ojos sin protección pueden quemarse en minutos. Es crucial minimizar la exposición al sol.",
                            style: fontLongText),
                        spacer(20.0),
                        getMoreInformation("https://es.wikipedia.org/wiki/%C3%8Dndice_UV"),
                        spacer(10.0)
                      ],
                    )),
              ),
              InfoCardComponent(
                icon: Icons.water_drop,
                name: "Humedad",
                value: "${currentWeather.relativeHumidity}",
                unitType: "%",
                widget: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Humedad",
                              style: fontTitleBottomSheetDetails,
                            ),
                            Text(
                              "${currentWeather.relativeHumidity}%",
                              style: fontTitleBottomSheetDetails,
                            ),
                          ],
                        ),
                        Divider(thickness: 2, color: currentTheme["primaryFontColor"] as Color),
                        spacer(10.0),
                        const Text(
                            "La humedad se refiere a la cantidad de vapor de agua presente en el aire. Es una variable crucial porque influye en la formación de nubes, la precipitación y la sensación térmica.",
                            style: fontLongText),
                        spacer(20.0),
                        const Text(
                          "Tipos de Humedad",
                          style: fontSecondTitle,
                        ),
                        spacer(10.0),
                        const Text(
                            "• Humedad Absoluta: Es la cantidad de vapor de agua en gramos contenida en un metro cúbico de aire. Se expresa en g/m³",
                            style: fontLongText),
                        spacer(10.0),
                        const Text(
                            "• Humedad Específica: Es la masa de vapor de agua en gramos contenida en un kilogramo de aire. Se expresa en g/kg.",
                            style: fontLongText),
                        spacer(10.0),
                        const Text(
                            "• Humedad Relativa: Es la relación entre la cantidad de vapor de agua presente en el aire y la cantidad máxima que el aire podría contener a esa temperatura. Se expresa en porcentaje (%)",
                            style: fontLongText),
                        spacer(20.0),
                        getMoreInformation("https://es.wikipedia.org/wiki/Humedad"),
                        spacer(10.0),
                      ],
                    )),
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
                widget: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Viento",
                              style: fontTitleBottomSheetDetails,
                            ),
                            Text("${currentWeather.windGust.speed.metric.value} ${currentWeather.windGust.speed.metric.unit}",
                                style: fontTitleBottomSheetDetails),
                          ],
                        ),
                        Divider(thickness: 2, color: currentTheme["primaryFontColor"] as Color),
                        spacer(10.0),
                        const Text(
                          "El viento se define como el movimiento del aire en la atmósfera, causado por diferencias de presión entre distintas áreas. Este movimiento puede ser horizontal o vertical, aunque el viento horizontal es el más común y el que generalmente se mide y estudia.",
                          style: fontLongText,
                        ),
                        spacer(20.0),
                        const Text(
                          "Características del Viento",
                          style: fontSecondTitle,
                        ),
                        spacer(10.0),
                        const Text(
                            "• Dirección: Se refiere al punto cardinal desde donde sopla el viento. Por ejemplo, un viento del norte sopla desde el norte hacia el sur.",
                            style: fontLongText),
                        spacer(10.0),
                        const Text(
                            "• Velocidad: Se mide en metros por segundo (m/s), kilómetros por hora (km/h) o nudos. La velocidad del viento puede variar desde una brisa ligera hasta un huracán.",
                            style: fontLongText),
                        spacer(10.0),
                        const Text("• Ráfagas: Son aumentos repentinos y breves en la velocidad del viento.", style: fontLongText),
                        spacer(10.0),
                        const Text("• Turbonadas: Vientos fuertes de duración intermedia, aproximadamente un minuto.", style: fontLongText),
                        spacer(20.0),
                        getMoreInformation("https://es.wikipedia.org/wiki/Viento"),
                        spacer(10.0),
                      ],
                    )),
              ),
              InfoCardComponent(
                icon: Icons.water_drop,
                name: "Punto de rocío",
                value: "${currentWeather.dewPoint.metric.value}",
                unitType: "°",
                widget: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Punto de rocío",
                              style: fontTitleBottomSheetDetails,
                            ),
                            Text(
                              "${currentWeather.dewPoint.metric.value}°",
                              style: fontTitleBottomSheetDetails,
                            ),
                          ],
                        ),
                        Divider(thickness: 2, color: currentTheme["primaryFontColor"] as Color),
                        spacer(10.0),
                        const Text(
                          "El punto de rocío es la temperatura a la que el aire debe enfriarse para que el vapor de agua contenido en él comience a condensarse en forma de rocío, neblina, o escarcha, dependiendo de la temperatura12. Este fenómeno ocurre cuando la humedad relativa alcanza el 100%, lo que significa que el aire está completamente saturado de vapor de agua.",
                          style: fontLongText,
                        ),
                        spacer(10.0),
                        const Text(
                            "El punto de rocío es una medida importante en meteorología porque indica la cantidad de humedad en el aire. Por ejemplo, un punto de rocío alto puede hacer que el aire se sienta más húmedo y pegajoso, mientras que un punto de rocío bajo indica aire más seco.",
                            style: fontLongText),
                        spacer(20.0),
                        getMoreInformation("https://es.wikipedia.org/wiki/Punto_de_roc%C3%ADo"),
                        spacer(10.0),
                      ],
                    )),
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
                widget: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Presión",
                              style: fontTitleBottomSheetDetails,
                            ),
                            Text(
                              "${currentWeather.dewPoint.metric.value} ${currentWeather.pressure.metric.unit}",
                              style: fontTitleBottomSheetDetails,
                            ),
                          ],
                        ),
                        Divider(thickness: 2, color: currentTheme["primaryFontColor"] as Color),
                        spacer(10.0),
                        const Text(
                          "La presión atmosférica es la fuerza que ejerce el aire sobre la superficie terrestre. Se mide en pascales (Pa) y varía según la altitud, la temperatura y la humedad12. A nivel del mar, la presión atmosférica promedio es de 1013,25 hPa (hectopascales).",
                          style: fontLongText,
                        ),
                        spacer(10.0),
                        const Text(
                            "La presión atmosférica juega un papel crucial en la formación de patrones climáticos. Por ejemplo, una alta presión generalmente indica buen tiempo con cielos despejados, mientras que una baja presión puede señalar mal tiempo con lluvias y vientos.",
                            style: fontLongText),
                        spacer(20.0),
                        getMoreInformation("https://es.wikipedia.org/wiki/Presi%C3%B3n_atmosf%C3%A9rica"),
                        spacer(10.0),
                      ],
                    )),
              ),
              InfoCardComponent(
                icon: Icons.remove_red_eye,
                name: "Visibilidad",
                value: "${currentWeather.visibility.metric.value}",
                unitType: " ${currentWeather.visibility.metric.unit}",
                widget: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Visibilidad",
                              style: fontTitleBottomSheetDetails,
                            ),
                            Text(
                              "${currentWeather.visibility.metric.value} ${currentWeather.visibility.metric.unit}",
                              style: fontTitleBottomSheetDetails,
                            ),
                          ],
                        ),
                        Divider(thickness: 2, color: currentTheme["primaryFontColor"] as Color),
                        spacer(10.0),
                        const Text(
                          "La visibilidad en meteorología se refiere a la mayor distancia a la que se puede ver e identificar un objeto claramente en el horizonte.",
                          style: fontLongText,
                        ),
                        spacer(10.0),
                        const Text(
                            " Esta medida es crucial para la aviación, la navegación y la seguridad vial, ya que afecta la capacidad de los conductores y pilotos para ver obstáculos y señales.",
                            style: fontLongText),
                        spacer(20.0),
                        const Text("La visibilidad puede verse afectada por varios factores meteorológicos, como:", style: fontLongText),
                        spacer(10.0),
                        const Text("• Niebla: Gotas de agua suspendidas en el aire que reducen significativamente la visibilidad.",
                            style: fontLongText),
                        spacer(10.0),
                        const Text("• Bruma: Partículas de polvo, humo o sal en el aire que disminuyen la claridad.", style: fontLongText),
                        spacer(10.0),
                        const Text("• Precipitación: Lluvia, nieve o granizo que pueden obstruir la vista.", style: fontLongText),
                        spacer(10.0),
                        const Text("• Polvo y arena: Partículas en suspensión que pueden reducir la visibilidad, especialmente en áreas desérticas.",
                            style: fontLongText),
                        spacer(20.0),
                        /* const Text(
                            "La visibilidad se mide generalmente en kilómetros o millas y se reporta en los informes meteorológicos para ayudar a planificar actividades al aire libre y garantizar la seguridad."),
                        spacer(10.0), */

                        getMoreInformation("https://es.wikipedia.org/wiki/Visibilidad"),
                        spacer(10.0),
                      ],
                    )),
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
