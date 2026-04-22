import 'package:just_audio/just_audio.dart';

class AudioP {
  static final AudioP _instance = AudioP._internal();
  factory AudioP() => _instance;
  AudioP._internal();

  static final AudioPlayer _player = AudioPlayer();
  static AudioPlayer get player => _player;

  
  static Future<void> reset() async {
    await _player.stop();
    await _player.seek(Duration.zero);
    
  }
}