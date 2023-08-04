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

  void _playAlarm() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    try {
      await _player.setAudioSource(
        ClippingAudioSource(
          start: const Duration(seconds: 60),
          end: const Duration(seconds: 90),
          child: AudioSource.uri(Uri.parse(
              "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
          tag: MediaItem(
            id: '0',
            album: "Science Friday",
            title: "A Salute To Head-Scratching Science (30 seconds)",
            artUri: Uri.parse(
                "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
          ),
        ),
      );
    } catch (e) {
      print("Error loading audio source: $e");
    }
    _player.play();
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
