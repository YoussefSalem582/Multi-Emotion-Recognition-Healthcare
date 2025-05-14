import 'package:flutter/material.dart';

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

  // عرض (Display)
  static TextStyle display() {
    return const TextStyle(
      fontFamily: primaryDisplayFont,
      fontSize: 34,
      fontWeight: regular,
      height: 41 / 34, // line height 41px
    );
  }

  // عرض (عريض) (Display Bold)
  static TextStyle displayBold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 34,
      fontWeight: bold,
      height: 41 / 34, // line height 41px
    );
  }

  // عنوان 1 (Heading 1)
  static TextStyle heading1() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 28,
      fontWeight: regular,
      height: 36 / 28, // line height 36px
    );
  }

  // عنوان 1 عريض (Heading 1 Bold)
  static TextStyle heading1Bold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 28,
      fontWeight: bold,
      height: 36 / 28, // line height 36px
    );
  }

  // عنوان 2 (Heading 2)
  static TextStyle heading2() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 24,
      fontWeight: regular,
      height: 31 / 24, // line height 31px
    );
  }

  // عنوان 2 عريض (Heading 2 Bold)
  static TextStyle heading2Bold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 24,
      fontWeight: bold,
      height: 31 / 24, // line height 31px
    );
  }

  // عنوان 3 (Heading 3)
  static TextStyle heading3() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 20,
      fontWeight: regular,
      height: 26 / 20, // line height 26px
    );
  }

  // عنوان 3 عريض (Heading 3 Bold)
  static TextStyle heading3Bold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 20,
      fontWeight: bold,
      height: 26 / 20, // line height 26px
    );
  }

  // عنوان 4 (Heading 4)
  static TextStyle heading4() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 16,
      fontWeight: regular,
      height: 21 / 16, // line height 21px
    );
  }

  // عنوان 4 شبه عريض (Heading 4 SemiBold)
  static TextStyle heading4SemiBold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 16,
      fontWeight: semiBold,
      height: 21 / 16, // line height 21px
    );
  }

  // عنوان 5 (Heading 5)
  static TextStyle heading5() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 14,
      fontWeight: regular,
      height: 18 / 14, // line height 18px
    );
  }

  // عنوان 5 شبه عريض (Heading 5 SemiBold)
  static TextStyle heading5SemiBold() {
    return const TextStyle(
      fontFamily: primaryHeadingFont,
      fontSize: 14,
      fontWeight: semiBold,
      height: 18 / 14, // line height 18px
    );
  }

  // Body (Body)
  static TextStyle body() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 14,
      fontWeight: regular,
      height: 20 / 14, // line height 20px
    );
  }

  // Body Medium (Body Medium)
  static TextStyle bodyMedium() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 14,
      fontWeight: medium,
      height: 20 / 14, // line height 20px
    );
  }

  // Footnote (Footnote)
  static TextStyle footnote() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 13,
      fontWeight: regular,
      height: 20 / 13, // line height 20px
    );
  }

  // Footnote Medium (Footnote Medium)
  static TextStyle footnoteMedium() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 13,
      fontWeight: medium,
      height: 20 / 13, // line height 20px
    );
  }

  // Caption L (Caption L)
  static TextStyle captionLarge() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 12,
      fontWeight: regular,
      height: 17 / 12, // line height 17px
    );
  }

  // Caption L SemiBold (Caption L SemiBold)
  static TextStyle captionLargeSemiBold() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 12,
      fontWeight: semiBold,
      height: 17 / 12, // line height 17px
    );
  }

  // Caption M (Caption M)
  static TextStyle captionMedium() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 11,
      fontWeight: regular,
      height: 15 / 11, // line height 15px
    );
  }

  // Caption M SemiBold (Caption M SemiBold)
  static TextStyle captionMediumSemiBold() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 11,
      fontWeight: semiBold,
      height: 15 / 11, // line height 15px
    );
  }

  // Caption S (Caption S)
  static TextStyle captionSmall() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 10,
      fontWeight: regular,
      height: 14 / 10, // line height 14px
    );
  }

  // Caption S Bold (Caption S Bold)
  static TextStyle captionSmallBold() {
    return const TextStyle(
      fontFamily: primaryBodyFont,
      fontSize: 10,
      fontWeight: bold,
      height: 14 / 10, // line height 14px
    );
  }
}
