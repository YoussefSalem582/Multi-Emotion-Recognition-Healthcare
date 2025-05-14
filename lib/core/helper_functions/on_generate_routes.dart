import 'package:flutter/material.dart';
import '../../presentation/pages/home_page.dart';
import '../../screens/dashboard_page.dart';
import '../../screens/record_page.dart';
import '../../screens/video_page.dart';
import '../../screens/main_screen.dart';
import '../../presentation/pages/app_icon_demo.dart';
import '../../presentation/pages/video_analysis_page.dart';

// Named routes
class AppRoutes {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String record = '/record';
  static const String video = '/video';
  static const String main = '/main';
  static const String appIconDemo = '/appIconDemo';
  static const String videoAnalysis = '/videoAnalysis';
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.main:
      return MaterialPageRoute(
        builder: (context) => const MainScreen(),
        settings: settings,
      );
    case AppRoutes.home:
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
        settings: settings,
      );
    case AppRoutes.dashboard:
      return MaterialPageRoute(
        builder: (context) => const DashboardPage(),
        settings: settings,
      );
    case AppRoutes.record:
      return MaterialPageRoute(
        builder: (context) => const RecordPage(),
        settings: settings,
      );
    case AppRoutes.video:
      return MaterialPageRoute(
        builder: (context) => const VideoPage(),
        settings: settings,
      );
    case AppRoutes.appIconDemo:
      return MaterialPageRoute(
        builder: (context) => const AppIconDemo(),
        settings: settings,
      );
    case AppRoutes.videoAnalysis:
      return MaterialPageRoute(
        builder: (context) => const VideoAnalysisPage(),
        settings: settings,
      );
    default:
      // If route is not defined, redirect to main screen
      return MaterialPageRoute(builder: (context) => const MainScreen());
  }
}
