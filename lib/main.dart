import 'core/core.dart';

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
