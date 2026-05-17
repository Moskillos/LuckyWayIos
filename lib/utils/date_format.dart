import 'package:intl/intl.dart';

String dateFormat(DateTime date){
  return DateFormat('dd/MM/yyyy','IT').format(date);
}

String timeFormat(DateTime date){
  return DateFormat('HH:mm','IT').format(date);
}