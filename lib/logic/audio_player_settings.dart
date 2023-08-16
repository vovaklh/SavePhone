import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioPlayerSettings {
  static const String _alarmSoundPath = "assets/audio/alarm.wav";

  final AudioPlayer player;

  AudioPlayerSettings(this.player);

  Future<void> initAudioPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    await player.setLoopMode(LoopMode.one);

    try {
      await player.setAudioSource(
        AudioSource.asset(
          _alarmSoundPath,
          tag: const MediaItem(id: '0', title: "Alarm"),
        ),
        initialPosition: const Duration(seconds: 0),
        preload: true,
      );
    } catch (e) {
      log("Error: $e");
    }
  }
}
