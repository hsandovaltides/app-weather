import 'package:weatherapp/model/cities.dart';

class Accuweather {
  Accuweather(
      {required this.epochTime,
      required this.weatherText,
      required this.weatherIcon,
      required this.hasPrecipitation,
      required this.precipitationType,
      required this.isDayTime,
      required this.temperature});

  factory Accuweather.fromJson(Map<String, dynamic> json) {
    return Accuweather(
        epochTime: json["EpochTime"] as int,
        weatherText: json["WeatherText"] as String,
        weatherIcon: json["WeatherIcon"] as int,
        hasPrecipitation: json["HasPrecipitation"] as bool,
        precipitationType: (json["PrecipitationType"] ?? "") as String,
        isDayTime: json["IsDayTime"] as bool,
        temperature: AccuweatherTemperature.fromJson(json["Temperature"]));
  }

  final int epochTime;
  final String weatherText;
  final int? weatherIcon;
  final bool hasPrecipitation;
  final String? precipitationType;
  final bool isDayTime;
  final AccuweatherTemperature temperature;
}

class AccuweatherTemperature {
  AccuweatherTemperature({required this.metric, required this.imperial});

  factory AccuweatherTemperature.fromJson(Map<String, dynamic> json) {
    return AccuweatherTemperature(metric: UnitMeasurementModel.fromJson(json["Metric"]), imperial: UnitMeasurementModel.fromJson(json["Imperial"]));
  }

  final UnitMeasurementModel metric;
  final UnitMeasurementModel imperial;
}
