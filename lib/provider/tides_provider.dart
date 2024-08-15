import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:weatherapp/model/oauth2.dart';
import 'package:weatherapp/model/tides_weather.dart';
import 'package:http/http.dart' as http;

final tidesWeatherProvider = FutureProvider.family<TidesWeatherModel, Tuple2<double, double>>((ref, params) async {
  return await getWeatherFromTides(params.item1, params.item2);
});

Future<TidesWeatherModel> getWeatherFromTides(latitude, longitude) async {
  final oauth2 = await getAccessToken();

  final response = await http.get(Uri.parse('https://api.dev.tides.cl/weather/?q=$latitude,$longitude'),
      headers: <String, String>{'Authorization': '${oauth2.tokenType} ${oauth2.accessToken}'});

  debugPrint("Latitude: $latitude Longitude: $longitude");
  debugPrint(response.body);

  final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

  final weather = TidesWeatherModel.fromJson(json);

  return weather;
}

Future<Oauth2Model> getAccessToken() async {
  String fileContent = await readData();
  var currentDate = DateTime.now();
  if (!fileContent.contains("Error")) {
    final json = jsonDecode(fileContent) as Map<String, dynamic>;
    var oauth2 = Oauth2Model.fromJson(json);
    if (currentDate.millisecondsSinceEpoch < oauth2.expireEpochTime) {
      return oauth2;
    }
  }

  final response = await http.post(Uri.parse('https://login.microsoftonline.com/6d539d62-f6ec-4988-ad82-1548c3d4a303/oauth2/v2.0/token'), body: {
    
    'grant_type': 'client_credentials'
  });

  debugPrint(response.body);
  final json = jsonDecode(response.body) as Map<String, dynamic>;

  var oauth2 = Oauth2Model.fromJson(json);

  DateTime newDate = currentDate.add(Duration(seconds: oauth2.expiresIn));

  oauth2.expireEpochTime = newDate.millisecondsSinceEpoch;

  await writeData(jsonEncode(oauth2.toJson()));

  return oauth2;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/token_data2.txt');
}

Future<String> readData() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    return 'Error occurred: $e';
  }
}

Future<File> writeData(String content) async {
  final file = await _localFile;
  return file.writeAsString(content);
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
