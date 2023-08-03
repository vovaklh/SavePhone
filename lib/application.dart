import 'package:flutter/material.dart';
import 'package:save_phone/pages/home_page.dart';

class SavePhoneApp extends StatelessWidget {
  const SavePhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save Phone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 16, 64, 104),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Save Phone'),
    );
  }
}
