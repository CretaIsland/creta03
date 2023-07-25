// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/model/contents_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
// import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../player/music/creta_music_mixin.dart';
import 'creta_mini_music_visualizer.dart';
import 'music_common.dart';

class MusicPlayerFrame extends StatefulWidget {
  final ContentsManager contentsManager;
  final ContentsModel? model;
  final Size size;

  const MusicPlayerFrame(
      {super.key, required this.contentsManager, this.model, required this.size});

  void selectedSong(ContentsModel model, int i) {}

  @override
  State<MusicPlayerFrame> createState() => MusicPlayerFrameState();
}

class MusicPlayerFrameState extends State<MusicPlayerFrame> {
  late AudioPlayer _audioPlayer; // play local audio file

  void addMusic(ContentsModel model) async {
    Random random = Random();
    int randomNumber = random.nextInt(100);
    String url = 'https://picsum.photos/200/?random=$randomNumber';

    if (_audioPlayer.playing) {
      _audioPlayer.stop();
    }

    await _playlist.insert(
      0,
      AudioSource.uri(
        Uri.parse(model.remoteUrl!),
        tag: MediaItem(
          id: model.mid,
          title: model.name,
          artist: 'Unknown artist',
          artUri: Uri.parse(url),
        ),
      ),
    );

    _audioPlayer.seek(Duration.zero, index: 0);
    _audioPlayer.play();
  }

  void unhiddenMusic(ContentsModel model, int idx) {
    Random random = Random();
    int randomNumber = random.nextInt(100);
    String url = 'https://picsum.photos/200/?random=$randomNumber';

    _playlist.insert(
      idx,
      AudioSource.uri(
        Uri.parse(model.remoteUrl!),
        tag: MediaItem(
          id: model.mid,
          title: model.name,
          artist: 'Unknown artist',
          artUri: Uri.parse(url),
        ),
      ),
    );
  }

  int findIndex(ContentsModel model) {
    int index = 0;
    for (var ele in _playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
        if (model.remoteUrl == source.uri.toString()) {
          return index;
        }
        index++;
      }
    }
    return -1;
  }

  void removeMusic(ContentsModel model) {
    debugPrint('====RemoveMusic(${model.name})====');
    int index = findIndex(model);
    if (index >= 0) {
      _playlist.removeAt(index);
    }
  }

  void reorderPlaylist(ContentsModel model, int oldIndex, int newIndex) async {
    debugPrint('====Reorder song at #$oldIndex to #$newIndex====');
    await _playlist.move(oldIndex, newIndex);

    if (newIndex == 0) _audioPlayer.seek(Duration.zero, index: newIndex);
    _audioPlayer.play();
  }

  void selectedSong(ContentsModel model, int i) {
    _audioPlayer.seek(Duration.zero, index: i);
  }

  final _playlist = ConcatenatingAudioSource(
    children: [],
    // AudioSource.uri(
    //   Uri.parse("asset:///assets/audio/canone.mp3"),
    //   tag: MediaItem(
    //     id: '01',
    //     title: "Variatio 3 a 1 Clav.Canone all'Unisuono'",
    //     artist: 'Kimiko Ishizaka',
    //     artUri: Uri.parse(
    //         'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
    //   ),
    // ),
  );

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //
      widget.contentsManager.orderMapIterator((ele) {
        if (ele.isRemoved.value == true) return null;

        ContentsModel model = ele as ContentsModel;
        if (model.isShow.value == false) return null;

        if (model.isMusic()) {
          String key = widget.contentsManager.frameModel.mid;
          GlobalObjectKey<MusicPlayerFrameState>? musicKey = musicKeyMap[key];
          if (musicKey != null) {
            musicKey.currentState!.addMusic(model);
          }
        }
        return null;
      });
    });
  }

  @override
  void initState() {
    super.initState;
    _audioPlayer = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
    afterBuild();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _audioPlayer.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      logger.fine('A stream error occurred: $e');
    });
    try {
      await _audioPlayer.setAudioSource(_playlist);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      logger.fine("Error loading playlist: $e");
      logger.fine(stackTrace);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _audioPlayer.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SizedBox(
                      width: 280.0,
                      height: 280.0,
                      child: Image.asset('no_image.png', fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8.0),
                    Text('플레이 리스트에 노래를 추가하세요!', style: Theme.of(context).textTheme.titleLarge),
                  ]);
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 280.0,
                            height: 280.0,
                            child: Image.network(metadata.artUri.toString(), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(metadata.title, style: Theme.of(context).textTheme.titleLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(metadata.artist!),
                          // IconButton(
                          //   icon: const Icon(Icons.remove_circle_outline_sharp),
                          //   iconSize: 24.0,
                          //   onPressed: () {
                          //     final playerState = snapshot.data;
                          //     if (playerState != null) {
                          //       final playerIndex = playerState.currentIndex;
                          //       removeMusic(playerIndex);
                          //     }
                          //   },
                          // ),
                          StreamBuilder<LoopMode>(
                            stream: _audioPlayer.loopModeStream,
                            builder: (context, snapshot) {
                              final loopMode = snapshot.data ?? LoopMode.off;
                              var icons = [
                                Icon(Icons.repeat, color: Colors.black87.withOpacity(0.5)),
                                const Icon(Icons.repeat, color: Colors.black87),
                                const Icon(Icons.repeat_one, color: Colors.black87),
                              ];
                              const cycleModes = [
                                LoopMode.off,
                                LoopMode.all,
                                LoopMode.one,
                              ];
                              final index = cycleModes.indexOf(loopMode);
                              return IconButton(
                                icon: icons[index],
                                onPressed: () {
                                  _audioPlayer.setLoopMode(cycleModes[
                                      (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4.0),
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return ProgressBar(
                barHeight: 4.0,
                baseBarColor: CretaColor.bufferedColor.withOpacity(0.24),
                bufferedBarColor: CretaColor.bufferedColor,
                progressBarColor: Colors.black87,
                thumbColor: Colors.black87,
                timeLabelTextStyle:
                    const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                progress: positionData?.position ?? Duration.zero,
                buffered: positionData?.bufferedPosition ?? Duration.zero,
                total: positionData?.duration ?? Duration.zero,
                onSeek: _audioPlayer.seek,
              );
            },
          ),
          ControlButtons(audioPlayer: _audioPlayer),
          const SizedBox(height: 4.0),
          // _reorderPlaylist(),
          _orderPlaylist(),
        ],
      ),
    );
  }

  Widget _orderPlaylist() {
    return SingleChildScrollView(
      child: SizedBox(
        height: 240.0,
        child: StreamBuilder<SequenceState?>(
          stream: _audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            final sequence = state?.sequence ?? [];
            return ListView.builder(
              itemCount: sequence.length,
              itemBuilder: (BuildContext context, i) {
                return Material(
                  key: ValueKey(sequence[i]),
                  color: i == state!.currentIndex ? CretaColor.bufferedColor : Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: Container(
                    padding: const EdgeInsets.only(left: 24.0),
                    height: 32.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 32.0,
                          child: Text(
                            i < 9 ? '0${i + 1}' : '${i + 1}',
                            style: CretaFont.bodySmall,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          width: 130.0,
                          child: Text(
                            sequence[i].tag.title as String,
                            maxLines: 1,
                            style: CretaFont.bodySmall,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 48.0),
                        // if (i == state.currentIndex)
                        CretaMiniMusicVisualizer(
                          color: CretaColor.playedColor,
                          width: 4,
                          height: 15,
                          isPlaying: i == state.currentIndex && _audioPlayer.playing ? true : false,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Widget _reorderPlaylist() {
  //   return SingleChildScrollView(
  //     child: SizedBox(
  //       height: 240.0,
  //       child: StreamBuilder<SequenceState?>(
  //         stream: _audioPlayer.sequenceStateStream,
  //         builder: (context, snapshot) {
  //           final state = snapshot.data;
  //           final sequence = state?.sequence ?? [];
  //           return ReorderableListView.builder(
  //             itemCount: sequence.length,
  //             buildDefaultDragHandles: false,
  //             onReorder: reorderList,
  //             itemBuilder: (BuildContext context, i) {
  //               return Material(
  //                 key: ValueKey(sequence[i]),
  //                 color: i == state!.currentIndex ? CretaColor.bufferedColor : Colors.transparent,
  //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
  //                 child: Stack(
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       mainAxisSize: MainAxisSize.max,
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Row(
  //                             children: [
  //                               _dragHandler(i),
  //                               const SizedBox(width: 24.0),
  //                               GestureDetector(
  //                                 onTap: () {
  //                                   _audioPlayer.seek(Duration.zero, index: i);
  //                                 },
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     SizedBox(
  //                                       width: 32.0,
  //                                       child: Text(
  //                                         i < 9 ? '0${i + 1}' : '${i + 1}',
  //                                         style: CretaFont.bodySmall,
  //                                         textAlign: TextAlign.left,
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       width: 130.0,
  //                                       child: Text(
  //                                         sequence[i].tag.title as String,
  //                                         maxLines: 1,
  //                                         style: CretaFont.bodySmall,
  //                                         textAlign: TextAlign.left,
  //                                         overflow: TextOverflow.ellipsis,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // ReorderableDragStartListener _dragHandler(int index) {
  //   return ReorderableDragStartListener(
  //     index: index,
  //     child: const MouseRegion(
  //       cursor: SystemMouseCursors.click,
  //       child: SizedBox(
  //         width: LayoutConst.contentsListHeight,
  //         height: LayoutConst.contentsListHeight,
  //         child: Icon(Icons.menu_outlined, size: 16),
  //       ),
  //     ),
  //   );
  // }
}

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class ControlButtons extends StatelessWidget {
  const ControlButtons({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  void prevMusic() {
    audioPlayer.seekToPrevious();
  }

  void nextMusic() {
    audioPlayer.seekToNext();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // Opens volumn slider dialog
        StreamBuilder<double>(
          stream: audioPlayer.volumeStream,
          builder: ((context, snapshot) {
            double volumeValue = snapshot.data ?? 0.0;
            var icons = [
              const Icon(Icons.volume_off),
              const Icon(Icons.volume_down),
              const Icon(Icons.volume_up),
            ];
            int index = 0;
            if (volumeValue > 0.0 && volumeValue <= 0.5) {
              index = 1;
            } else if (volumeValue > 0.5) {
              index = 2;
            }
            return IconButton(
              icon: icons[index],
              onPressed: () {
                showSliderDialog(
                  context: context,
                  title: "볼륨 조절",
                  divisions: 10,
                  min: 0.0,
                  max: 1.0,
                  stream: audioPlayer.volumeStream,
                  onChanged: audioPlayer.setVolume,
                );
              },
            );
          }),
        ),
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: audioPlayer.hasPrevious ? prevMusic : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playState = snapshot.data;
            final processingState = playState?.processingState;
            final playing = playState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                iconSize: 64.0,
                color: Colors.black87,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                iconSize: 48.0,
                color: Colors.black87,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 64.0,
              color: Colors.black87,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: audioPlayer.hasNext ? nextMusic : null,
          ),
        ),
        StreamBuilder<double>(
          stream: audioPlayer.speedStream,
          builder: (context, snapshot) {
            // double speedValue = snapshot.data ?? 1.000;
            return IconButton(
              icon: const Icon(Icons.speed),
              // style: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                showSliderDialog(
                  context: context,
                  title: "재생 속도",
                  divisions: 4,
                  min: 0.5,
                  max: 1.5,
                  valueSuffix: 'x',
                  stream: audioPlayer.speedStream,
                  onChanged: audioPlayer.setSpeed,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
