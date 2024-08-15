import 'package:weatherapp/model/cities.dart';

class TidesWeatherModel {
  TidesWeatherModel({required this.position, required this.currentWeather, required this.next12HourForecast, required this.next5daysForecast});

  factory TidesWeatherModel.fromJson(Map<String, dynamic> json) {
    return TidesWeatherModel(
        position: PositionModel.fromJson(json["position"]),
        currentWeather: CurrentWeatherModel.fromJson(json["currentWeather"]),
        next12HourForecast: List.from(json["next12HourForecast"].map((e) => Next12HourForecast.fromJson(e))),
        next5daysForecast: Next5DaysForecast.fromJson(json["next5DaysForecast"]));
  }

  final PositionModel position;
  final CurrentWeatherModel currentWeather;
  final List<Next12HourForecast> next12HourForecast;
  final Next5DaysForecast next5daysForecast;
}

class PositionModel {
  PositionModel(
      {required this.codePostal,
      required this.nextOffsetChange,
      required this.cityId,
      required this.geoposition,
      required this.timezoneName,
      required this.timezoneOffset,
      required this.areaName,
      required this.countryName,
      required this.name,
      required this.regionName,
      required this.type});

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
        codePostal: json["codePostal"] as String,
        nextOffsetChange: json["nextOffsetChange"] as String,
        cityId: json["cityId"] as String,
        geoposition: GeoPositionModel.fromJson(json["geoposition"]),
        timezoneName: json["timezoneName"] as String,
        timezoneOffset: json["timezoneOffset"] as int,
        areaName: json["areaName"] as String,
        countryName: json["countryName"] as String,
        name: json["name"] as String,
        regionName: json["regionName"] as String,
        type: json["type"] as String);
  }

  final String codePostal;
  final String nextOffsetChange;
  final String cityId;
  final GeoPositionModel geoposition;
  final String timezoneName;
  final int timezoneOffset;
  final String areaName;
  final String countryName;
  final String name;
  final String regionName;
  final String type;
}

class CurrentWeatherModel {
  CurrentWeatherModel(
      {required this.weatherText,
      required this.precipitationType,
      required this.epochTime,
      required this.weatherIcon,
      required this.hasPrecipitation,
      required this.id,
      required this.temperature,
      required this.isDayTime});

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
        weatherText: json["weatherText"] as String,
        precipitationType: json["precipitationType"] ?? "",
        epochTime: json["epochTime"] as int,
        weatherIcon: json["weatherIcon"] as int,
        hasPrecipitation: json["hasPrecipitation"] as bool,
        id: json["id"],
        temperature: TemperatureModel.fromJson(json["temperature"]),
        isDayTime: json["isDayTime"] as bool);
  }

  final String weatherText;
  final String? precipitationType;
  final int epochTime;
  final int weatherIcon;
  final bool hasPrecipitation;
  final String id;
  final TemperatureModel temperature;
  final bool isDayTime;
}

class TemperatureModel {
  TemperatureModel({required this.metric, required this.imperial});

  factory TemperatureModel.fromJson(Map<String, dynamic> json) {
    return TemperatureModel(metric: UnitMeasurementModel.fromJson(json["Metric"]), imperial: UnitMeasurementModel.fromJson(json["Imperial"]));
  }

  final UnitMeasurementModel metric;
  final UnitMeasurementModel imperial;
}

class Next12HourForecast {
  Next12HourForecast(
      {required this.temperature,
      required this.precipitationProbability,
      required this.hasPrecipitation,
      required this.epochDateTime,
      required this.iconPhrase,
      required this.isDayLight,
      required this.dateTime,
      required this.weatherIcon,
      required this.link});

  factory Next12HourForecast.fromJson(Map<String, dynamic> json) {
    return Next12HourForecast(
        temperature: UnitMeasurementModel.fromJson(json["Temperature"]),
        precipitationProbability: json["PrecipitationProbability"] as int,
        hasPrecipitation: json["HasPrecipitation"] as bool,
        epochDateTime: json["EpochDateTime"] as int,
        iconPhrase: json["IconPhrase"] as String,
        isDayLight: json["IsDaylight"] as bool,
        dateTime: json["DateTime"] as String,
        weatherIcon: json["WeatherIcon"] as int,
        link: json["Link"] as String);
  }

  final UnitMeasurementModel temperature;
  final int precipitationProbability;
  final bool hasPrecipitation;
  final int epochDateTime;
  final String iconPhrase;
  final bool isDayLight;
  final String dateTime;
  final int weatherIcon;
  final String link;
}

class Next5DaysForecast {
  Next5DaysForecast({required this.dailyForecasts, required this.headline});

  factory Next5DaysForecast.fromJson(Map<String, dynamic> json) {
    return Next5DaysForecast(
        dailyForecasts: List.from((json["DailyForecasts"]).map((e) => DailyForecasts.fromJson(e))), headline: Headline.fromJson(json["Headline"]));
  }

  final List<DailyForecasts> dailyForecasts;
  final Headline headline;
}

class DailyForecasts {
  DailyForecasts({required this.temperature, required this.night, required this.day, required this.epochDate});

  factory DailyForecasts.fromJson(Map<String, dynamic> json) {
    return DailyForecasts(
        day: NightForecast.fromJson(json["Day"]),
        temperature: TemperatureForecast.fromJson(json["Temperature"]),
        night: NightForecast.fromJson(json["Night"]),
        epochDate: json["EpochDate"] as int);
  }

  final TemperatureForecast temperature;
  final NightForecast night;
  final NightForecast day;
  final int epochDate;
}

class TemperatureForecast {
  TemperatureForecast({required this.minimum, required this.maximum});

  factory TemperatureForecast.fromJson(Map<String, dynamic> json) {
    return TemperatureForecast(minimum: UnitMeasurementModel.fromJson(json["Minimum"]), maximum: UnitMeasurementModel.fromJson(json["Maximum"]));
  }

  final UnitMeasurementModel minimum;
  final UnitMeasurementModel maximum;
}

class NightForecast {
  NightForecast({required this.iconPhrase, required this.hasPrecipitation, required this.icon});

  factory NightForecast.fromJson(Map<String, dynamic> json) {
    return NightForecast(hasPrecipitation: json["HasPrecipitation"] as bool, icon: json["Icon"] as int, iconPhrase: json["IconPhrase"] as String);
  }

  final String iconPhrase;
  final bool hasPrecipitation;
  final int icon;
}

class Headline {
  Headline(
      {required this.category,
      required this.endEpochDate,
      required this.effectiveEpochDate,
      required this.severity,
      required this.text,
      required this.endDate,
      required this.effectiveDate});

  factory Headline.fromJson(Map<String, dynamic> json) {
    return Headline(
        category: json["Category"] as String,
        endEpochDate: (json["EndEpochDate"] ?? 0) as int,
        effectiveEpochDate: json["EffectiveEpochDate"] as int,
        severity: json["Severity"] as int,
        text: json["Text"] as String,
        endDate: (json["EndDate"] ?? "") as String,
        effectiveDate: json["EffectiveDate"] as String);
  }

  final String category;
  final int endEpochDate;
  final int effectiveEpochDate;
  final int severity;
  final String text;
  final String endDate;
  final String effectiveDate;
}
