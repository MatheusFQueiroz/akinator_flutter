import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'theme/brutal.dart';

void main() {
  runApp(const AkinatorApp());
}

class AkinatorApp extends StatelessWidget {
  const AkinatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quem é o Professor?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: BrutalColors.purple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: BrutalColors.bg,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
