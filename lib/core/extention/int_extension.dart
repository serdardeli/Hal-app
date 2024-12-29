extension intExtension on int {
  double get millisecondToDay {
    int toDay = (1000 * 60) * 60 * 24;

    return (this / toDay);
  }

  double get millisecondToHour {
    int toHour = (1000 * 60) * 60;

    return (this / toHour);
  }

  double get millisecondToMinute {
    int toMinute = (1000 * 60);

    return (this / toMinute);
  }
}
