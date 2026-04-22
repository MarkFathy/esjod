import 'package:just_audio/just_audio.dart';

Future launchSystemAlertWindowsDialog() async {
  final AudioPlayer audioP = AudioPlayer();
  await audioP.setAsset('assets/saly.mp3');
  audioP.play();
}
