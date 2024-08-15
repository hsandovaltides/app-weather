import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weatherapp/model/tides_weather.dart';
import 'package:weatherapp/provider/tides_provider.dart';

final positionProvider = StreamProvider.autoDispose<Position?>((ref) {
  final streamController = StreamController<Position?>();

  _determinePosition(streamController);
  return streamController.stream;
});

final tidesPositionWeatherProvider = FutureProvider.autoDispose<TidesWeatherModel?>((ref) async {
  final streamController = StreamController<Position?>();

  _determinePosition(streamController);
  final stream = await streamController.stream.first;

  return await getWeatherFromTides(stream?.latitude ?? 0, stream?.longitude ?? 0);
});

void _determinePosition(StreamController<Position?> streamController) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    streamController.addError('Location services are disabled.');
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      streamController.addError('Location permissions are denied');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    streamController.addError('Location permissions are permanently denied, we cannot request permissions.');
    return;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
    streamController.add(position);
  });

  Position initialPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  streamController.add(initialPosition);
}
