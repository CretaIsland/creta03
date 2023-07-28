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
import 'package:marquee/marquee.dart';
// import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/frame_model.dart';
import '../../../../player/music/creta_music_mixin.dart';
import '../../book_main_page.dart';
import '../../right_menu/property_mixin.dart';
import '../../studio_constant.dart';
import 'creta_mini_music_visualizer.dart';
import 'music_common.dart';

class MusicPlayerFrame extends StatefulWidget {
  final ContentsManager contentsManager;
  //final ContentsModel model1;
  final Size size;

  const MusicPlayerFrame({
    super.key,
    required this.contentsManager,
    //required this.model1,
    required this.size,
  });

  @override
  State<MusicPlayerFrame> createState() => MusicPlayerFrameState();
}

class MusicPlayerFrameState extends State<MusicPlayerFrame> with PropertyMixin {
  late AudioPlayer _audioPlayer; // play local audio file

  String _selectedSize = '';

  bool _isPlaylistOpened = false;

  bool _isMusicPlaying = true;

  void setSelectedSize(String selectedValue) {
    _selectedSize = selectedValue;
  }

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

  void mutedMusic(ContentsModel model) {
    _audioPlayer.setVolume(0.0);
  }

  void resumedMusic(ContentsModel model) {
    _audioPlayer.setVolume(1.0);
  }

  void playedMusic(ContentsModel model) {
    _audioPlayer.play();
  }

  void pausedMusic(ContentsModel model) {
    _audioPlayer.pause();
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

  @override
  void initState() {
    super.initState;
    _audioPlayer = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    if (_isMusicPlaying == true) _audioPlayer.play();
    int index = 0;
    FrameModel frameModel = widget.contentsManager.frameModel;
    Size frameSize = Size(frameModel.width.value, frameModel.height.value);
    for (Size ele in StudioConst.musicPlayerSize) {
      if (frameSize == ele) {
        _selectedSize = CretaStudioLang.playerSize.values.toList()[index];
        break;
      }
      index++;
    }
    if (_selectedSize.isEmpty) {
      logger.severe('Selected size is not specified ${widget.size} ');
      _selectedSize = CretaStudioLang.playerSize.values.toList()[0];
    }
    _init();
    afterBuild();
    initMixin();
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

  String _findCurrentTag(int ind) {
    if (ind < 0 || _playlist.children.length <= ind) {
      logger.severe('invalid index $ind');
      return '';
    }
    AudioSource? ele = _playlist.children[ind];
    if (ele is ProgressiveAudioSource) {
      return ele.tag.id.toString();
    }
    return '';
  }

  void currentMusic(int ind) {
    _audioPlayer.seek(index: ind, Duration.zero);
    String currentTargetMid = _findCurrentTag(ind);
    if (currentTargetMid.isNotEmpty) {
      debugPrint('currentTargetMid=$currentTargetMid---------------------------------------');
      widget.contentsManager.setSelectedMid(currentTargetMid);
      BookMainPage.containeeNotifier!.notify();
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
    List<String> size = CretaStudioLang.playerSize.values.toList();
    logger.info('Size of Music app: $_selectedSize------------------');
    if (_selectedSize == size[0]) {
      return _musicFullSize();
    } else if (_selectedSize == size[1]) {
      return _musicMedSize();
    } else if (_selectedSize == size[2]) {
      return _musicSmallSize();
    } else if (_selectedSize == size[3]) {
      return _musicTinySize();
    }
    return const SizedBox.shrink();
  }

  Widget _musicFullSize() {
    return SingleChildScrollView(
      child: Container(
        height: _isPlaylistOpened ? 680 : 540,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<SequenceState?>(
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
                return Container(
                  height: 364.0,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 280.0,
                          height: 280.0,
                          child: Image.network(metadata.artUri.toString(), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Text(metadata.title, style: Theme.of(context).textTheme.titleLarge),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 220.0,
                              child: Marquee(
                                text: metadata.title,
                                style: Theme.of(context).textTheme.titleLarge,
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 120.0,
                                velocity: 80.0,
                                pauseAfterRound: const Duration(milliseconds: 1000),
                                startPadding: 8.0,
                                accelerationDuration: const Duration(milliseconds: 150),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: const Duration(milliseconds: 150),
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                            _musicVisualization(size: _selectedSize, contentsId: metadata.id),
                          ],
                        ),
                      ),
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
                  thumbRadius: 6.0,
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
            ControlButtons(
                audioPlayer: _audioPlayer,
                contentsManager: widget.contentsManager,
                playlist: _playlist,
                passOnPressed: () {
                  debugPrint('Play button is pressed================');
                  debugPrint('Before setState: _isMusicPlaying = $_isMusicPlaying');
                  setState(() {
                    _isMusicPlaying = !_isMusicPlaying;
                  });
                  debugPrint('After setState: _isMusicPlaying = $_isMusicPlaying');
                }),
            // model: widget.model!),
            const SizedBox(height: 4.0),
            // _reorderPlaylist(),
            // _orderPlaylist(),
            Expanded(
              child: propertyCard(
                isOpen: _isPlaylistOpened,
                onPressed: () {
                  setState(() {
                    _isPlaylistOpened = !_isPlaylistOpened;
                  });
                },
                titleWidget: Text(CretaStudioLang.showPlayList, style: CretaFont.titleMedium),
                // trailWidget: Text('${widget.contentsManager.getAvailLength()} ${CretaLang.count}',
                //     style: dataStyle),
                onDelete: () {},
                hasRemoveButton: false,
                bodyWidget: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: _orderPlaylist(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderPlaylist() {
    return SizedBox(
      height: 80.0,
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
                  child: GestureDetector(
                    onTap: () {
                      currentMusic(i);
                    },
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
                        //   _musicVisualization(
                        //       size: _selectedSize, contentsId: sequence[i].tag.id),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _musicVisualization(
      {required String contentsId, bool isTrailer = false, required String size}) {
    debugPrint('_isMusicPlaying in _musicVisualization $_isMusicPlaying=========');
    return MyVisualizer.playVisualizer(
        context: context,
        color: CretaColor.playedColor,
        width: 4,
        height: 15,
        isPlaying: _isMusicPlaying,
        contentsId: contentsId,
        isTrailer: isTrailer,
        size: size);
  }

  Widget _musicMedSize() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox.shrink();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 90.0,
                        height: 90.0,
                        child: Image.network(metadata.artUri.toString(), fit: BoxFit.cover),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _musicVisualization(size: _selectedSize, contentsId: metadata.id),
                          SizedBox(
                            width: 160,
                            child: Text(
                              metadata.title,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(metadata.artist!),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return ProgressBar(
                barHeight: 2.0,
                baseBarColor: CretaColor.bufferedColor.withOpacity(0.24),
                bufferedBarColor: CretaColor.bufferedColor,
                progressBarColor: Colors.black87,
                thumbRadius: 4.0,
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
          ControlButtons(
              audioPlayer: _audioPlayer,
              contentsManager: widget.contentsManager,
              playlist: _playlist,
              passOnPressed: () {
                setState(() {
                  _isMusicPlaying = !_isMusicPlaying;
                });
              }),
          //model: widget.model!),
        ],
      ),
    );
  }

  Widget _musicSmallSize() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<SequenceState?>(
            stream: _audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox.shrink();
              }
              final metadata = state!.currentSource!.tag as MediaItem;
              return Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _musicVisualization(size: _selectedSize, contentsId: metadata.id),
                        SizedBox(
                          width: 130,
                          child: Text(
                            metadata.title,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(metadata.artist!),
                      ],
                    ),
                    ControlButtonsSmallSize(
                      audioPlayer: _audioPlayer,
                      contentsManager: widget.contentsManager,
                      playlist: _playlist,
                      passOnPressed: () {
                        setState(() {
                          _isMusicPlaying = !_isMusicPlaying;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ProgressBar(
                    barHeight: 2.0,
                    baseBarColor: CretaColor.bufferedColor.withOpacity(0.24),
                    bufferedBarColor: CretaColor.bufferedColor,
                    progressBarColor: Colors.black87,
                    thumbColor: Colors.transparent,
                    timeLabelTextStyle: const TextStyle(color: Colors.transparent),
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: _audioPlayer.seek,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _musicTinySize() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 2.0),
      child: StreamBuilder<SequenceState?>(
        stream: _audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence.isEmpty ?? true) {
            return const SizedBox.shrink();
          }
          return ControlButtonsTinySize(
            audioPlayer: _audioPlayer,
            contentsManager: widget.contentsManager,
            playlist: _playlist,
          );
        },
      ),
    );
  }
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
  final ContentsManager contentsManager;
  final ConcatenatingAudioSource playlist;
  final void Function() passOnPressed;

  const ControlButtons({
    super.key,
    required this.audioPlayer,
    required this.contentsManager,
    required this.playlist,
    required this.passOnPressed,
  });

  final AudioPlayer audioPlayer;

  String findPrevousTag() {
    int index = 0;
    String currentMid = contentsManager.getSelectedMid();
    for (var ele in playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
        debugPrint(
            'currentMid=$currentMid, source.tag=${source.tag.id.toString()}---------------------------------------');

        if (source.tag.id.toString() == currentMid) {
          if (index == 0) {
            AudioSource src = playlist.children[playlist.length - 1];
            if (src is ProgressiveAudioSource) {
              return src.tag.id.toString();
            }
          }
          AudioSource src = playlist.children[index - 1];
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
    audioPlayer.seekToPrevious();
    String prevTargetMid = findPrevousTag();
    if (prevTargetMid.isNotEmpty) {
      debugPrint('prevTargetMid=$prevTargetMid---------------------------------------');
      contentsManager.setSelectedMid(prevTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
  }

  String findNextTag() {
    int index = 0;
    String currentMid = contentsManager.getSelectedMid();
    for (var ele in playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
        debugPrint(
            'currentMid=$currentMid, source.tag=${source.tag.id.toString()}---------------------------------------');

        if (source.tag.id.toString() == currentMid) {
          if (index == playlist.length) {
            AudioSource src = playlist.children[0];
            if (src is ProgressiveAudioSource) {
              return src.tag.id.toString();
            }
          }
          AudioSource src = playlist.children[index + 1];
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
    audioPlayer.seekToNext();
    String nextTargetMid = findNextTag();
    if (nextTargetMid.isNotEmpty) {
      debugPrint('nextTargetMid=$nextTargetMid---------------------------------------');
      contentsManager.setSelectedMid(nextTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
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
                width: 52.0,
                height: 52.0,
                child: const CircularProgressIndicator(),
              );
            } else if (!(playing ?? false)) {
              return IconButton(
                onPressed: () {
                  audioPlayer.play();
                  passOnPressed();
                },
                iconSize: 52.0,
                color: Colors.black87,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: () {
                  audioPlayer.pause();
                  passOnPressed();
                },
                iconSize: 52.0,
                color: Colors.black87,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 52.0,
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

class ControlButtonsSmallSize extends StatelessWidget {
  final ContentsManager contentsManager;
  final ConcatenatingAudioSource playlist;
  final void Function() passOnPressed;

  const ControlButtonsSmallSize({
    super.key,
    required this.audioPlayer,
    required this.contentsManager,
    required this.playlist,
    required this.passOnPressed,
  });

  final AudioPlayer audioPlayer;

  String findPrevousTag() {
    int index = 0;
    String currentMid = contentsManager.getSelectedMid();
    for (var ele in playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
        debugPrint(
            'currentMid=$currentMid, source.tag=${source.tag.id.toString()}---------------------------------------');

        if (source.tag.id.toString() == currentMid) {
          if (index == 0) {
            AudioSource src = playlist.children[playlist.length - 1];
            if (src is ProgressiveAudioSource) {
              return src.tag.id.toString();
            }
          }
          AudioSource src = playlist.children[index - 1];
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
    audioPlayer.seekToPrevious();
    String prevTargetMid = findPrevousTag();
    if (prevTargetMid.isNotEmpty) {
      debugPrint('prevTargetMid=$prevTargetMid---------------------------------------');
      contentsManager.setSelectedMid(prevTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
  }

  String findNextTag() {
    int index = 0;
    String currentMid = contentsManager.getSelectedMid();
    for (var ele in playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
        debugPrint(
            'currentMid=$currentMid, source.tag=${source.tag.id.toString()}---------------------------------------');

        if (source.tag.id.toString() == currentMid) {
          if (index == playlist.length) {
            AudioSource src = playlist.children[0];
            if (src is ProgressiveAudioSource) {
              return src.tag.id.toString();
            }
          }
          AudioSource src = playlist.children[index + 1];
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
    audioPlayer.seekToNext();
    String nextTargetMid = findNextTag();
    if (nextTargetMid.isNotEmpty) {
      debugPrint('nextTargetMid=$nextTargetMid---------------------------------------');
      contentsManager.setSelectedMid(nextTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
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
                width: 36.0,
                height: 36.0,
                child: const CircularProgressIndicator(),
              );
            } else if (!(playing ?? false)) {
              return IconButton(
                onPressed: () {
                  audioPlayer.play();
                  passOnPressed();
                },
                iconSize: 36.0,
                color: Colors.black87,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: () {
                  audioPlayer.pause();
                  passOnPressed();
                },
                iconSize: 36.0,
                color: Colors.black87,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 36.0,
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
      ],
    );
  }
}

class ControlButtonsTinySize extends StatelessWidget {
  final ContentsManager contentsManager;
  final ConcatenatingAudioSource playlist;

  const ControlButtonsTinySize({
    super.key,
    required this.audioPlayer,
    required this.contentsManager,
    required this.playlist,
  });

  final AudioPlayer audioPlayer;

  String findPrevousTag() {
    int index = 0;
    String currentMid = contentsManager.getSelectedMid();
    for (var ele in playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
        debugPrint(
            'currentMid=$currentMid, source.tag=${source.tag.id.toString()}---------------------------------------');

        if (source.tag.id.toString() == currentMid) {
          if (index == 0) {
            AudioSource src = playlist.children[playlist.length - 1];
            if (src is ProgressiveAudioSource) {
              return src.tag.id.toString();
            }
          }
          AudioSource src = playlist.children[index - 1];
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
    audioPlayer.seekToPrevious();
    String prevTargetMid = findPrevousTag();
    if (prevTargetMid.isNotEmpty) {
      debugPrint('prevTargetMid=$prevTargetMid---------------------------------------');
      contentsManager.setSelectedMid(prevTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
  }

  String findNextTag() {
    int index = 0;
    String currentMid = contentsManager.getSelectedMid();
    for (var ele in playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
        debugPrint(
            'currentMid=$currentMid, source.tag=${source.tag.id.toString()}---------------------------------------');

        if (source.tag.id.toString() == currentMid) {
          if (index == playlist.length) {
            AudioSource src = playlist.children[0];
            if (src is ProgressiveAudioSource) {
              return src.tag.id.toString();
            }
          }
          AudioSource src = playlist.children[index + 1];
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
    audioPlayer.seekToNext();
    String nextTargetMid = findNextTag();
    if (nextTargetMid.isNotEmpty) {
      debugPrint('nextTargetMid=$nextTargetMid---------------------------------------');
      contentsManager.setSelectedMid(nextTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
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
                width: 42.0,
                height: 42.0,
                child: const CircularProgressIndicator(),
              );
            } else if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                iconSize: 42.0,
                color: Colors.black87,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                iconSize: 42.0,
                color: Colors.black87,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 42.0,
              color: Colors.black87,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: audioPlayer.hasPrevious ? nextMusic : null,
          ),
        ),
      ],
    );
  }
}
