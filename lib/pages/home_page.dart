import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_phone/widgets/liquid_button.dart';

import '../providers/liquid_button_provider.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({required this.title, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider(
      create: (context) => LiquidButtonProvider(),
      child: Consumer<LiquidButtonProvider>(
        builder: (context, buttonState, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: colorScheme.inversePrimary,
              centerTitle: true,
              title: Text(widget.title),
            ),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LiquidButton(),
                  const SizedBox(height: 60),
                  Text(
                    'Signalization is turned ${buttonState.isOn ? 'ON' : 'OFF'}',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  buttonState.isOn
                      ? Text(
                          "Your phone is safe. You'll hear an alarm if it's moved",
                          style: textTheme.bodyMedium,
                        )
                      : Text(
                          'Tap to prevent theft',
                          style: textTheme.bodyMedium,
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
