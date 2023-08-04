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
import 'package:rxdart/rxdart.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/frame_model.dart';
import '../../../../player/music/creta_music_mixin.dart';
import '../../book_main_page.dart';
import '../../right_menu/property_mixin.dart';
import '../../studio_constant.dart';
import '../../studio_variables.dart';
import 'creta_mini_music_visualizer.dart';
import 'music_common.dart';

class MusicPlayerFrame extends StatefulWidget {
  final ContentsManager contentsManager;
  final Size size;

  const MusicPlayerFrame({
    // super.key,
    Key? key,
    required this.contentsManager,
    required this.size,
  }) : super(key: key);

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
    await _playlist
        .insert(
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
    )
        .then((val1) {
      return _audioPlayer.seek(Duration.zero, index: 0).then((val2) {
        _audioPlayer.play();
      });
    });
    // _audioPlayer.seek(Duration.zero, index: 0);
    // _audioPlayer.play();
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
    logger.info('====RemoveMusic(${model.name})====');
    int index = findIndex(model);
    if (index >= 0) {
      _playlist.removeAt(index);
    }
  }

  void reorderPlaylist(ContentsModel model, int oldIndex, int newIndex) async {
    logger.info('====Reorder song at #$oldIndex to #$newIndex====');
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
    setState(() {
      _isMusicPlaying = true;
    });
    _audioPlayer.play();
  }

  void pausedMusic(ContentsModel model) {
    setState(() {
      _isMusicPlaying = false;
    });
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
    _audioPlayer.setVolume(0.0);

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
      // debugPrint('currentTargetMid=$currentTargetMid---------------------------------------');
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
    // debugPrint('-------------------------------------------${StudioVariables.applyScale}');
    List<String> size = CretaStudioLang.playerSize.values.toList();
    double frameScale = StudioVariables.applyScale / 0.7025000000000001;
    // logger.info('Size of Music app: $_selectedSize------------------');
    if (StudioVariables.applyScale <= 0.40) {
      return const Icon(Icons.queue_music_outlined);
    }
    if (_selectedSize == size[0]) {
      return _musicFullSize(frameScale);
    } else if (_selectedSize == size[1]) {
      return _musicMedSize(frameScale);
      // return _musicMedSize(StudioVariables.applyScale / 0.5);
    } else if (_selectedSize == size[2]) {
      return _musicSmallSize(frameScale);
    } else if (_selectedSize == size[3]) {
      return _musicTinySize(frameScale);
    }
    return const SizedBox.shrink();
  }

  Widget _musicFullSize(double scaleVal) {
    return SingleChildScrollView(
      child: Container(
        height: _isPlaylistOpened ? 680.0 * scaleVal : 560.0 * scaleVal,
        padding: EdgeInsets.symmetric(horizontal: 24.0 * scaleVal, vertical: 16.0 * scaleVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: _isPlaylistOpened ? 0 : 4,
              child: StreamBuilder<SequenceState?>(
                stream: _audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      SizedBox(
                        width: 280.0 * scaleVal,
                        height: 280.0 * scaleVal,
                        child: Image.asset('no_image.png', fit: BoxFit.cover),
                      ),
                      SizedBox(height: 8.0 * scaleVal),
                      Text('플레이 리스트에 노래를 추가하세요!', style: TextStyle(fontSize: 20 * scaleVal)),
                    ]);
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return Container(
                    height: 380.0 * scaleVal,
                    padding: EdgeInsets.symmetric(vertical: 8.0 * scaleVal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              width: 280.0 * scaleVal,
                              height: 280.0 * scaleVal,
                              child: Image.network(metadata.artUri.toString(), fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        // SizedBox(height: 6.0 * scaleVal),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(metadata.title, style: TextStyle(fontSize: 20.0 * scaleVal)),
                            Container(
                              padding: EdgeInsets.only(top: 6.0 * scaleVal),
                              width: MediaQuery.of(context).size.width * 0.1145 * scaleVal,
                              child: Text(
                                metadata.title,
                                maxLines: 1,
                                style: TextStyle(fontSize: 20.0 * scaleVal),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // SizedBox(
                            //   width: 220.0 * scaleVal,
                            //   height: 28.0 * scaleVal,
                            //   child: Marquee(
                            //     text: metadata.title,
                            //     style: TextStyle(fontSize: 20.0 * scaleVal),
                            //     // style: Theme.of(context).textTheme.titleLarge ,
                            //     textScaleFactor: scaleVal,
                            //     scrollAxis: Axis.horizontal,
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     blankSpace: 120.0 * scaleVal,
                            //     velocity: 80.0,
                            //     pauseAfterRound: const Duration(milliseconds: 1000),
                            //     startPadding: 8.0 * scaleVal,
                            //     accelerationDuration: const Duration(milliseconds: 150),
                            //     accelerationCurve: Curves.linear,
                            //     decelerationDuration: const Duration(milliseconds: 150),
                            //     decelerationCurve: Curves.easeOut,
                            //   ),
                            // ),
                            _musicVisualization(
                                size: _selectedSize, contentsId: metadata.id, scaleVal: scaleVal),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(metadata.artist!, style: TextStyle(fontSize: 14.0 * scaleVal)),
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
                                  Icon(Icons.repeat,
                                      color: Colors.black87.withOpacity(0.5),
                                      size: 24.0 * scaleVal),
                                  Icon(Icons.repeat, color: Colors.black87, size: 24.0 * scaleVal),
                                  Icon(Icons.repeat_one,
                                      color: Colors.black87, size: 24.0 * scaleVal),
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
            // SizedBox(height: 4.0 * scaleVal),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  barHeight: 4.0 * scaleVal,
                  baseBarColor: CretaColor.bufferedColor.withOpacity(0.24),
                  bufferedBarColor: CretaColor.bufferedColor,
                  progressBarColor: Colors.black87,
                  thumbRadius: 6.0 * scaleVal,
                  thumbColor: Colors.black87,
                  timeLabelTextStyle: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14 * scaleVal),
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
              },
              scaleVal: scaleVal,
            ),
            SizedBox(height: 4.0 * scaleVal),
            Expanded(
              flex: _isPlaylistOpened ? 0 : 1,
              child: propertyCard(
                isOpen: _isPlaylistOpened,
                iconSize: 20 * scaleVal,
                onPressed: () {
                  setState(() {
                    _isPlaylistOpened = !_isPlaylistOpened;
                  });
                },
                titleWidget:
                    Text(CretaStudioLang.showPlayList, style: TextStyle(fontSize: 16.0 * scaleVal)),
                // trailWidget: Text('${widget.contentsManager.getAvailLength()} ${CretaLang.count}',
                //     style: dataStyle),
                onDelete: () {},
                hasRemoveButton: false,
                bodyWidget: Padding(
                  padding: EdgeInsets.only(top: 6.0 * scaleVal),
                  child: _orderPlaylist(scaleVal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderPlaylist(double scaleVal) {
    return SizedBox(
      height: 80.0 * scaleVal,
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0 * scaleVal)),
                child: Container(
                  padding: EdgeInsets.only(left: 24.0 * scaleVal),
                  height: 32.0 * scaleVal,
                  child: GestureDetector(
                    onTap: () {
                      currentMusic(i);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 32.0 * scaleVal,
                          child: Text(
                            i < 9 ? '0${i + 1}' : '${i + 1}',
                            style: TextStyle(fontSize: 14.0 * scaleVal),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          width: 130.0 * scaleVal,
                          child: Text(
                            sequence[i].tag.title as String,
                            maxLines: 1,
                            style: TextStyle(fontSize: 14.0 * scaleVal),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
      {required String contentsId,
      bool isTrailer = false,
      required String size,
      required double scaleVal}) {
    return MyVisualizer.playVisualizer(
      context: context,
      color: CretaColor.playedColor,
      width: 4.0,
      height: 15.0,
      isPlaying: _isMusicPlaying,
      contentsId: contentsId,
      isTrailer: isTrailer,
      size: size,
      scaleVal: scaleVal,
    );
  }

  Widget _musicMedSize(double scaleVal) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0 * scaleVal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox.shrink();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0 * scaleVal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 90.0 * scaleVal,
                        height: 90.0 * scaleVal,
                        child: Image.network(metadata.artUri.toString(), fit: BoxFit.cover),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _musicVisualization(
                              size: _selectedSize, contentsId: metadata.id, scaleVal: scaleVal),
                          SizedBox(
                            width: 160 * scaleVal,
                            child: Text(
                              metadata.title,
                              maxLines: 1,
                              // style: Theme.of(context).textTheme.titleMedium,
                              style: TextStyle(fontSize: 14 * scaleVal),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(metadata.artist!, style: TextStyle(fontSize: 12 * scaleVal)),
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
                barHeight: 2.0 * scaleVal,
                baseBarColor: CretaColor.bufferedColor.withOpacity(0.24),
                bufferedBarColor: CretaColor.bufferedColor,
                progressBarColor: Colors.black87,
                thumbRadius: 4.0 * scaleVal,
                thumbColor: Colors.black87,
                timeLabelTextStyle: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 12.0 * scaleVal),
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
              },
              scaleVal: scaleVal),
        ],
      ),
    );
  }

  Widget _musicSmallSize(double scaleVal) {
    // debugPrint('----height of context: ${MediaQuery.of(context).size.height}------');
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.025 * scaleVal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox.shrink();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return Container(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0075 * scaleVal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _musicVisualization(
                              size: _selectedSize, contentsId: metadata.id, scaleVal: scaleVal),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.07 * scaleVal,
                            child: Text(
                              metadata.title,
                              maxLines: 1,
                              style: TextStyle(fontSize: 14.0 * scaleVal),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(metadata.artist!, style: TextStyle(fontSize: 12.0 * scaleVal)),
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
                        scaleVal: scaleVal,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // SizedBox(height: 6.0 * scaleVal),
          Expanded(
            flex: 1,
            child: Container(
              height: 8.0 * scaleVal,
              width: MediaQuery.of(context).size.width,
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.0075 * scaleVal),
              child: StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _musicTinySize(double scaleVal) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0 * scaleVal,
          right: 16.0 * scaleVal,
          top: 8.0 * scaleVal,
          bottom: 2.0 * scaleVal),
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
            scaleVal: scaleVal,
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
  final double scaleVal;

  const ControlButtons({
    super.key,
    required this.audioPlayer,
    required this.contentsManager,
    required this.playlist,
    required this.passOnPressed,
    required this.scaleVal,
  });

  final AudioPlayer audioPlayer;

  String findPrevousTag() {
    int index = 0;
    String currentMid = contentsManager.getSelectedMid();
    for (var ele in playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
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
      contentsManager.setSelectedMid(nextTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
  }

  void fromBeginning() {
    audioPlayer.seek(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = 51.0 * scaleVal;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Opens volumn slider dialog
        Flexible(
          child: StreamBuilder<double>(
            stream: audioPlayer.volumeStream,
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
        ),
        Flexible(
          child: StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(Icons.skip_previous, size: iconSize / 2.0),
              onPressed: audioPlayer.hasPrevious ? prevMusic : fromBeginning,
            ),
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
                margin: EdgeInsets.all(8.0 * scaleVal),
                width: iconSize,
                height: iconSize,
                child: const CircularProgressIndicator(),
              );
            } else if (!(playing ?? false)) {
              return IconButton(
                onPressed: () {
                  audioPlayer.play();
                  passOnPressed();
                },
                iconSize: iconSize,
                color: Colors.black87,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: () {
                  audioPlayer.pause();
                  passOnPressed();
                },
                iconSize: iconSize,
                color: Colors.black87,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return Icon(
              Icons.play_arrow_rounded,
              size: iconSize,
              color: Colors.black87,
            );
          },
        ),
        Flexible(
          child: StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(Icons.skip_next, size: iconSize / 2.0),
              onPressed: audioPlayer.hasNext ? nextMusic : fromBeginning,
            ),
          ),
        ),
        Flexible(
          child: StreamBuilder<double>(
            stream: audioPlayer.speedStream,
            builder: (context, snapshot) {
              // double speedValue = snapshot.data ?? 1.000;
              return IconButton(
                icon: Icon(Icons.speed, size: iconSize / 2.0),
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
        ),
      ],
    );
  }
}

class ControlButtonsSmallSize extends StatelessWidget {
  final ContentsManager contentsManager;
  final ConcatenatingAudioSource playlist;
  final void Function() passOnPressed;
  final double scaleVal;

  const ControlButtonsSmallSize({
    super.key,
    required this.audioPlayer,
    required this.contentsManager,
    required this.playlist,
    required this.passOnPressed,
    required this.scaleVal,
  });

  final AudioPlayer audioPlayer;

  String findPrevousTag() {
    int index = 0;
    String currentMid = contentsManager.getSelectedMid();
    for (var ele in playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
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
      contentsManager.setSelectedMid(nextTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
  }

  void fromBeginning() {
    audioPlayer.seek(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.015 * scaleVal,
          child: StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(
                Icons.skip_previous,
                size: 24 * scaleVal,
              ),
              onPressed: audioPlayer.hasPrevious ? prevMusic : fromBeginning,
            ),
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
                margin: EdgeInsets.all(8.0 * scaleVal),
                width: 36.0 * scaleVal,
                height: 36.0 * scaleVal,
                child: const CircularProgressIndicator(),
              );
            } else if (!(playing ?? false)) {
              return IconButton(
                onPressed: () {
                  audioPlayer.play();
                  passOnPressed();
                },
                iconSize: 36.0 * scaleVal,
                color: Colors.black87,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: () {
                  audioPlayer.pause();
                  passOnPressed();
                },
                iconSize: 36.0 * scaleVal,
                color: Colors.black87,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return Icon(
              Icons.play_arrow_rounded,
              size: 36.0 * scaleVal,
              color: Colors.black87,
            );
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.015 * scaleVal,
          child: StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(
                Icons.skip_next,
                size: 24.0 * scaleVal,
              ),
              onPressed: audioPlayer.hasNext ? nextMusic : fromBeginning,
            ),
          ),
        ),
      ],
    );
  }
}

class ControlButtonsTinySize extends StatelessWidget {
  final ContentsManager contentsManager;
  final ConcatenatingAudioSource playlist;
  final double scaleVal;

  const ControlButtonsTinySize({
    super.key,
    required this.audioPlayer,
    required this.contentsManager,
    required this.playlist,
    required this.scaleVal,
  });

  final AudioPlayer audioPlayer;

  String findPrevousTag() {
    int index = 0;
    String currentMid = contentsManager.getSelectedMid();
    for (var ele in playlist.children) {
      if (ele is ProgressiveAudioSource) {
        ProgressiveAudioSource source = ele;
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
      contentsManager.setSelectedMid(nextTargetMid);
      BookMainPage.containeeNotifier!.notify();
    }
  }

  void fromBeginning() {
    audioPlayer.seek(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 42.0 * scaleVal;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(Icons.skip_previous, size: 24 * scaleVal),
              onPressed: audioPlayer.hasPrevious ? prevMusic : fromBeginning,
            ),
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
                margin: EdgeInsets.all(8.0 * scaleVal),
                width: iconSize,
                height: iconSize,
                child: const CircularProgressIndicator(),
              );
            } else if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                iconSize: iconSize,
                color: Colors.black87,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                iconSize: iconSize,
                color: Colors.black87,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return Icon(
              Icons.play_arrow_rounded,
              size: iconSize,
              color: Colors.black87,
            );
          },
        ),
        Flexible(
          child: StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(Icons.skip_next, size: 24 * scaleVal),
              onPressed: audioPlayer.hasPrevious ? nextMusic : fromBeginning,
            ),
          ),
        ),
      ],
    );
  }
}
