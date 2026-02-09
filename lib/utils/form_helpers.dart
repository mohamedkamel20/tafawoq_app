import 'package:flutter/material.dart';
import '../constants.dart';

/// Centralized form helper utilities for consistent RTL-aware forms
class FormHelpers {
  /// Returns RTL-aware input decoration for text fields
  ///
  /// Usage:
  /// ```dart
  /// TextField(
  ///   decoration: FormHelpers.getInputDecoration(
  ///     context: context,
  ///     hintText: AppLocalizations.of(context)!.email,
  ///   ),
  /// )
  /// ```
  static InputDecoration getInputDecoration({
    required BuildContext context,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    String? errorText,
    bool isDense = false,
  }) {
    final textDirection = Directionality.of(context);
    final isRTL = textDirection == TextDirection.rtl;

    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: isDense,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsetsDirectional.only(
        start: 16.0,
        end: 16.0,
        top: isDense ? 12.0 : 16.0,
        bottom: isDense ? 12.0 : 16.0,
      ),
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
      labelStyle: const TextStyle(
        color: kTextColor,
        fontSize: 14,
      ),
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kTextColor, width: 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kTextColor, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  /// Returns RTL-aware input decoration with custom colors
  static InputDecoration getInputDecorationColored({
    required BuildContext context,
    required String hintText,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fillColor ?? Colors.white,
      contentPadding: const EdgeInsetsDirectional.only(
        start: 16.0,
        end: 16.0,
        top: 16.0,
        bottom: 16.0,
      ),
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor ?? kTextColor, width: 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: focusedBorderColor ?? kTextColor, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  /// Returns simple text field decoration without borders
  static InputDecoration getSimpleDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: InputBorder.none,
      contentPadding: const EdgeInsetsDirectional.only(
        start: 12.0,
        end: 12.0,
        top: 12.0,
        bottom: 12.0,
      ),
    );
  }
}
