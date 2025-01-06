import 'package:intl/intl.dart';

int compareTimes(String? time1, String? time2) {
  if (time1 == null || time2 == null) {
    return 0;
  }
  final DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
  final DateTime dateTime1 = formatter.parse(time1);
  final DateTime dateTime2 = formatter.parse(time2);

  // So sánh
  if (dateTime1.isBefore(dateTime2)) {
    return 1;
  } else if (dateTime1.isAfter(dateTime2)) {
    return 0;
  } else {
    return 0;
  }
}
