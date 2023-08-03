import 'package:flutter/material.dart';
import 'package:save_phone/widgets/liquid_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LiquidButton(),
            SizedBox(height: 30),
            Text("Signalization is off"),
          ],
        ),
      ),
    );
  }
}
