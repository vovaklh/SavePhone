import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:save_phone/utils/extensions/build_context_ext.dart';
import 'package:save_phone/widgets/liquid_button.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({required this.title, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AudioPlayerSettings _audioPlayerSettings;
  late final SensorMonitor _sensorMonitor;

  final AudioPlayer _player = AudioPlayer();

  bool _isMovementSuspicious = false;

  @override
  void initState() {
    super.initState();

    _audioPlayerSettings = AudioPlayerSettings(_player);
    _audioPlayerSettings.initAudioPlayer();

    _sensorMonitor = SensorMonitor((isSuspicious) {
      setState(() => _isMovementSuspicious = isSuspicious);
    });
    _sensorMonitor.startMonitoring();
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
            if (_isMovementSuspicious && isButtonOn) {
              _player.play();
            } else if (!isButtonOn) {
              _player.pause();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LiquidButton(),
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

class AudioPlayerSettings {
  static const String alarmSoundPath = "assets/audio/alarm.wav";

  final AudioPlayer player;

  AudioPlayerSettings(this.player);

  Future<void> initAudioPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    await player.setLoopMode(LoopMode.one);

    try {
      await player.setAudioSource(
        AudioSource.asset(
          alarmSoundPath,
          tag: const MediaItem(id: '0', title: "Alarm"),
        ),
        initialPosition: const Duration(seconds: 0),
        preload: true,
      );
    } catch (e, stackTrace) {
      debugPrint("Error: $e");
      debugPrint(stackTrace as String);
    }
  }
}

class SensorMonitor {
  final Function(bool) onSuspiciousMovement;

  SensorMonitor(this.onSuspiciousMovement);

  void startMonitoring() {
    const double movementThreshold = 13.0;
    const int numberOfSamples = 15;

    List<double> accelerometerMagnitudes = [];
    List<double> gyroscopeMagnitudes = [];

    // Initialize Kalman filter parameters
    double estimatedMagnitude = 0.0; // Initial estimate
    double estimatedError = 1.0; // Initial error estimate
    double processNoise = 0.1; // Process noise
    double measurementNoise = 0.5; // Measurement noise

    accelerometerEvents.listen(
      (AccelerometerEvent accelEvent) {
        // Calculate magnitude and apply Kalman filter
        double accelMagnitude =
            accelEvent.x.abs() + accelEvent.y.abs() + accelEvent.z.abs();

        double kalmanGain =
            estimatedError / (estimatedError + measurementNoise);
        estimatedMagnitude = estimatedMagnitude +
            kalmanGain * (accelMagnitude - estimatedMagnitude);
        estimatedError = (1 - kalmanGain) * estimatedError + processNoise;

        debugPrint("Estimated Magnitude: $estimatedMagnitude");
        accelerometerMagnitudes.add(estimatedMagnitude);

        if (accelerometerMagnitudes.length >= numberOfSamples) {
          double avgAccelMagnitude =
              accelerometerMagnitudes.reduce((a, b) => a + b) /
                  accelerometerMagnitudes.length;

          accelerometerMagnitudes.clear();

          gyroscopeEvents.listen(
            (GyroscopeEvent gyroEvent) async {
              double gyroMagnitude =
                  gyroEvent.x.abs() + gyroEvent.y.abs() + gyroEvent.z.abs();
              gyroscopeMagnitudes.add(gyroMagnitude);

              if (gyroscopeMagnitudes.length >= numberOfSamples) {
                double avgGyroMagnitude =
                    gyroscopeMagnitudes.reduce((a, b) => a + b) /
                        gyroscopeMagnitudes.length;
                gyroscopeMagnitudes.clear();

                if (avgAccelMagnitude > movementThreshold ||
                    avgGyroMagnitude > movementThreshold) {
                  return onSuspiciousMovement(true);
                } else if (avgAccelMagnitude < movementThreshold &&
                    avgGyroMagnitude < movementThreshold) {
                  return onSuspiciousMovement(false);
                }
              }
            },
          );
        }
      },
    );
  }
}
