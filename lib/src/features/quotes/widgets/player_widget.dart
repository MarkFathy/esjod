import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

class PlayerWidget extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const PlayerWidget({super.key, required this.audioPlayer});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: widget.audioPlayer.playerStateStream,
      builder: (context, playerStateSnap) {
        final playerState = playerStateSnap.data;
        final processingState = playerState?.processingState;
        final isPlaying = playerState?.playing ?? false;
        
        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<SequenceState?>(
                    stream: widget.audioPlayer.sequenceStateStream,
                    builder: (context, currentSnap) {
                      final currentItem = currentSnap.data?.currentSource?.tag as MediaItem?;
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                                child: currentItem != null
                                    ? Text(
                                        "${currentItem.title} ${currentItem.album ?? ''}",
                                      )
                                    : const Text('-')),
                            StreamBuilder<Duration>(
                                stream: widget.audioPlayer.positionStream,
                                builder: (context, positionSnap) {
                                  Duration duration = positionSnap.data ?? Duration.zero;
                                  Duration totalDuration = currentSnap.data?.currentSource?.duration ?? widget.audioPlayer.duration ?? Duration.zero;
                                  return DefaultTextStyle(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontFamily: ""),
                                    child: Row(
                                      children: [
                                        Text(duration.toString().split(".").first),
                                        const Text(" / "),
                                        Text(totalDuration.toString().split(".").first)
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                      );
                    }),
                StreamBuilder<LoopMode>(
                  stream: widget.audioPlayer.loopModeStream,
                  builder: (context, loopSnap) {
                    final loopMode = loopSnap.data ?? LoopMode.off;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.teal,
                          onPressed: loopMode == LoopMode.one || !widget.audioPlayer.hasPrevious
                              ? null
                              : () async {
                                  await widget.audioPlayer.seekToPrevious();
                                },
                        ),
                        IconButton(
                          icon: isPlaying
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow),
                          color: Colors.teal,
                          onPressed: () async {
                            if (isPlaying) {
                              await widget.audioPlayer.pause();
                            } else {
                              await widget.audioPlayer.play();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                          color: Colors.teal,
                          onPressed: loopMode == LoopMode.one || !widget.audioPlayer.hasNext
                              ? null
                              : () async {
                                  await widget.audioPlayer.seekToNext();
                                },
                        ),
                        IconButton(
                          icon: const Icon(Icons.stop_circle_outlined),
                          color: processingState == ProcessingState.idle || processingState == null
                              ? Colors.grey
                              : Colors.red,
                          onPressed: () async {
                            await widget.audioPlayer.stop();
                          },
                        )
                      ],
                    );
                  }
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
