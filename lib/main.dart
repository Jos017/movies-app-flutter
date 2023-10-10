import 'package:flutter/material.dart';
import 'package:movies_app_flutter/screens/screens.dart';
import 'package:movies_app_flutter/themes/main_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Finder',
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'details': (_) => const DetailsScreen(),
      },
      theme: MainTheme.light,
    );
  }
}
