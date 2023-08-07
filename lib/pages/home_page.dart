import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:save_phone/utils/extensions/build_context_ext.dart';
import 'package:save_phone/widgets/liquid_button.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({required this.title, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _player = AudioPlayer();

  final alarmSound = AudioSource.uri(
    Uri.parse("asset:///assets/audio/alarm2.mp3"),
    tag: MediaItem(
      id: '0',
      album: "Public Domain",
      title: "Alarm",
      artUri: Uri.parse(
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
    ),
  );

  void _playAlarm() async => _player.play();

  Future<void> _initAudioPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    await _player.setLoopMode(LoopMode.one);

    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      debugPrint('A stream error occurred: $e');
    });

    try {
      await _player.setAudioSource(
        alarmSound,
        initialPosition: const Duration(seconds: 0),
        preload: true,
      );
    } catch (e, stackTrace) {
      debugPrint("Error: $e");
      debugPrint(stackTrace as String);
    }
  }

  @override
  void initState() {
    super.initState();

    _initAudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LiquidButtonNotifier.isOn,
      builder: (context, isButtonOn, child) {
        if (isButtonOn) {
          _playAlarm();
        } else {
          _player.stop();
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.colorScheme.inversePrimary,
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
            ),
          ),
        );
      },
    );
  }
}
