import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/helper_functions/on_generate_routes.dart';

// Data
import 'data/datasources/mock_emotion_datasource.dart';
import 'data/datasources/mock_session_datasource.dart';
import 'data/repositories/emotion_repository_impl.dart';
import 'data/repositories/session_repository_impl.dart';

// Domain
import 'domain/usecases/detect_emotions_usecase.dart';
import 'domain/usecases/get_sessions_usecase.dart';

// Presentation
import 'presentation/providers/emotion_provider.dart';
import 'presentation/providers/session_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/video_analysis_page.dart';
import 'presentation/pages/app_icon_demo.dart';
import 'presentation/controllers/navigation_controller.dart';

// Screens
import 'screens/record_page.dart';
import 'screens/video_page.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Data sources
        Provider(create: (_) => MockEmotionDataSource()),
        Provider(create: (_) => MockSessionDataSource()),

        // Repositories
        Provider(
          create:
              (context) =>
                  EmotionRepositoryImpl(context.read<MockEmotionDataSource>()),
        ),
        Provider(
          create:
              (context) =>
                  SessionRepositoryImpl(context.read<MockSessionDataSource>()),
        ),

        // Use cases
        Provider(
          create:
              (context) =>
                  DetectEmotionsUseCase(context.read<EmotionRepositoryImpl>()),
        ),
        Provider(
          create:
              (context) =>
                  GetSessionsUseCase(context.read<SessionRepositoryImpl>()),
        ),

        // Providers
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create:
              (context) =>
                  EmotionProvider(context.read<DetectEmotionsUseCase>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => SessionProvider(context.read<GetSessionsUseCase>()),
        ),
        ChangeNotifierProvider(create: (context) => NavigationController()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'EmoSense AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.main,
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}
