import 'package:flutter/material.dart';
import 'modules/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TumbuhSehatApp());
}

class TumbuhSehatApp extends StatelessWidget {
  const TumbuhSehatApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF10B981); // Emerald Green
    const backgroundColor = Color(0xFFF8FAFC); // Light Surface
    const surfaceColor = Colors.white; // White for Cards
    const textColor = Color(0xFF0F172A); // Dark text

    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD1FAE5),
      onPrimaryContainer: Color(0xFF065F46),
      secondary: Color(0xFF38BDF8),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFE0F2FE),
      onSecondaryContainer: Color(0xFF0284C7),
      tertiary: Color(0xFF8B5CF6),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFEDE9FE),
      onTertiaryContainer: Color(0xFF6D28D9),
      error: Color(0xFFEF4444),
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF7F1D1D),
      surface: surfaceColor,
      onSurface: textColor,
      surfaceContainerHighest: Color(0xFFF1F5F9),
      onSurfaceVariant: Color(0xFF64748B),
      outline: Color(0xFFCBD5E1),
      outlineVariant: Color(0xFFE2E8F0),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: textColor,
      onInverseSurface: backgroundColor,
      inversePrimary: Color(0xFF34D399),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tumbuh Sehat',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Duolingo',
        colorScheme: colorScheme,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: const TextTheme(
          displayLarge:   TextStyle(color: textColor, fontFamily: 'Duolingo'),
          displayMedium:  TextStyle(color: textColor, fontFamily: 'Duolingo'),
          displaySmall:   TextStyle(color: textColor, fontFamily: 'Duolingo'),
          headlineLarge:  TextStyle(color: textColor, fontFamily: 'Duolingo'),
          headlineMedium: TextStyle(color: textColor, fontFamily: 'Duolingo'),
          headlineSmall:  TextStyle(color: textColor, fontFamily: 'Duolingo'),
          titleLarge:     TextStyle(color: textColor, fontFamily: 'Duolingo'),
          titleMedium:    TextStyle(color: textColor, fontFamily: 'Duolingo'),
          titleSmall:     TextStyle(color: textColor, fontFamily: 'Duolingo'),
          bodyLarge:      TextStyle(color: textColor, fontFamily: 'Duolingo'),
          bodyMedium:     TextStyle(color: textColor, fontFamily: 'Duolingo'),
          bodySmall:      TextStyle(color: Color(0xFF64748B), fontFamily: 'Duolingo'), // Slate 500
          labelLarge:     TextStyle(color: textColor, fontFamily: 'Duolingo'),
          labelMedium:    TextStyle(color: textColor, fontFamily: 'Duolingo'),
          labelSmall:     TextStyle(color: Color(0xFF64748B), fontFamily: 'Duolingo'),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Duolingo',
          ),
          iconTheme: IconThemeData(color: textColor),
          actionsIconTheme: IconThemeData(color: textColor),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          unselectedItemColor: Color(0xFF64748B),
          backgroundColor: surfaceColor,
          selectedLabelStyle: TextStyle(fontFamily: 'Duolingo', fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontFamily: 'Duolingo'),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surfaceColor,
          indicatorColor: primaryColor.withAlpha(50),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: primaryColor);
            }
            return const IconThemeData(color: Color(0xFF64748B));
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Duolingo');
            }
            return const TextStyle(color: Color(0xFF64748B), fontFamily: 'Duolingo');
          }),
        ),
        iconTheme: const IconThemeData(color: textColor),
        primaryIconTheme: const IconThemeData(color: primaryColor),
        listTileTheme: const ListTileThemeData(
          textColor: textColor,
          iconColor: textColor,
          tileColor: surfaceColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
          hintStyle: const TextStyle(color: Color(0xFF64748B)),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryColor;
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(backgroundColor),
          side: const BorderSide(color: Color(0xFF475569), width: 2),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryColor;
            return const Color(0xFF64748B);
          }),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return const Color(0xFF94A3B8);
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryColor;
            }
            return const Color(0xFFE2E8F0);
          }),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontFamily: 'Duolingo', fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: primaryColor.withAlpha(100),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primaryColor),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor,
            side: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
        ),
        cardTheme: CardThemeData(
          color: surfaceColor,
          elevation: 8,
          shadowColor: Colors.black.withAlpha(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFF1F5F9), width: 1),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: surfaceColor,
          selectedColor: primaryColor.withAlpha(50),
          labelStyle: const TextStyle(color: textColor, fontFamily: 'Duolingo'),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE2E8F0),
          thickness: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF1E293B),
          contentTextStyle: const TextStyle(color: Colors.white, fontFamily: 'Duolingo'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}