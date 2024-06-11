import 'package:intl/intl.dart';

class AppFormatter {
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'id_ID',
    decimalDigits: 0,
  );

  String formatNumberToCurrency(int number) {
    return formatter.format(number);
  }

  String formatMonthToYear(int month) {
    if (month < 12) {
      return '$month bulan';
    } else {
      return '${month ~/ 12} tahun';
    }
  }

  String formatTimer(int time) {
    if (time < 60) {
      return '0:${(time % 60) < 10 ? "0${(time % 60)}" : time % 60}';
    }
    // else if (time < 10) {
    //   return '0:0$time';
    // }
    else {
      return '${time ~/ 60}:${(time % 60) < 10 ? "0${(time % 60)}" : time % 60}';
    }
  }
}
