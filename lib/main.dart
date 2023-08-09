import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:save_phone/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.save_phone',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(const SavePhoneApp());
}
