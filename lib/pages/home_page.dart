import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:save_phone/utils/extensions/build_context_ext.dart';
import 'package:save_phone/widgets/liquid_button.dart';

import '../logic/audio_player_settings.dart';
import '../logic/sensor_monitor.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({required this.title, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SensorMonitor _sensorMonitor = SensorMonitor();
  final AudioPlayer _player = AudioPlayer();

  void _isButtonTapped(bool isButtonOn) {
    if (isButtonOn) {
      _sensorMonitor.startMonitoring();
    } else {
      _player.pause();
      _sensorMonitor.stopMinitoring();
    }
  }

  @override
  void initState() {
    super.initState();

    _onStart();
  }

  void _onStart() async {
    final AudioPlayerSettings audioPlayerSettings =
        AudioPlayerSettings(_player);
    await audioPlayerSettings.initAudioPlayer();
    _sensorMonitor.addListener(_player.play);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ValueListenableBuilder(
          valueListenable: LiquidButtonNotifier.isOn,
          builder: (context, isButtonOn, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LiquidButton(
                  onTapped: _isButtonTapped,
                ),
                const SizedBox(height: 60),
                Text(
                  'Signalization is turned ${isButtonOn ? 'ON' : 'OFF'}',
                  style: context.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                isButtonOn
                    ? Text(
                        "Your phone is safe. You'll hear an alarm if it's moved",
                        style: context.textTheme.bodyMedium,
                      )
                    : Text(
                        'Tap to prevent theft',
                        style: context.textTheme.bodyMedium,
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
