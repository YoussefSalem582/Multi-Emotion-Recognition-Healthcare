import 'package:flutter/material.dart';
import 'responsive_helper.dart';

/// A utility class that defines font styles and provides easy access to them.
/// The primary fonts can be easily changed by modifying the font family constants.
abstract class AppFonts {
  // Primary Font Families - Centralized for easy modification
  /// Primary display font used for large text elements
  static const String primaryDisplayFont = 'SF Pro Display';

  /// Primary heading font used for titles and headings
  static const String primaryHeadingFont = 'Readex Pro';

  /// Primary body font used for regular text content
  static const String primaryBodyFont = 'Rubik';

  // Legacy font family names - kept for backward compatibility
  static const String sfProDisplay = primaryDisplayFont;
  static const String readexPro = primaryHeadingFont;
  static const String rubik = primaryBodyFont;

  // Font Weights
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  /// Returns a responsive font size based on the context
  static double getResponsiveSize(BuildContext context, double baseSize) {
    return ResponsiveHelper.getResponsiveFontSize(context, baseSize);
  }

  /// Applies responsive sizing to an existing TextStyle
  static TextStyle makeResponsive(BuildContext context, TextStyle style) {
    return style.copyWith(
      fontSize: getResponsiveSize(context, style.fontSize ?? 14),
    );
  }

  /// Create a custom text style with specific parameters
  static TextStyle custom({
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    Color? color,
    TextDecoration? decoration,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }

  // Display Styles

  /// Display style - largest text, used for hero content
  /// 34px with regular weight, 41px line height
  static TextStyle display() {
    return const TextStyle(
      fontFamily: primaryDisplayFont,
      fontSize: 34,
      fontWeight: regular,
      height: 41 / 34, // line height 41px
    );
  }

  /// Display bold style - largest text with bold weight
  /// 34px with bold weight, 41px line height
  static TextStyle displayBold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 34,
      fontWeight: bold,
      height: 41 / 34, // line height 41px
    );
  }

  // Heading Styles

  /// Heading 1 style - very large headings
  /// 28px with regular weight, 36px line height
  static TextStyle heading1() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 28,
      fontWeight: regular,
      height: 36 / 28, // line height 36px
    );
  }

  /// Heading 1 bold style - very large headings with bold weight
  /// 28px with bold weight, 36px line height
  static TextStyle heading1Bold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 28,
      fontWeight: bold,
      height: 36 / 28, // line height 36px
    );
  }

  /// Heading 2 style - large headings
  /// 24px with regular weight, 31px line height
  static TextStyle heading2() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 24,
      fontWeight: regular,
      height: 31 / 24, // line height 31px
    );
  }

  /// Heading 2 bold style - large headings with bold weight
  /// 24px with bold weight, 31px line height
  static TextStyle heading2Bold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 24,
      fontWeight: bold,
      height: 31 / 24, // line height 31px
    );
  }

  /// Heading 3 style - medium headings
  /// 20px with regular weight, 26px line height
  static TextStyle heading3() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 20,
      fontWeight: regular,
      height: 26 / 20, // line height 26px
    );
  }

  /// Heading 3 bold style - medium headings with bold weight
  /// 20px with bold weight, 26px line height
  static TextStyle heading3Bold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 20,
      fontWeight: bold,
      height: 26 / 20, // line height 26px
    );
  }

  /// Heading 4 style - small headings
  /// 16px with regular weight, 21px line height
  static TextStyle heading4() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 16,
      fontWeight: regular,
      height: 21 / 16, // line height 21px
    );
  }

  /// Heading 4 semibold style - small headings with semibold weight
  /// 16px with semibold weight, 21px line height
  static TextStyle heading4SemiBold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 16,
      fontWeight: semiBold,
      height: 21 / 16, // line height 21px
    );
  }

  /// Heading 5 style - smallest headings
  /// 14px with regular weight, 18px line height
  static TextStyle heading5() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 14,
      fontWeight: regular,
      height: 18 / 14, // line height 18px
    );
  }

  /// Heading 5 semibold style - smallest headings with semibold weight
  /// 14px with semibold weight, 18px line height
  static TextStyle heading5SemiBold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 14,
      fontWeight: semiBold,
      height: 18 / 14, // line height 18px
    );
  }

  // Body Text Styles

  /// Body style - standard text
  /// 14px with regular weight, 20px line height
  static TextStyle body() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 14,
      fontWeight: regular,
      height: 20 / 14, // line height 20px
    );
  }

  /// Body medium style - emphasized text
  /// 14px with medium weight, 20px line height
  static TextStyle bodyMedium() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 14,
      fontWeight: medium,
      height: 20 / 14, // line height 20px
    );
  }

  /// Body bold style - strongly emphasized text
  /// 14px with bold weight, 20px line height
  static TextStyle bodyBold() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 14,
      fontWeight: bold,
      height: 20 / 14, // line height 20px
    );
  }

  // Footnote Styles

  /// Footnote style - smaller text for footnotes
  /// 13px with regular weight, 20px line height
  static TextStyle footnote() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 13,
      fontWeight: regular,
      height: 20 / 13, // line height 20px
    );
  }

  /// Footnote medium style - emphasized footnotes
  /// 13px with medium weight, 20px line height
  static TextStyle footnoteMedium() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 13,
      fontWeight: medium,
      height: 20 / 13, // line height 20px
    );
  }

  // Caption Styles

  /// Caption large style - large caption text
  /// 12px with regular weight, 17px line height
  static TextStyle captionLarge() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 12,
      fontWeight: regular,
      height: 17 / 12, // line height 17px
    );
  }

  /// Caption large semibold style - emphasized large caption text
  /// 12px with semibold weight, 17px line height
  static TextStyle captionLargeSemiBold() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 12,
      fontWeight: semiBold,
      height: 17 / 12, // line height 17px
    );
  }

  /// Caption medium style - medium caption text
  /// 11px with regular weight, 15px line height
  static TextStyle captionMedium() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 11,
      fontWeight: regular,
      height: 15 / 11, // line height 15px
    );
  }

  /// Caption medium semibold style - emphasized medium caption text
  /// 11px with semibold weight, 15px line height
  static TextStyle captionMediumSemiBold() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 11,
      fontWeight: semiBold,
      height: 15 / 11, // line height 15px
    );
  }

  /// Caption small style - smallest caption text
  /// 10px with regular weight, 14px line height
  static TextStyle captionSmall() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 10,
      fontWeight: regular,
      height: 14 / 10, // line height 14px
    );
  }

  /// Caption small bold style - emphasized smallest caption text
  /// 10px with bold weight, 14px line height
  static TextStyle captionSmallBold() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 10,
      fontWeight: bold,
      height: 14 / 10, // line height 14px
    );
  }

  // Responsive Text Style Methods

  /// Responsive display style
  static TextStyle displayResponsive(BuildContext context) {
    return makeResponsive(context, display());
  }

  /// Responsive display bold style
  static TextStyle displayBoldResponsive(BuildContext context) {
    return makeResponsive(context, displayBold());
  }

  /// Responsive heading 1 style
  static TextStyle heading1Responsive(BuildContext context) {
    return makeResponsive(context, heading1());
  }

  /// Responsive heading 1 bold style
  static TextStyle heading1BoldResponsive(BuildContext context) {
    return makeResponsive(context, heading1Bold());
  }

  /// Responsive heading 2 style
  static TextStyle heading2Responsive(BuildContext context) {
    return makeResponsive(context, heading2());
  }

  /// Responsive heading 2 bold style
  static TextStyle heading2BoldResponsive(BuildContext context) {
    return makeResponsive(context, heading2Bold());
  }

  /// Responsive heading 3 style
  static TextStyle heading3Responsive(BuildContext context) {
    return makeResponsive(context, heading3());
  }

  /// Responsive heading 3 bold style
  static TextStyle heading3BoldResponsive(BuildContext context) {
    return makeResponsive(context, heading3Bold());
  }

  /// Responsive heading 4 style
  static TextStyle heading4Responsive(BuildContext context) {
    return makeResponsive(context, heading4());
  }

  /// Responsive heading 4 semibold style
  static TextStyle heading4SemiBoldResponsive(BuildContext context) {
    return makeResponsive(context, heading4SemiBold());
  }

  /// Responsive heading 5 style
  static TextStyle heading5Responsive(BuildContext context) {
    return makeResponsive(context, heading5());
  }

  /// Responsive heading 5 semibold style
  static TextStyle heading5SemiBoldResponsive(BuildContext context) {
    return makeResponsive(context, heading5SemiBold());
  }

  /// Responsive body style
  static TextStyle bodyResponsive(BuildContext context) {
    return makeResponsive(context, body());
  }

  /// Responsive body medium style
  static TextStyle bodyMediumResponsive(BuildContext context) {
    return makeResponsive(context, bodyMedium());
  }

  /// Responsive body bold style
  static TextStyle bodyBoldResponsive(BuildContext context) {
    return makeResponsive(context, bodyBold());
  }

  /// Responsive footnote style
  static TextStyle footnoteResponsive(BuildContext context) {
    return makeResponsive(context, footnote());
  }

  /// Responsive footnote medium style
  static TextStyle footnoteMediumResponsive(BuildContext context) {
    return makeResponsive(context, footnoteMedium());
  }

  /// Apply a specific color to any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
}
