import 'package:creta03/data_io/contents_manager.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ControlButtons extends StatefulWidget {
  final ContentsManager contentsManager;
  final ConcatenatingAudioSource playlist;
  final void Function() passOnPressed;
  final bool toggleValue;
  final double scaleVal;

  const ControlButtons({
    super.key,
    required this.audioPlayer,
    required this.contentsManager,
    required this.playlist,
    required this.passOnPressed,
    required this.toggleValue,
    required this.scaleVal,
  });

  final AudioPlayer audioPlayer;

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  String findPrevousTag() {
    int index = 0;
    String currentMid = widget.contentsManager.getSelectedMid();
    for (var ele in widget.playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
        if (source.tag.id.toString() == currentMid) {
          if (index == 0) {
            AudioSource src = widget.playlist.children[widget.playlist.length - 1];
            if (src is ProgressiveAudioSource) {
              return src.tag.id.toString();
            }
          }
          AudioSource src = widget.playlist.children[index - 1];
          if (src is ProgressiveAudioSource) {
            return src.tag.id.toString();
          }
        }
        index++;
      }
    }
    return '';
  }

  void prevMusic() {
    widget.audioPlayer.seekToPrevious();
    String prevTargetMid = findPrevousTag();
    if (prevTargetMid.isNotEmpty) {
      widget.contentsManager.setSelectedMid(prevTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
  }

  String findNextTag() {
    int index = 0;
    String currentMid = widget.contentsManager.getSelectedMid();
    for (var ele in widget.playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
        if (source.tag.id.toString() == currentMid) {
          if (index == widget.playlist.length) {
            AudioSource src = widget.playlist.children[0];
            if (src is ProgressiveAudioSource) {
              return src.tag.id.toString();
            }
          }
          AudioSource src = widget.playlist.children[index + 1];
          if (src is ProgressiveAudioSource) {
            return src.tag.id.toString();
          }
        }
        index++;
      }
    }
    return '';
  }

  void nextMusic() {
    widget.audioPlayer.seekToNext();
    String nextTargetMid = findNextTag();
    if (nextTargetMid.isNotEmpty) {
      widget.contentsManager.setSelectedMid(nextTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
  }

  void fromBeginning() {
    widget.audioPlayer.seek(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = 51.0 * widget.scaleVal;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Opens volumn slider dialog
        Flexible(
          child: StreamBuilder<double>(
            stream: widget.audioPlayer.volumeStream,
            builder: ((context, snapshot) {
              double volumeValue = snapshot.data ?? 0.0;
              var icons = [
                Icon(Icons.volume_off, size: iconSize / 2.0),
                Icon(Icons.volume_down, size: iconSize / 2.0),
                Icon(Icons.volume_up, size: iconSize / 2.0),
              ];
              int index = 0;
              if (volumeValue > 0.0 && volumeValue <= 0.5) {
                index = 1;
              } else if (volumeValue > 0.5) {
                index = 2;
              }

              return MusicControlBtn(
                iconSize: iconSize,
                child: IconButton(
                  icon: icons[index],
                  onPressed: () {
                    setState(() {
                      if (volumeValue > 0) {
                        widget.audioPlayer.setVolume(0.0);
                      } else {
                        widget.audioPlayer.setVolume(0.5);
                      }
                    });
                    // showSliderDialog(
                    //   context: context,
                    //   title: "볼륨 조절",
                    //   divisions: 10,
                    //   min: 0.0,
                    //   max: 1.0,
                    //   stream: widget.audioPlayer.volumeStream,
                    //   onChanged: (value) {
                    //     widget.audioPlayer.setVolume(value);
                    //     widget.contentsManager.frameModel.volume.set(value * 100);
                    //     if (value > 0) {
                    //       widget.contentsManager.frameModel.mute.set(false);
                    //     }
                    //   },
                    // );
                  },
                ),
              );
            }),
          ),
        ),
        Flexible(
          child: StreamBuilder<SequenceState?>(
            stream: widget.audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              return MusicControlBtn(
                iconSize: iconSize,
                child: IconButton(
                  icon: Icon(Icons.skip_previous, size: iconSize / 2.0),
                  onPressed: widget.audioPlayer.hasPrevious ? prevMusic : fromBeginning,
                ),
              );
            },
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playState = snapshot.data;
            final processingState = playState?.processingState;
            final playing = playState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0 * widget.scaleVal),
                width: iconSize,
                height: iconSize,
                child: const CircularProgressIndicator(),
              );
            } else if (!(playing ?? false)) {
              return MusicControlBtn(
                iconSize: iconSize,
                child: IconButton(
                  onPressed: () {
                    widget.audioPlayer.play();
                    widget.passOnPressed();
                  },
                  iconSize: iconSize,
                  color: Colors.black87,
                  icon: const Icon(Icons.play_arrow_rounded),
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return MusicControlBtn(
                iconSize: iconSize,
                child: IconButton(
                  onPressed: () {
                    widget.audioPlayer.pause();
                    widget.passOnPressed();
                  },
                  iconSize: iconSize,
                  color: Colors.black87,
                  icon: const Icon(Icons.pause_rounded),
                ),
              );
            }
            return MusicControlBtn(
              iconSize: iconSize,
              child: Icon(
                Icons.play_arrow_rounded,
                size: iconSize,
                color: Colors.black87,
              ),
            );
          },
        ),
        Flexible(
          child: StreamBuilder<SequenceState?>(
            stream: widget.audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              return MusicControlBtn(
                iconSize: iconSize,
                child: IconButton(
                  icon: Icon(Icons.skip_next, size: iconSize / 2.0),
                  onPressed: widget.audioPlayer.hasNext ? nextMusic : fromBeginning,
                ),
              );
            },
          ),
        ),
        Flexible(
          child: StreamBuilder<LoopMode>(
            stream: widget.audioPlayer.loopModeStream,
            builder: (context, snapshot) {
              final loopMode = snapshot.data ?? LoopMode.all;
              var icons = [
                Icon(Icons.repeat,
                    color: Colors.black87.withOpacity(0.5), size: 24.0 * widget.scaleVal),
                Icon(Icons.repeat, color: CretaColor.secondary, size: 24.0 * widget.scaleVal),
                Icon(Icons.repeat_one, color: CretaColor.secondary, size: 24.0 * widget.scaleVal),
              ];
              List<LoopMode> cycleModes = [
                LoopMode.all,
                LoopMode.one,
              ];
              final index = cycleModes.indexOf(loopMode);
              return MusicControlBtn(
                iconSize: iconSize,
                child: IconButton(
                  icon: icons[index],
                  onPressed: () {
                    widget.audioPlayer.setLoopMode(
                        cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
                  },
                ),
              );
            },
          ),
        ),
        // Flexible(
        //   child: StreamBuilder<double>(
        //     stream: audioPlayer.speedStream,
        //     builder: (context, snapshot) {
        //       // double speedValue = snapshot.data ?? 1.000;
        //       return IconButton(
        //         icon: Icon(Icons.speed, size: iconSize / 2.0),
        //         // style: const TextStyle(fontWeight: FontWeight.bold)),
        //         onPressed: () {
        //           showSliderDialog(
        //             context: context,
        //             title: "재생 속도",
        //             divisions: 4,
        //             min: 0.5,
        //             max: 1.5,
        //             valueSuffix: 'x',
        //             stream: audioPlayer.speedStream,
        //             onChanged: audioPlayer.setSpeed,
        //           );
        //         },
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class MusicControlBtn extends StatefulWidget {
  final Widget child;
  final double iconSize;

  const MusicControlBtn({
    super.key,
    required this.child,
    required this.iconSize,
  });

  @override
  State<MusicControlBtn> createState() => _MusicControlBtnState();
}

class _MusicControlBtnState extends State<MusicControlBtn> {
  bool _ishover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (value) {
        setState(() {
          _ishover = false;
        });
      },
      onEnter: (value) {
        setState(() {
          _ishover = true;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: widget.iconSize + 2.0,
            height: widget.iconSize + 2.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _ishover ? CretaColor.text.shade200 : Colors.transparent,
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
