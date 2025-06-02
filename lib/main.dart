import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readit/views/home_screen/home_screen.dart';
import 'package:system_theme/system_theme.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SystemThemeBuilder(
      builder: (context, systemAccent) {
        return MaterialApp(
          title: 'Read IT',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: systemAccent.accent,
              brightness: Brightness.light,
            ),
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
            ),
            useSystemColors: true,
            useMaterial3: true,
            visualDensity: VisualDensity.comfortable,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: systemAccent.accent,
              brightness: Brightness.dark,
            ),
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
            ),
            useSystemColors: true,
            useMaterial3: true,
            visualDensity: VisualDensity.comfortable,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
