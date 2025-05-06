import 'package:intl/intl.dart';

String formatJoinedDate(DateTime date) {
  return 'Joined ${DateFormat('MMMM yyyy').format(date)}';
}
