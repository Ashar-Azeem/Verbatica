import 'package:intl/intl.dart';

String formatJoinedDate(DateTime date) {
  return DateFormat('MMMM yyyy').format(date);
}
