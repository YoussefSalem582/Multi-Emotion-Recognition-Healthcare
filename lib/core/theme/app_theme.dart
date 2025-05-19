import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final ColorScheme lightColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    ).copyWith(
      secondary: const Color(0xFF03DAC6),
      tertiary: const Color(0xFFEF5350),
      // Custom colors with better contrast
      surfaceVariant: const Color(0xFFE7E0EC),
      primaryContainer: const Color(0xFFEADDFF),
      secondaryContainer: const Color(0xFFCEF6EC),
      // Improved text contrast
      onSurfaceVariant: const Color(0xFF49454F),
      onBackground: const Color(0xFF1C1B1F),
      onSurface: const Color(0xFF1C1B1F),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 2,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF6750A4),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6750A4),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: const Color(0xFF6750A4),
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: const Color(0xFF6750A4),
        unselectedLabelColor: Colors.grey.shade600,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 3, color: Color(0xFF6750A4)),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final ColorScheme darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFD0BCFF),
      brightness: Brightness.dark,
    ).copyWith(
      secondary: const Color(0xFF03DAC6),
      tertiary: const Color(0xFFEF5350),
      // Enhanced dark mode colors
      surface: const Color(0xFF1C1B1F),
      background: const Color(0xFF121212),
      primaryContainer: const Color(0xFF4F378B),
      secondaryContainer: const Color(0xFF064B40),
      surfaceVariant: const Color(0xFF49454F),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      fontFamily: 'Roboto',
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFF1C1B1F),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFFD0BCFF);
          }
          return Colors.grey.shade400;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF4F378B);
          }
          return Colors.grey.shade800;
        }),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade900,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD0BCFF), width: 2),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 2,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFD0BCFF),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD0BCFF),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: const Color(0xFFD0BCFF),
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: const Color(0xFF1C1B1F),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFFD0BCFF),
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: const Color(0xFFD0BCFF),
        unselectedLabelColor: Colors.grey.shade500,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 3, color: Color(0xFFD0BCFF)),
        ),
      ),
    );
  }
}
