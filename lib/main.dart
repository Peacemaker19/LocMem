import 'package:flutter/material.dart';
import 'package:native_function/pages/splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
      child: MaterialApp(
    home: const MyApp(),
    theme: ThemeData(
      colorScheme: const ColorScheme.dark(),
      primaryColor: Colors.blueAccent,
      textTheme: const TextTheme(displayLarge: TextStyle(fontSize: 25)),
    ),
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    
    return SplashScreen();
  }
}
