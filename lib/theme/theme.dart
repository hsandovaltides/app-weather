import 'package:flutter/material.dart';

const lightColor = [
  Color.fromARGB(255, 241, 240, 235),
  Color.fromARGB(255, 248, 246, 130),
];

const darkColor = [
  Color.fromARGB(255, 94, 20, 206),
  Color.fromARGB(255, 144, 144, 234),
];

const fontLongText = TextStyle(
  fontWeight: FontWeight.normal,
  color: Colors.white,
  fontSize: 13,
);

const fontTitleBottomSheetDetails = TextStyle(
  fontWeight: FontWeight.w800,
  color: Colors.white,
  fontSize: 13,
);

const fontSecondTitle = TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13, decoration: TextDecoration.underline);

const themeDark = {
  //"backGroundColor": Color.fromARGB(255, 94, 20, 206),
  "backGroundColor": Color.fromARGB(255, 54, 60, 103),
  "backGroundColorLight": Color.fromARGB(255, 84, 92, 128),
  'primaryFontColor': Colors.white,
  'temperatureFont': Colors.white,
  "colorsByHourOfDay": darkColor,
  'next12HoursColorA': Color.fromARGB(255, 59, 64, 102),
  'next12HoursColorB': Color.fromARGB(255, 77, 84, 127),
  'next12HoursColorBorder': Color.fromARGB(255, 50, 54, 87),
  'percentOfPrecipitation': Colors.white70,
};

const themeLight = {
  "backGroundColor": Color.fromARGB(255, 109, 151, 225),
  "backGroundColorLight": Color.fromARGB(255, 141, 175, 208),
  'primaryFontColor': Colors.white,
  'temperatureFont': Colors.white,
  "colorsByHourOfDay": lightColor,
  'next12HoursColorA': Color.fromARGB(255, 104, 143, 215),
  'next12HoursColorB': Color.fromARGB(255, 113, 151, 200),
  'next12HoursColorBorder': Color.fromARGB(255, 95, 132, 201),
  'percentOfPrecipitation': Colors.white70,
};

const baseColor = Colors.black45;
const secondColor = Colors.black87;
