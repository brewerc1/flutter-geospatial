import 'package:intl/intl.dart';

String printDate(double timeStamp) {
  DateFormat format;
  var date = DateTime.fromMillisecondsSinceEpoch(timeStamp.toInt());
  if (isToday(date)) {
    format = new DateFormat("'Today at' h:mm a");
  } else if (isYesterday(date)) {
    format = new DateFormat("'Yesterday at' h:mm a");
  } else if (date.year == DateTime.now().year) {
    format = new DateFormat("EEEE, MMMM d 'at' h:mm a");
  } else {
    format = new DateFormat("MM/dd/yy h:mm a");
  }
  return format.format(date);
}

bool isToday(DateTime date) {
  return date.day == DateTime.now().day && date.year == DateTime.now().year;
}

bool isYesterday(DateTime date) {
  return date.day == (DateTime.now().day - 1) && date.year == DateTime.now().year;
}

String dateStringFromEpochMillis(double timeStamp) {
  var format = new DateFormat("MM/dd h:mm a");
  return format.format(DateTime.fromMillisecondsSinceEpoch(timeStamp.toInt()));
}

String longDateStringFromEpochMillis(double timeStamp) {
  var format = new DateFormat("EEEE, MMMM d, yyyy h:mm a");
  return format.format(DateTime.fromMillisecondsSinceEpoch(timeStamp.toInt()));
}

String shortDateStringFromEpochMillis(double timeStamp) {
  var format = new DateFormat("yMd");
  return format.format(
      DateTime.fromMillisecondsSinceEpoch(timeStamp.toInt()));
}