import 'package:flutter/material.dart';

/// A centralized class for all color definitions used throughout the application.
///
/// This class provides consistent colors for the UI, ensuring a cohesive look
/// and providing better maintainability when changing color schemes.
abstract class AppColors {
  // Brand Colors - Primary
  /// The primary brand color used throughout the application
  static const Color primary = Color(0xFF3943BD);
  static const Color primaryLight = Color(0xFF6169CE);
  static const Color primaryDark = Color(0xFF27318A);

  // Basic Colors
  /// Pure black color
  static const Color black = Color(0xFF000000);

  /// Pure white color
  static const Color white = Color(0xFFFFFFFF);

  // Transparent Colors - Black
  /// Black with 10% opacity
  static const Color black10 = Color(0x1A000000); // 10%
  /// Black with 15% opacity
  static const Color black15 = Color(0x26000000); // 15%
  /// Black with 20% opacity
  static const Color black20 = Color(0x33000000); // 20%
  /// Black with 30% opacity
  static const Color black30 = Color(0x4D000000); // 30%
  /// Black with 40% opacity
  static const Color black40 = Color(0x66000000); // 40%
  /// Black with 50% opacity
  static const Color black50 = Color(0x80000000); // 50%
  /// Black with 60% opacity
  static const Color black60 = Color(0x99000000); // 60%
  /// Black with 70% opacity
  static const Color black70 = Color(0xB3000000); // 70%
  /// Black with 80% opacity
  static const Color black80 = Color(0xCC000000); // 80%
  /// Black with 90% opacity
  static const Color black90 = Color(0xE6000000); // 90%

  // Transparent Colors - White
  /// White with 10% opacity
  static const Color white10 = Color(0x1AFFFFFF); // 10%
  /// White with 15% opacity
  static const Color white15 = Color(0x26FFFFFF); // 15%
  /// White with 20% opacity
  static const Color white20 = Color(0x33FFFFFF); // 20%
  /// White with 30% opacity
  static const Color white30 = Color(0x4DFFFFFF); // 30%
  /// White with 40% opacity
  static const Color white40 = Color(0x66FFFFFF); // 40%
  /// White with 50% opacity
  static const Color white50 = Color(0x80FFFFFF); // 50%
  /// White with 60% opacity
  static const Color white60 = Color(0x99FFFFFF); // 60%
  /// White with 70% opacity
  static const Color white70 = Color(0xB3FFFFFF); // 70%
  /// White with 80% opacity
  static const Color white80 = Color(0xCCFFFFFF); // 80%
  /// White with 90% opacity
  static const Color white90 = Color(0xE6FFFFFF); // 90%

  // Transparent Colors - Primary
  /// Primary color with 10% opacity
  static const Color primary10 = Color(0x1A3943BD); // 10%
  /// Primary color with 15% opacity
  static const Color primary15 = Color(0x263943BD); // 15%
  /// Primary color with 20% opacity
  static const Color primary20 = Color(0x333943BD); // 20%
  /// Primary color with 30% opacity
  static const Color primary30 = Color(0x4D3943BD); // 30%
  /// Primary color with 40% opacity
  static const Color primary40 = Color(0x663943BD); // 40%
  /// Primary color with 50% opacity
  static const Color primary50 = Color(0x803943BD); // 50%
  /// Primary color with 60% opacity
  static const Color primary60 = Color(0x993943BD); // 60%
  /// Primary color with 70% opacity
  static const Color primary70 = Color(0xB33943BD); // 70%
  /// Primary color with 80% opacity
  static const Color primary80 = Color(0xCC3943BD); // 80%
  /// Primary color with 90% opacity
  static const Color primary90 = Color(0xE63943BD); // 90%

  // Transparent Colors - Red
  /// Red with 10% opacity
  static const Color red10 = Color(0x1AF30B26); // 10%
  /// Red with 15% opacity
  static const Color red15 = Color(0x26F30B26); // 15%
  /// Red with 20% opacity
  static const Color red20 = Color(0x33F30B26); // 20%
  /// Red with 30% opacity
  static const Color red30 = Color(0x4DF30B26); // 30%
  /// Red with 40% opacity
  static const Color red40 = Color(0x66F30B26); // 40%
  /// Red with 50% opacity
  static const Color red50 = Color(0x80F30B26); // 50%
  /// Red with 60% opacity
  static const Color red60 = Color(0x99F30B26); // 60%
  /// Red with 70% opacity
  static const Color red70 = Color(0xB3F30B26); // 70%
  /// Red with 80% opacity
  static const Color red80 = Color(0xCCF30B26); // 80%
  /// Red with 90% opacity
  static const Color red90 = Color(0xE6F30B26); // 90%

  // Secondary Colors
  /// Green color for success states
  static const Color green = Color(0xFF1EB835);

  /// Orange color for warning states
  static const Color orange = Color(0xFFF75C31);

  /// Pink color for highlights
  static const Color pink = Color(0xFFE02BB9);

  /// Red color for error states
  static const Color red = Color(0xFFF30B26);

  // Light variants of secondary colors
  /// Light green for success backgrounds
  static const Color greenLight = Color(0xFFBCEAC2);

  /// Light orange for warning backgrounds
  static const Color orangeLight = Color(0xFFFDCEC1);

  /// Light pink for highlight backgrounds
  static const Color pinkLight = Color(0xFFF6BFEA);

  /// Light red for error backgrounds
  static const Color redLight = Color(0xFFF8B6BE);

  /// Light purple for information backgrounds
  static const Color purpleLight = Color(0xFFD7C1FD);

  // Gray Scale - Ordered from darkest to lightest
  /// Very dark gray, almost black
  static const Color gray900 = Color(0xFF353535);

  /// Dark gray for text
  static const Color gray800 = Color(0xFF484848);

  /// Medium-dark gray
  static const Color gray700 = Color(0xFF606060);

  /// Medium gray
  static const Color gray600 = Color(0xFF808080);

  /// Medium-light gray
  static const Color gray500 = Color(0xFFA1A1A1);

  /// Light gray
  static const Color gray400 = Color(0xFFC5C5C5);

  /// Very light gray for borders
  static const Color gray300 = Color(0xFFE1E1E1);

  /// Extremely light gray for dividers
  static const Color gray200 = Color(0xFFECECEC);

  /// Almost white gray for backgrounds
  static const Color gray100 = Color(0xFFF5F5F5);

  // Status Colors - Used for feedback and status indicators
  /// Green color for success states
  static const Color success = Color(0xFF4CAF50);

  /// Red color for error states
  static const Color error = Color(0xFFB00020);

  /// Yellow/Amber color for warning states
  static const Color warning = Color(0xFFFFC107);

  /// Blue color for information states
  static const Color info = Color(0xFF2196F3);

  // Semantic Text Colors
  /// Primary text color for most content
  static const Color textPrimary = Color(0xFF363739);

  /// Secondary text color for less important content
  static const Color textSecondary = Color(0xFF5F5F5F);

  /// Text color for disabled states
  static const Color textDisabled = Color(0xFFADADAD);

  /// Text color that contrasts well on primary color
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Text color for links and highlighted text
  static const Color textLink = Color(0xFF3943BD);

  // Shadow Colors
  /// Standard shadow color
  static const Color shadow = Color(0x0C363739);

  /// Darker shadow for elevated elements
  static const Color shadowDark = Color(0x29000000);

  // Background Colors
  /// Default page background color
  static const Color background = Color(0xFFFAFAFA);

  /// Card and elevated surface background color
  static const Color surface = Color(0xFFFFFFFF);

  /// Alternative surface color for contrast
  static const Color surfaceVariant = Color(0xFFF0F0F0);

  // Button Colors
  /// Background color for primary buttons
  static const Color buttonPrimary = primary;

  /// Background color for secondary buttons
  static const Color buttonSecondary = Color(0xFFEEEEEE);

  /// Background color for disabled buttons
  static const Color buttonDisabled = Color(0xFFD6D6D6);

  // Border Colors
  /// Standard border color
  static const Color border = Color(0xFFE1E1E1);

  /// Focused border color
  static const Color borderFocused = primary60;

  /// Error border color
  static const Color borderError = red;

  // Emotion Colors - Used for emotion visualizations
  /// Color representing happiness
  static const Color emotionHappy = Color(0xFF4CAF50);

  /// Color representing sadness
  static const Color emotionSad = Color(0xFF5C6BC0);

  /// Color representing anger
  static const Color emotionAngry = Color(0xFFE53935);

  /// Color representing fear
  static const Color emotionFearful = Color(0xFF8E24AA);

  /// Color representing surprise
  static const Color emotionSurprised = Color(0xFFFFD54F);

  /// Color representing disgust
  static const Color emotionDisgusted = Color(0xFF8D6E63);

  /// Color representing neutral emotions
  static const Color emotionNeutral = Color(0xFF78909C);

  // Utility Functions

  /// Creates a new color that is a specified [percent] darker than the provided [color].
  /// [percent] must be between 0 and 1.
  static Color darken(Color color, double percent) {
    assert(percent >= 0 && percent <= 1);

    final int red = (color.red * (1 - percent)).round();
    final int green = (color.green * (1 - percent)).round();
    final int blue = (color.blue * (1 - percent)).round();

    return Color.fromARGB(color.alpha, red, green, blue);
  }

  /// Creates a new color that is a specified [percent] lighter than the provided [color].
  /// [percent] must be between 0 and 1.
  static Color lighten(Color color, double percent) {
    assert(percent >= 0 && percent <= 1);

    final int red = (color.red + ((255 - color.red) * percent)).round();
    final int green = (color.green + ((255 - color.green) * percent)).round();
    final int blue = (color.blue + ((255 - color.blue) * percent)).round();

    return Color.fromARGB(color.alpha, red, green, blue);
  }

  /// Creates a transparent version of the provided [color] with the specified [opacity].
  /// [opacity] must be between 0 and 1.
  static Color withOpacity(Color color, double opacity) {
    assert(opacity >= 0 && opacity <= 1);

    return color.withOpacity(opacity);
  }

  /// Returns a color that contrasts well with the provided [color].
  /// Useful for determining text color on varying backgrounds.
  static Color getContrastingColor(Color color) {
    // Calculate the perceived brightness of the color
    final double brightness =
        (color.red * 299 + color.green * 587 + color.blue * 114) / 1000;

    // Return black or white based on the brightness
    return brightness > 125 ? black : white;
  }
}
