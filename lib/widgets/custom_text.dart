import 'package:flutter/material.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? colors;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDirection? textDirection;

  const CustomText({
    super.key,
    this.text,
    this.fontSize,
    this.colors,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textDirection,
  });

  /// Localized constructor that automatically gets text from AppLocalizations
  ///
  /// Usage:
  /// ```dart
  /// CustomText.localized(
  ///   context: context,
  ///   textKey: (l10n) => l10n.signIn,
  ///   fontSize: 18,
  ///   fontWeight: FontWeight.bold,
  /// )
  /// ```
  factory CustomText.localized({
    required BuildContext context,
    required String Function(AppLocalizations) textKey,
    double? fontSize,
    Color? colors,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return CustomText(
      text: textKey(l10n),
      fontSize: fontSize,
      colors: colors,
      fontWeight: fontWeight,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: textDirection ?? Directionality.of(context),
      style: TextStyle(
        fontSize: fontSize ?? 16,
        color: colors ?? kSecondaryColor,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}
