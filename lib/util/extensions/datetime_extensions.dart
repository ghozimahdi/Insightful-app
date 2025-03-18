import 'package:intl/intl.dart';

extension DateTimeEx on DateTime {
  String get formattedString => '$day/$month/$year ${toString().substring(11, 19)}';

  String get daysAgo {
    final now = DateTime.now();
    final period = now.difference(this);
    return period.inDays == 0 ? "today at $hour:${minute > 9 ? minute : '0$minute'}" : '${period.inDays} days old';
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String get text {
    String month = '';
    switch (this.month) {
      case 1:
        month = 'Jan';
        break;
      case 2:
        month = 'Feb';
        break;
      case 3:
        month = 'Mar';
        break;
      case 4:
        month = 'Apr';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'Jun';
        break;
      case 7:
        month = 'Jul';
        break;
      case 8:
        month = 'Aug';
        break;
      case 9:
        month = 'Sep';
        break;
      case 10:
        month = 'Oct';
        break;
      case 11:
        month = 'Nov';
        break;
      case 12:
        month = 'Dec';
        break;
    }

    return '$day $month | ${toString().substring(11, 16)}';
  }

  String get shortDateNoYear {
    final date = this;
    final dayOfMonth = date.day.toString();
    final monthString = getMonthString(date.month).substring(0, 3);
    final dayTermination = dayOfMonth == '1' ? 'st' : dayOfMonth == '2' ? 'nd' : dayOfMonth == '3' ? 'rd' : 'th';
    return '$monthString $dayOfMonth$dayTermination';
  }

  String get shortDate {
    final date = this;
    final dayOfMonth = date.day.toString().padLeft(2, '0');
    final monthString = getMonthString(date.month).substring(0, 3);
    final year = date.year.toString();

    return "$dayOfMonth $monthString '${year.substring(2, 4)}";
  }

  String get time {
    return '${toString().substring(11, 16)}';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays >= 365) {
      return DateFormat('MMM d, yyyy').format(this);
    } else if (difference.inDays >= 7) {
      return DateFormat('MMM d').format(this);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}min';
    } else {
      return 'now';
    }
  }

  String get timeAgoLong {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays >= 7) {
      return DateFormat('MMM d').format(this);
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  String get longDate {
    final date = this;
    final dayOfWeek = _getDayOfWeek(date.weekday).substring(0, 3);
    final dayOfMonth = date.day.toString().padLeft(2, '0');
    final monthString = getMonthString(date.month);
    final year = date.year.toString();

    return '$dayOfWeek, $dayOfMonth $monthString $year';
  }

  String get longDateNoYear {
    final date = this;
    final time = toString().substring(11, 16);
    final dayOfWeek = _getDayOfWeek(date.weekday).substring(0, 3);
    final dayOfMonth = date.day.toString().padLeft(2, '0');
    final monthString = getMonthString(date.month).substring(0, 3);

    return '$dayOfWeek $dayOfMonth $monthString, $time';
  }

  String _getDayOfWeek(int dayOfWeek) {
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        throw ArgumentError('Invalid day of week: $dayOfWeek');
    }
  }

  String get chatMessageDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final comparisonDate = DateTime(year, month, day);

    if (comparisonDate == today) {
      return 'Today';
    } else if (comparisonDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM yyyy').format(this);
    }
  }
}

String getMonthString(int month) {
  switch (month) {
    case DateTime.january:
      return 'January';
    case DateTime.february:
      return 'February';
    case DateTime.march:
      return 'March';
    case DateTime.april:
      return 'April';
    case DateTime.may:
      return 'May';
    case DateTime.june:
      return 'June';
    case DateTime.july:
      return 'July';
    case DateTime.august:
      return 'August';
    case DateTime.september:
      return 'September';
    case DateTime.october:
      return 'October';
    case DateTime.november:
      return 'November';
    case DateTime.december:
      return 'December';
    default:
      throw ArgumentError('Invalid month: $month');
  }
}

String capitalizeWords(String input) {
  return input.split(' ').map((word) {
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}
