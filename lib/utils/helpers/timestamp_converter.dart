import 'package:intl/intl.dart';

/// Hàm chuyển đổi timestamp thành chuỗi định dạng `hh:mm dd/MM/yyyy`
String formatTimestamp(int timestamp) {
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
  return formatter.format(dateTime);
}
