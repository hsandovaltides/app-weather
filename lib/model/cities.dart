class CitiesModel {
  CitiesModel({required this.key, required this.localizedName, required this.englishName, required this.geoPosition});

  factory CitiesModel.fromJson(Map<String, dynamic> json) {
    return CitiesModel(
      key: json['Key'] as String,
      localizedName: json['LocalizedName'] as String,
      englishName: json['EnglishName'] as String,
      geoPosition: GeoPositionModel.fromJson(json['GeoPosition']),
    );
  }

  final String key;
  final String localizedName;
  final String englishName;
  final GeoPositionModel geoPosition;
}

class GeoPositionModel {
  GeoPositionModel({required this.latitude, required this.longitude, required this.elevation});

  factory GeoPositionModel.fromJson(Map<String, dynamic> json) {
    return GeoPositionModel(
        latitude: json['Latitude'] as double, longitude: json['Longitude'] as double, elevation: ElevationModel.fromJson(json['Elevation']));
  }

  final double latitude;
  final double longitude;
  final ElevationModel elevation;
}

class ElevationModel {
  ElevationModel({required this.metric, required this.imperial});

  factory ElevationModel.fromJson(Map<String, dynamic> json) {
    return ElevationModel(metric: UnitMeasurementModel.fromJson(json['Metric']), imperial: UnitMeasurementModel.fromJson(json['Imperial']));
  }

  final UnitMeasurementModel metric;
  final UnitMeasurementModel imperial;
}

class UnitMeasurementModel {
  UnitMeasurementModel({required this.value, required this.unit, required this.unytType});

  factory UnitMeasurementModel.fromJson(Map<String, dynamic> json) {
    return UnitMeasurementModel(value: json['Value'] + 0.0, unit: json['Unit'] as String, unytType: json['UnitType'] as int);
  }

  final double value;
  final String unit;
  final int unytType;
}
