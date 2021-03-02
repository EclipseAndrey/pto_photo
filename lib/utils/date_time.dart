class DateTimeUtil {
  static bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static int get daysCountOfCurrentYear {
    return isLeapYear(DateTime.now().year) ? 366 : 365;
  }

  static int get daysCountOfCurrentMonth {
    final DateTime now = DateTime.now();
    final DateTime lastDayDateTime =
        (now.month < 12) ? DateTime(now.year, now.month + 1, 0) : DateTime(now.year + 1, 1, 0);
    return lastDayDateTime.day;
  }
}
