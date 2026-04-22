import 'package:just_audio/just_audio.dart';
import 'package:azkar/src/core/utils/core_theme.dart';
import 'package:flutter/material.dart';

class AyahPlayer extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final void Function() pinning;
  const AyahPlayer(
      {super.key, required this.audioPlayer, required this.pinning});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: StreamBuilder<Duration?>(
          stream: audioPlayer.positionStream,
          builder: (context, positionSnap) {
            return StreamBuilder<Duration?>(
                stream: audioPlayer.durationStream,
                builder: (context, durationSnap) {
                  return StreamBuilder<PlayerState>(
                      stream: audioPlayer.playerStateStream,
                      builder: (context, playerStateSnap) {
                        return StreamBuilder<LoopMode>(
                            stream: audioPlayer.loopModeStream,
                            builder: (context, loopModeSnap) {
                              final position = positionSnap.data ?? Duration.zero;
                              final duration = durationSnap.data ?? Duration.zero;
                              final isPlaying = playerStateSnap.data?.playing ?? false;
                              final loopMode = loopModeSnap.data ?? LoopMode.off;

                              double positionVal = position.inSeconds.toDouble();
                              double durationVal = duration.inSeconds.toDouble();

                              if (positionVal > durationVal) positionVal = durationVal;
                              if (durationVal <= 0.0) durationVal = 1.0; 
                              
                              return Column(
                                children: [
                                  Slider(
                                    value: positionVal,
                                    min: 0,
                                    thumbColor: secondaryColor,
                                    activeColor: secondaryColor,
                                    max: durationVal,
                                    onChanged: (value) {
                                      audioPlayer.seek(Duration(seconds: value.toInt()));
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          audioPlayer.seekToPrevious();
                                        },
                                        icon: const Icon(
                                          Icons.navigate_before,
                                          color: whiteColor,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            if (isPlaying) {
                                              await audioPlayer.pause();
                                            } else {
                                              await audioPlayer.play();
                                            }
                                          },
                                          icon: isPlaying
                                              ? const Icon(
                                                  Icons.pause,
                                                  color: secondaryColor,
                                                )
                                              : const Icon(Icons.play_arrow, color: whiteColor)),
                                      IconButton(
                                        onPressed: () {
                                          audioPlayer.seekToNext();
                                        },
                                        icon: const Icon(Icons.navigate_next, color: whiteColor),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if (loopMode == LoopMode.all) {
                                            await audioPlayer.setLoopMode(LoopMode.one);
                                          } else {
                                            await audioPlayer.setLoopMode(LoopMode.all);
                                          }
                                        },
                                        icon: loopMode == LoopMode.one
                                            ? const Icon(Icons.repeat_one, color: whiteColor)
                                            : const Icon(Icons.repeat, color: whiteColor),
                                      ),
                                      IconButton(
                                        onPressed: pinning,
                                        icon: const Icon(
                                          Icons.bookmark_outlined,
                                          color: whiteColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            });
                      });
                });
          },
        ),
      ),
    );
  }
}
