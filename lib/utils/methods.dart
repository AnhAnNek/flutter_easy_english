// Formats a given ISO string to a human-readable date format
import 'package:intl/intl.dart';

String formatDate(String isoString) {
  print('isoString: $isoString');
  DateTime date = DateTime.parse(isoString);

  if (date.isBefore(DateTime(1970))) {
    return 'Invalid Date';
  }

  return '${date.year} ${_getMonth(date.month)} ${date.day}, ${_formatTime(date)}';
}

// Helper function to get the month name from a month number
String _getMonth(int month) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return months[month - 1];
}

// Helper function to format time (hour, minute, second)
String _formatTime(DateTime date) {
  return '${_twoDigit(date.hour)}:${_twoDigit(date.minute)}:${_twoDigit(date.second)} ${date.hour >= 12 ? 'PM' : 'AM'}';
}

// Helper function to format time as two digits
String _twoDigit(int number) => number < 10 ? '0$number' : '$number';

// Formats seconds into a "mm:ss" format
String formatTime(int seconds) {
  int minutes = (seconds / 60).floor();
  int secs = seconds % 60;
  return '$minutes:${secs < 10 ? '0' : ''}$secs';
}

// Simulate a delay for loading (like a loading spinner) based on a start time
Future<void> delayLoading(DateTime startTime) async {
  Duration elapsedTime = DateTime.now().difference(startTime);
  Duration delay = Duration(milliseconds: (500 - elapsedTime.inMilliseconds).clamp(0, 500));
  await Future.delayed(delay);
}

// Validate password with various checks
List<String> validatePassword(String password, String confirmPassword) {
  List<String> errors = [];
  if (password.length < 8) errors.add("Password must be at least 8 characters long.");
  if (!RegExp(r'[A-Z]').hasMatch(password)) errors.add("Password must contain at least one uppercase letter.");
  if (!RegExp(r'[a-z]').hasMatch(password)) errors.add("Password must contain at least one lowercase letter.");
  if (!RegExp(r'\d').hasMatch(password)) errors.add("Password must contain at least one digit.");
  if (!RegExp(r'[!@#$%^&*]').hasMatch(password)) errors.add("Password must contain at least one special character.");
  if (password != confirmPassword) errors.add("Password and Confirm Password do not match.");
  return errors;
}

final vndFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

