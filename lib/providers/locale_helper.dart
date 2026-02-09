import 'package:tafawoq_app/constants.dart';
import 'package:flutter/material.dart';

/// Helper class for RTL/LTR layout utilities
/// Follows CommonFunctions pattern with static methods
class LocaleHelper {
  /// Check if current locale is RTL
  static bool isRTL(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return kRTLLocales.contains(locale.languageCode);
  }

  /// Get text direction based on locale
  static TextDirection getTextDirection(BuildContext context) {
    return isRTL(context) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Get directional alignment for start
  static AlignmentDirectional get alignStart =>
      AlignmentDirectional.centerStart;

  /// Get directional alignment for end
  static AlignmentDirectional get alignEnd => AlignmentDirectional.centerEnd;

  /// Create directional padding from start
  static EdgeInsetsDirectional paddingStart(double value) {
    return EdgeInsetsDirectional.only(start: value);
  }

  /// Create directional padding from end
  static EdgeInsetsDirectional paddingEnd(double value) {
    return EdgeInsetsDirectional.only(end: value);
  }

  /// Create directional padding with start and end
  static EdgeInsetsDirectional paddingHorizontal(double start, double end) {
    return EdgeInsetsDirectional.only(start: start, end: end);
  }

  /// Get directional icon for navigation (arrows flip in RTL)
  static IconData getNavigationIcon(BuildContext context,
      {required bool forward}) {
    final rtl = isRTL(context);
    if (forward) {
      return rtl ? Icons.arrow_back_ios : Icons.arrow_forward_ios;
    } else {
      return rtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    }
  }

  /// Get language display name
  static String getLanguageName(String code) {
    switch (code) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return code;
    }
  }
}
