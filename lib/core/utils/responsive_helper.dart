import 'package:flutter/material.dart';

/// Helper class for responsive design
///
/// This class provides utility methods for creating responsive layouts
/// that adapt to different screen sizes and orientations.
class ResponsiveHelper {
  /// Extra small screen size (e.g., small smartphones)
  static const double extraSmallScreenSize = 320.0;

  /// Small screen size (e.g., most smartphones)
  static const double smallScreenSize = 360.0;

  /// Medium screen size (e.g., large smartphones and small tablets)
  static const double mediumScreenSize = 600.0;

  /// Large screen size (e.g., tablets)
  static const double largeScreenSize = 900.0;

  /// Extra large screen size (e.g., desktop browsers)
  static const double extraLargeScreenSize = 1200.0;

  /// Get the current device type based on the screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < smallScreenSize) {
      return DeviceType.extraSmallPhone;
    } else if (width < mediumScreenSize) {
      return DeviceType.phone;
    } else if (width < largeScreenSize) {
      return DeviceType.tablet;
    } else if (width < extraLargeScreenSize) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }

  /// Returns true if the device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Returns true if the device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Returns true if the screen width is less than [smallScreenSize]
  static bool isExtraSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < extraSmallScreenSize;
  }

  /// Returns true if the screen width is less than [mediumScreenSize] but not less than [smallScreenSize]
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < smallScreenSize;
  }

  /// Returns true if the screen width is less than [largeScreenSize] but not less than [mediumScreenSize]
  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < mediumScreenSize &&
        MediaQuery.of(context).size.width >= smallScreenSize;
  }

  /// Returns true if the screen width is greater than or equal to [largeScreenSize]
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeScreenSize;
  }

  /// Returns true if the screen width is greater than or equal to [extraLargeScreenSize]
  static bool isExtraLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= extraLargeScreenSize;
  }

  /// Returns a value based on the screen size
  /// [mobile] is used for screens smaller than [mediumScreenSize]
  /// [tablet] is used for screens smaller than [largeScreenSize] but not smaller than [mediumScreenSize]
  /// [desktop] is used for screens larger than or equal to [largeScreenSize]
  static T getValueForScreenType<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width >= extraLargeScreenSize) {
      return largeDesktop ?? desktop ?? tablet ?? mobile;
    }

    if (width >= largeScreenSize) {
      return desktop ?? tablet ?? mobile;
    }

    if (width >= mediumScreenSize) {
      return tablet ?? mobile;
    }

    return mobile;
  }

  /// Returns a value based on the device orientation
  static T getValueForOrientation<T>({
    required BuildContext context,
    required T portrait,
    required T landscape,
  }) {
    return isPortrait(context) ? portrait : landscape;
  }

  /// Returns the number of grid columns to use based on screen width
  static int getGridColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final DeviceType deviceType = getDeviceType(context);
    final bool isPortraitMode = isPortrait(context);

    // Adjust columns based on device type and orientation
    switch (deviceType) {
      case DeviceType.extraSmallPhone:
        return 1;
      case DeviceType.phone:
        return isPortraitMode ? 2 : 3;
      case DeviceType.tablet:
        return isPortraitMode ? 3 : 4;
      case DeviceType.desktop:
        return 4;
      case DeviceType.largeDesktop:
        return 6;
    }
  }

  /// Returns the aspect ratio for grid items based on screen width
  static double getGridAspectRatio(BuildContext context) {
    final DeviceType deviceType = getDeviceType(context);
    final bool isPortraitMode = isPortrait(context);

    // Adjust aspect ratio based on device type and orientation
    switch (deviceType) {
      case DeviceType.extraSmallPhone:
        return 1.0; // Square for very small screens
      case DeviceType.phone:
        return isPortraitMode ? 1.2 : 1.4;
      case DeviceType.tablet:
        return isPortraitMode ? 1.5 : 1.8;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 1.8;
    }
  }

  /// Returns the appropriate padding for the screen size
  static EdgeInsets getScreenPadding(BuildContext context) {
    final DeviceType deviceType = getDeviceType(context);

    // Adjust padding based on device type
    switch (deviceType) {
      case DeviceType.extraSmallPhone:
        return const EdgeInsets.all(8.0);
      case DeviceType.phone:
        return const EdgeInsets.all(12.0);
      case DeviceType.tablet:
        return const EdgeInsets.all(16.0);
      case DeviceType.desktop:
        return const EdgeInsets.all(24.0);
      case DeviceType.largeDesktop:
        return const EdgeInsets.all(32.0);
    }
  }

  /// Returns the appropriate font size based on the screen size and the base font size
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize, {
    double? minFontSize,
    double? maxFontSize,
  }) {
    final width = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    double scaleFactor;

    // Calculate scale factor based on screen width
    if (width < extraSmallScreenSize) {
      scaleFactor = 0.8;
    } else if (width < smallScreenSize) {
      scaleFactor = 0.9;
    } else if (width >= extraLargeScreenSize) {
      scaleFactor = 1.2;
    } else if (width >= largeScreenSize) {
      scaleFactor = 1.1;
    } else {
      scaleFactor = 1.0;
    }

    // Apply text scale factor from system
    double fontSize = baseFontSize * scaleFactor * textScaleFactor;

    // Apply min/max constraints if provided
    if (minFontSize != null && fontSize < minFontSize) {
      fontSize = minFontSize;
    }
    if (maxFontSize != null && fontSize > maxFontSize) {
      fontSize = maxFontSize;
    }

    return fontSize;
  }

  /// Returns a responsive size based on the screen width percentage
  static double getResponsiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  /// Returns a responsive size based on the screen height percentage
  static double getResponsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  /// Returns the safe area insets
  static EdgeInsets getSafeAreaInsets(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Returns whether the device has a notch
  static bool hasNotch(BuildContext context) {
    final EdgeInsets insets = getSafeAreaInsets(context);
    return insets.top > 24.0; // Rough estimate based on common notch sizes
  }
}

/// Enum representing different device types based on screen size
enum DeviceType {
  /// Extra small phones (width < 360)
  extraSmallPhone,

  /// Regular phones (width >= 360 && width < 600)
  phone,

  /// Tablets (width >= 600 && width < 900)
  tablet,

  /// Desktop (width >= 900 && width < 1200)
  desktop,

  /// Large desktop (width >= 1200)
  largeDesktop,
}
