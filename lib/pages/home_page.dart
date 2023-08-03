import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_phone/widgets/liquid_button.dart';

import '../providers/liquid_button_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LiquidButtonProvider(),
      child: Consumer<LiquidButtonProvider>(builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            centerTitle: true,
            title: Text(widget.title),
          ),
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LiquidButton(),
                const SizedBox(height: 30),
                Text('Signalization is turned ${provider.isOn ? 'ON' : 'OFF'}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                provider.isOn
                    ? Text("Your phone is safe",
                        style: Theme.of(context).textTheme.bodyMedium)
                    : Text('Tap to turn it on',
                        style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        );
      }),
    );
  }
}
