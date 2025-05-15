// ignore_for_file: prefer_single_quotes

import 'package:flutter/material.dart';

/// A centralized class for managing all image assets in the application.
/// This helps maintain consistency and makes it easier to update paths.
class Assets {
  Assets._();

  /// Get an asset path with the images directory prefix
  static String _getImagePath(String path) => 'assets/images/$path';

  /// Logo assets for the application
  static final Logos logos = Logos._();

  /// Icon assets for the application
  static final ImageIcons icons = ImageIcons._();

  /// UI element assets for the application
  static final UI ui = UI._();

  /// Onboarding screen assets
  static final Onboarding onboarding = Onboarding._();

  /// Returns a widget to display an image asset (handles SVG and PNG automatically)
  static Widget getImage(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    if (assetPath.toLowerCase().endsWith('.svg')) {
      // Use SVG rendering (requires flutter_svg package)
      // return SvgPicture.asset(
      //   assetPath,
      //   width: width,
      //   height: height,
      //   fit: fit,
      //   color: color,
      // );

      // Placeholder implementation if flutter_svg is not available
      return Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey.withOpacity(0.3),
            child: const Center(child: Text('SVG (Add flutter_svg package)')),
          );
        },
      );
    } else {
      // Use regular Image widget for PNG, JPG, etc.
      return Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    }
  }
}

/// Logo assets for the application
class Logos {
  Logos._();

  /// Standard application logo (SVG)
  final String standard = "assets/images/logos/Logo.svg";

  /// Blue variant of the application logo (SVG)
  final String blue = "assets/images/logos/blue_logo.svg";

  /// Full application logo with text (SVG)
  final String full = "assets/images/logos/full_logo.svg";

  /// Returns a widget to display the standard logo
  Widget get standardWidget => Assets.getImage(standard);

  /// Returns a widget to display the blue logo
  Widget get blueWidget => Assets.getImage(blue);

  /// Returns a widget to display the full logo
  Widget get fullWidget => Assets.getImage(full);
}

/// Icon assets for the application
class ImageIcons {
  ImageIcons._();

  /// Standard application icon (PNG)
  final String appIcon = "assets/images/icons/app_icon.png";

  /// Full application icon with background (PNG)
  final String fullAppIcon = "assets/images/icons/full_app_icon.png";

  /// Apple login icon (SVG)
  final String apple = "assets/images/icons/apple_icon.svg";

  /// Facebook login icon (SVG)
  final String facebook = "assets/images/icons/facebook_icon.svg";

  /// Google login icon (SVG)
  final String google = "assets/images/icons/google_icon.svg";

  /// Returns all social media icons as a map
  Map<String, String> get socialIcons => {
    'apple': apple,
    'facebook': facebook,
    'google': google,
  };
}

/// UI element assets for the application
class UI {
  UI._();

  /// Line divider graphic (SVG)
  final String line = "assets/images/ui/Line.svg";

  /// Returns a widget to display the line divider
  Widget getLine({double? width, double? height, Color? color}) {
    return Assets.getImage(line, width: width, height: height, color: color);
  }
}

/// Onboarding screen assets
class Onboarding {
  Onboarding._();

  /// First onboarding image (PNG)
  final String image1 = "assets/images/onboarding/on_boarding_1.png";

  /// Second onboarding image (PNG)
  final String image2 = "assets/images/onboarding/on_boarding_2.png";

  /// Third onboarding image (PNG)
  final String image3 = "assets/images/onboarding/on_boarding_3.png";

  /// Returns all onboarding images as a list
  List<String> get allImages => [image1, image2, image3];

  /// Returns a widget for a specific onboarding image by index (0-2)
  Widget getImage(int index, {double? width, double? height}) {
    assert(
      index >= 0 && index <= 2,
      "Onboarding image index must be between 0 and 2",
    );
    final imageAsset = index == 0 ? image1 : (index == 1 ? image2 : image3);
    return Assets.getImage(
      imageAsset,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
