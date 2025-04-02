import 'package:intl/intl.dart';

// Utility function to format date to a readable string
String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

// Utility function to validate numeric input
bool isValidInput(String input) {
  if (input.isEmpty) return false;
  final number = num.tryParse(input);
  return number != null && number > 0;
}
