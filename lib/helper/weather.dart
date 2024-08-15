import 'package:flutter/material.dart';
import 'package:weatherapp/model/tides_weather.dart';

bool isNight() {
  final now = DateTime.now();
  return !(now.hour >= 7 && now.hour <= 18);
}

AssetImage getImageByHourOfDay() {
  return (isNight()
      ? const AssetImage('assets/images/weather/images/weather_night.png')
      : const AssetImage('assets/images/weather/images/weather_sunny.png'));
}

String getImageByWeatherAndHour(bool isDay, int? iconNumber) {
  String image = isDay ? 'assets/lottie/sunny_clear.json' : 'assets/lottie/moon_clear.json';

  switch (iconNumber) {
    case 2:
    case 3:
    case 4:
    case 34:
    case 35:
    case 36:
      image = isDay ? 'assets/lottie/sunny_mostlyclear.json' : 'assets/lottie/moon_mostlyclear.json';
      break;

    case 5:
    case 6:
    case 7:
    case 8:
    case 37:
    case 38:
      image = isDay ? 'assets/lottie/mostly_cloud_day.json' : 'assets/lottie/mostly_cloud_moon.json';
      break;

    case 12:
    case 13:
    case 14:
    case 18:
    case 39:
    case 40:
      image = isDay ? 'assets/lottie/sunny_showers.json' : 'assets/lottie/moon_showers.json';
      break;

    case 15:
    case 16:
    case 17:
    case 41:
    case 42:
      image = isDay ? 'assets/lottie/sunny_tstorms.json' : 'assets/lottie/moon_tstorms.json';
      break;

    case 19:
    case 20:
    case 21:
    case 22:
    case 23:
    case 43:
      image = isDay ? 'assets/lottie/sunny_ice.json' : 'assets/lottie/moon_ice.json';
      break;

    case 24:
    case 25:
    case 26:
    case 29:
    case 44:
      image = 'assets/lottie/ice.json';

      break;
    default:
      break;
  }

  return image;
}

String getIconsByWeatherAndHour(bool isDay, int? iconNumber) {
  String image = isDay ? 'assets/images/weather/icons/01d.png' : 'assets/images/weather/icons/01n.png';

  switch (iconNumber) {
    case 2:
    case 3:
    case 4:
    case 34:
    case 35:
    case 36:
      //image = isDay ? 'assets/lottie/sunny_mostlyclear.json' : 'assets/lottie/moon_mostlyclear.json';
      image = isDay ? 'assets/images/weather/icons/02d.png' : 'assets/images/weather/icons/02n.png';
      break;

    case 5:
    case 6:
    case 7:
    case 8:
    case 37:
    case 38:
      //image = isDay ? 'assets/lottie/mostly_cloud_day.json' : 'assets/lottie/mostly_cloud_moon.json';
      image = isDay ? 'assets/images/weather/icons/03d.png' : 'assets/images/weather/icons/03n.png';
      break;

    case 12:
    case 13:
    case 14:
    case 18:
    case 39:
    case 40:
      //image = isDay ? 'assets/lottie/sunny_showers.json' : 'assets/lottie/moon_showers.json';
      image = isDay ? 'assets/images/weather/icons/10d.png' : 'assets/images/weather/icons/10n.png';
      break;

    case 15:
    case 16:
    case 17:
    case 41:
    case 42:
      //image = isDay ? 'assets/lottie/sunny_tstorms.json' : 'assets/lottie/moon_tstorms.json';
      image = isDay ? 'assets/images/weather/icons/11d.png' : 'assets/images/weather/icons/11n.png';
      break;

    case 19:
    case 20:
    case 21:
    case 22:
    case 23:
    case 43:
      image = isDay ? 'assets/images/weather/icons/13d.png' : 'assets/images/weather/icons/13n.png';
      break;

    case 24:
    case 25:
    case 26:
    case 29:
    case 44:
      image = isDay ? 'assets/images/weather/icons/50d.png' : 'assets/images/weather/icons/50n.png';

      break;
    default:
      break;
  }

  return image;
}

List<Color> colorsByHourOfDay() {
  return (isNight()
      ? [
          const Color.fromARGB(255, 94, 20, 206),
          const Color.fromARGB(255, 178, 178, 255),
        ]
      : [
          const Color.fromARGB(255, 253, 252, 245),
          const Color.fromARGB(255, 248, 246, 130),
        ]);
}

String getMessageOfTemperature(TidesWeatherModel data) {
  var containBeforeDay = data.next5daysForecast.dailyForecasts.length == 6;

  if (containBeforeDay) {
    var finalTemperature = !data.currentWeather.isDayTime
        ? getDiffTemperatureByTemp((data.next5daysForecast.dailyForecasts[1].temperature.maximum.value),
            (data.next5daysForecast.dailyForecasts[2].temperature.maximum.value))
        : getDiffTemperatureByTemp((data.next5daysForecast.dailyForecasts[0].temperature.maximum.value),
            (data.next5daysForecast.dailyForecasts[1].temperature.maximum.value));

    return data.currentWeather.isDayTime
        ? (finalTemperature > 0 ? "Un poco más fresco que ayer" : "Un poco más cálido que ayer")
        : (finalTemperature > 0 ? "Un poco más fresco que hoy" : "Un poco más cálido que hoy");
  }

  var finalTemperature = getDiffTemperatureByTemp(
      (data.next5daysForecast.dailyForecasts[0].temperature.maximum.value), (data.next5daysForecast.dailyForecasts[1].temperature.maximum.value));

  return (finalTemperature > 0 ? "Un poco más fresco que hoy" : "Un poco más cálido que hoy");
}

int getDiffTemperature(TidesWeatherModel data) {
  var containBeforeDay = data.next5daysForecast.dailyForecasts.length == 6;
  if (containBeforeDay) {
    return data.currentWeather.isDayTime
        ? ((data.next5daysForecast.dailyForecasts[1].temperature.maximum.value) -
                (data.next5daysForecast.dailyForecasts[0].temperature.maximum.value))
            .toInt()
        : ((data.next5daysForecast.dailyForecasts[2].temperature.maximum.value) -
                (data.next5daysForecast.dailyForecasts[1].temperature.maximum.value))
            .toInt();
  }

  return ((data.next5daysForecast.dailyForecasts[1].temperature.maximum.value) - (data.next5daysForecast.dailyForecasts[0].temperature.maximum.value))
      .toInt();
}

int getDiffTemperatureByTemp(double temperatureOne, double temperatureTwo) {
  return temperatureOne.toInt() - temperatureTwo.toInt();
}
