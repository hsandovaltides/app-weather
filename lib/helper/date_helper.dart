import 'package:intl/intl.dart';

String getCurrentDateInformat({String format = "yyyy-MM-dd"}) {
  return DateFormat(format).format(DateTime.now());
}

String getCurrentDateFromEpochTime(int epochTime, {String format = "yyyy-MM-dd"}) {
  return DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(epochTime * 1000));
}

String dayEnglishToSpanish(String day) {
  switch (day) {
    case "Monday":
      return "Lunes";
    case "Tuesday":
      return "Martes";
    case "Wednesday":
      return "Miércoles";
    case "Thursday":
      return "Jueves";
    case "Friday":
      return "Viernes";
    case "Saturday":
      return "Sábado";
    case "Sunday":
      return "Domingo";
    default:
      return "";
  }
}
