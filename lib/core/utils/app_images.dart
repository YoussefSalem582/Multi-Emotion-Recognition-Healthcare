// ignore_for_file: prefer_single_quotes

/// A centralized class for managing all image assets in the application.
/// This helps maintain consistency and makes it easier to update paths.
class Assets {
  Assets._();

  // Logo assets
  static const String imagesLogo = "assets/images/logos/Logo.svg";
  static const String imagesBlueLogo = "assets/images/logos/blue_logo.svg";
  static const String imagesFullLogo = "assets/images/logos/full_logo.svg";

  // App icon assets
  static const String imagesAppIcon = "assets/images/icons/app_icon.png";
  static const String imagesFullAppIcon =
      "assets/images/icons/full_app_icon.png";

  /// Assets for imagesLine
  /// assets/images/Line.svg
  static const String imagesLine = "assets/images/ui/Line.svg";

  // Social media icons
  static const String imagesAppleIcon = "assets/images/icons/apple_icon.svg";
  static const String imagesFacebookIcon =
      "assets/images/icons/facebook_icon.svg";
  static const String imagesGoogleIcon = "assets/images/icons/google_icon.svg";

  // Onboarding images
  // Note: These images need to be added to the assets folder
  static const String imagesOnBoarding1 =
      "assets/images/onboarding/on_boarding_1.png";
  static const String imagesOnBoarding2 =
      "assets/images/onboarding/on_boarding_2.png";
  static const String imagesOnBoarding3 =
      "assets/images/onboarding/on_boarding_3.png";
}
