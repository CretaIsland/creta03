import 'package:creta03/data_io/contents_manager.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:just_audio/just_audio.dart';

import 'package:creta_common/common/creta_snippet.dart';
import '../../studio_constant.dart';

class ControlButtons extends StatefulWidget {
  final GlobalObjectKey<MusicControlBtnState>? volumeButtonKey;
  final ContentsManager contentsManager;
  final ConcatenatingAudioSource playlist;
  final void Function() passOnPressed;
  final Function? onHoverChanged;
  final bool toggleValue;
  final double scaleVal;
  final AudioPlayer audioPlayer;
  // final bool isSmallSize;

  const ControlButtons({
    super.key,
    required this.audioPlayer,
    required this.contentsManager,
    required this.playlist,
    required this.passOnPressed,
    this.onHoverChanged,
    required this.toggleValue,
    required this.scaleVal,
    this.volumeButtonKey,
    // this.isSmallSize = false,
  });

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  bool isShowVolume = false;

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
          if (index == widget.playlist.length - 1) {
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
    bool isSmallOrTiny = widget.contentsManager.frameModel.isMusicSmallOrTiny();
    final iconSize = isSmallOrTiny ? 24.0 : StudioConst.musicIconSize * widget.scaleVal;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isSmallOrTiny) _loopButton(iconSize),
        Expanded(child: _skipPrevious(iconSize)),
        Expanded(child: _playPauseButton(iconSize)),
        Expanded(child: _skipNext(iconSize)),
        if (!isSmallOrTiny) _volumeButton(iconSize),
      ],
    );
  }

  Widget _loopButton(double iconSize) {
    return StreamBuilder<LoopMode>(
      stream: widget.audioPlayer.loopModeStream,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.all;

        var icons = [
          // Icon(Icons.repeat,
          //     color: Colors.black87.withOpacity(0.5), size: 24.0 * widget.scaleVal),
          Icon(Icons.repeat, color: Colors.black87, size: 24.0 * widget.scaleVal),
          Icon(Icons.repeat_one, color: Colors.black87, size: 24.0 * widget.scaleVal),
        ];
        const cycleModes = [
          // LoopMode.off,
          LoopMode.all,
          LoopMode.one,
        ];
        int index = cycleModes.indexOf(loopMode);
        if (index < 0) index = 0;
        return MusicControlBtn(
          iconSize: iconSize,
          child: IconButton(
            icon: icons[index],
            onPressed: () {
              widget.audioPlayer
                  .setLoopMode(cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
            },
          ),
        );
      },
    );
  }

  Widget _skipPrevious(double iconSize) {
    return StreamBuilder<SequenceState?>(
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
    );
  }

  Widget _playPauseButton(double iconSize) {
    return StreamBuilder<PlayerState>(
      stream: widget.audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playState = snapshot.data;
        final processingState = playState?.processingState;
        final playing = playState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: EdgeInsets.all(6.0 * widget.scaleVal),
            width: iconSize,
            height: iconSize,
            child: CretaSnippet.showWaitSign(),
          );
        } else if (!(playing ?? false)) {
          return MusicControlBtn(
            iconSize: iconSize,
            child: InkWell(
              onTap: () {
                widget.audioPlayer.play();
                widget.passOnPressed();
              },
              child: Icon(
                Icons.play_arrow_rounded,
                size: iconSize,
                color: Colors.black87,
              ),
            ),
            // child: IconButton(
            //   onPressed: () {
            //     widget.audioPlayer.play();
            //     widget.passOnPressed();
            //   },
            //   iconSize: iconSize,
            //   color: Colors.black87,
            //   icon: const Icon(Icons.play_arrow_rounded),
            // ),
          );
        } else if (processingState != ProcessingState.completed) {
          return MusicControlBtn(
            iconSize: iconSize,
            value: null,
            onChanged: null,
            child: InkWell(
              onTap: () {
                widget.audioPlayer.pause();
                widget.passOnPressed();
              },
              child: Icon(
                Icons.pause_rounded,
                size: iconSize,
                color: Colors.black87,
              ),
            ),
            // child: IconButton(
            //   onPressed: () {
            //     widget.audioPlayer.pause();
            //     widget.passOnPressed();
            //   },
            //   iconSize: iconSize,
            //   color: Colors.black87,
            //   icon: const Icon(Icons.pause_rounded),
            // ),
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
    );
  }

  Widget _skipNext(double iconSize) {
    return StreamBuilder<SequenceState?>(
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
    );
  }

  Widget _volumeButton(double iconSize) {
    return StreamBuilder<double>(
      stream: widget.audioPlayer.volumeStream,
      builder: (context, snapshot) {
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
          key: widget.volumeButtonKey,
          audioPlayer: widget.audioPlayer,
          frameId: widget.contentsManager.frameModel.mid,
          isShowVolume: false,
          iconSize: iconSize,
          value: null, //snapshot.data ?? 0.0,
          onHoverChanged: widget.onHoverChanged,
          onChanged: (value) {
            widget.audioPlayer.setVolume(value);
            widget.contentsManager.frameModel.volume.set(value * 100);
            if (value > 0) {
              widget.contentsManager.frameModel.mute.set(false);
            }
          },
          child: IconButton(
            icon: icons[index],
            onPressed: () {
              setState(
                () {
                  if (volumeValue > 0) {
                    widget.audioPlayer.setVolume(0.0);
                  } else {
                    widget.audioPlayer
                        .setVolume(widget.contentsManager.frameModel.volume.value / 100);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class MusicControlBtn extends StatefulWidget {
  final Widget child;
  final double iconSize;
  final AudioPlayer? audioPlayer;
  bool isShowVolume;
  final double? value;
  final ValueChanged<double>? onChanged;
  final Function? onHoverChanged;
  final String? frameId;
  final double? sliderHeight;
  final double? sliderWidth;
  final double? spaceY;

  MusicControlBtn({
    super.key,
    this.value,
    this.onChanged,
    this.onHoverChanged,
    this.isShowVolume = false,
    required this.child,
    required this.iconSize,
    this.audioPlayer,
    this.frameId,
    this.sliderHeight,
    this.sliderWidth,
    this.spaceY,
  });

  @override
  State<MusicControlBtn> createState() => MusicControlBtnState();
}

class MusicControlBtnState extends State<MusicControlBtn> {
  bool _ishover = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (value) {
        setState(() {
          _ishover = false;
          if (widget.audioPlayer != null) widget.audioPlayer!.isVolumeHover = _ishover;
          widget.onHoverChanged?.call();
        });
      },
      onEnter: (value) {
        setState(() {
          _ishover = true;
          if (widget.audioPlayer != null) {
            widget.audioPlayer!.isVolumeHover = _ishover;
          } else {
            logger.fine('audioPlayer is null');
          }
          widget.onHoverChanged?.call();
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
          if (widget.isShowVolume && widget.value != null)
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: CretaColor.text.shade200,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  height: widget.sliderHeight,
                  width: widget.sliderWidth,
                  child: SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 0.5,
                      activeTrackColor: CretaColor.primary,
                      inactiveTrackColor: Colors.grey,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: RotatedBox(
                      quarterTurns: 3, // rotate 90deg
                      child: Slider(
                          min: 0,
                          max: 1,
                          value: widget.value!,
                          onChanged: widget.onChanged! // Reverse the value back
                          ),
                    ),
                  ),
                ),
                SizedBox(height: widget.spaceY),
              ],
            ),
        ],
      ),
    );
  }
}
