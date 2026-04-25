import 'package:flutter/material.dart';
import 'modules/navigation/main_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TumbuhSehatApp());
}

class TumbuhSehatApp extends StatelessWidget {
  const TumbuhSehatApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF10B981);

    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD1FAE5),
      onPrimaryContainer: Colors.black,
      secondary: Color(0xFF64748B),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFF1F5F9),
      onSecondaryContainer: Colors.black,
      tertiary: Color(0xFF475569),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFE2E8F0),
      onTertiaryContainer: Colors.black,
      error: Color(0xFFDC2626),
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF7F1D1D),
      surface: Color(0xFFF8FAFC),
      onSurface: Colors.black,
      surfaceContainerHighest: Color(0xFFF1F5F9),
      onSurfaceVariant: Color(0xFF334155),
      outline: Color(0xFFCBD5E1),
      outlineVariant: Color(0xFFE2E8F0),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFF0F172A),
      onInverseSurface: Colors.white,
      inversePrimary: Color(0xFF34D399),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tumbuh Sehat',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Duolingo',
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        textTheme: const TextTheme(
          displayLarge:   TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          displayMedium:  TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          displaySmall:   TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          headlineLarge:  TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          headlineMedium: TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          headlineSmall:  TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          titleLarge:     TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          titleMedium:    TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          titleSmall:     TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          bodyLarge:      TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          bodyMedium:     TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          bodySmall:      TextStyle(color: Color(0xFF64748B), fontFamily: 'Duolingo'),
          labelLarge:     TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          labelMedium:    TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          labelSmall:     TextStyle(color: Color(0xFF64748B), fontFamily: 'Duolingo'),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Duolingo',
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          unselectedItemColor: Color(0xFF94A3B8),
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(fontFamily: 'Duolingo', fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontFamily: 'Duolingo'),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFD1FAE5),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: primaryColor);
            }
            return const IconThemeData(color: Color(0xFF94A3B8));
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Duolingo');
            }
            return const TextStyle(color: Color(0xFF94A3B8), fontFamily: 'Duolingo');
          }),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        primaryIconTheme: const IconThemeData(color: primaryColor),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.black,
          iconColor: Colors.black,
          tileColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF64748B)),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryColor;
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryColor;
            return const Color(0xFF94A3B8);
          }),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryColor;
            return Colors.white;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryColor.withValues(alpha: 0.5);
            }
            return const Color(0xFFCBD5E1);
          }),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontFamily: 'Duolingo', fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.black),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFF1F5F9)),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFF1F5F9),
          selectedColor: const Color(0xFFD1FAE5),
          labelStyle: const TextStyle(color: Colors.black, fontFamily: 'Duolingo'),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFF1F5F9),
          thickness: 1,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}