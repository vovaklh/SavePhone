import 'package:flutter/material.dart';
import 'package:save_phone/pages/home_page.dart';

class SavePhoneApp extends StatelessWidget {
  const SavePhoneApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save Phone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Save Phone'),
    );
  }
}
