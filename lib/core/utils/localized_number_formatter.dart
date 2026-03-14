import 'package:flutter/material.dart';

class LocalizedNumberFormatter {
  static const _easternArabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  static String format(int number, Locale locale) {
    if (locale.languageCode == 'ar') {
      return _toEasternArabic(number);
    }
    return number.toString();
  }

  static String formatDecimal(double number, Locale locale) {
    if (locale.languageCode == 'ar') {
      final parts = number.toStringAsFixed(2).split('.');
      final integerPart = _toEasternArabic(int.parse(parts[0]));
      final decimalPart = parts.length > 1 ? parts[1] : '٠٠';
      return '$integerPart.$decimalPart';
    }
    return number.toStringAsFixed(2);
  }

  static String formatCount(int count, Locale locale) {
    return format(count, locale);
  }

  static String _toEasternArabic(int number) {
    if (number == 0) return _easternArabicNumerals[0];
    
    final result = StringBuffer();
    if (number < 0) {
      result.write('−');
      number = number.abs();
    }
    
    final digits = number.toString().split('');
    for (final digit in digits) {
      final parsed = int.tryParse(digit);
      if (parsed != null && parsed >= 0 && parsed <= 9) {
        result.write(_easternArabicNumerals[parsed]);
      } else {
        result.write(digit);
      }
    }
    return result.toString();
  }
}
