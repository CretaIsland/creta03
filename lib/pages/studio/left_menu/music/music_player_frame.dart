import 'dart:async';
// import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta03/pages/studio/left_menu/music/control_buttons.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../book_main_page.dart';
import '../../right_menu/property_mixin.dart';
import '../../studio_constant.dart';
import '../../studio_variables.dart';
import 'creta_mini_music_visualizer.dart';

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

  // String _selectedSize = '';
  bool _isPlaylistOpened = false;
  bool _isMusicPlaying = false;

  late GlobalObjectKey<MusicControlBtnState> volumeButtonKey;
  Offset? _volumePosition;

  double iconBTNSize = StudioConst.musicIconSize;
  String urlVisual =
      'https://firebasestorage.googleapis.com/v0/b/hycop-example.appspot.com/o/creta_default%2Fmusic-visualizer.gif?alt=media&token=23265dfd-6d3d-4791-b05c-1fc7da1ee978';

  void invalidate() {
    setState(() {});
  }

  // void setSelectedSize(String selectedValue) {
  //   _selectedSize = selectedValue;
  // }

  // MusicPlayerSizeEnum _selectedSize = MusicPlayerSizeEnum.Big;

  // void setSelectedSize(String selectedValue) {
  //   _selectedSize = sizeEnumMap[selectedValue] ?? MusicPlayerSizeEnum.Big;
  // }

  void addMusic(ContentsModel model) async {
    // Random random = Random();
    // int randomNumber = random.nextInt(100);
    // String url = 'https://picsum.photos/200/?random=$randomNumber';

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
          artUri: Uri.parse(urlVisual),
          // artUri: Uri.parse(url),
        ),
      ),
    );

    _audioPlayer.seek(Duration.zero, index: 0).then((val) {
      _audioPlayer.pause();
    });
    // _audioPlayer.seek(Duration.zero, index: 0);
    // _audioPlayer.play();
  }

  void unhiddenMusic(ContentsModel model, int idx) {
    // Random random = Random();
    // int randomNumber = random.nextInt(100);
    // String url = 'https://picsum.photos/200/?random=$randomNumber';

    _playlist.insert(
      idx,
      AudioSource.uri(
        Uri.parse(model.remoteUrl!),
        tag: MediaItem(
          id: model.mid,
          title: model.name,
          artist: 'Unknown artist',
          // artUri: Uri.parse(url),
          artUri: Uri.parse(urlVisual),
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
    logger.fine('====RemoveMusic(${model.name})====');
    int index = findIndex(model);
    if (index >= 0) {
      _playlist.removeAt(index);
    }
  }

  void reorderPlaylist(ContentsModel model, int oldIndex, int newIndex) async {
    logger.fine('====Reorder song at #$oldIndex to #$newIndex====');
    await _playlist.move(oldIndex, newIndex);

    if (newIndex == 0) _audioPlayer.seek(Duration.zero, index: newIndex);
    _audioPlayer.play();
  }

  void selectedSong(ContentsModel model, int i) {
    _audioPlayer.seek(Duration.zero, index: i);
  }

  void mutedMusic(ContentsModel model) {
    _audioPlayer.setVolume(0.0);
    widget.contentsManager.frameModel.mute.set(true);
  }

  void resumedMusic(ContentsModel model) {
    _audioPlayer.setVolume(widget.contentsManager.frameModel.volume.value / 100);
    widget.contentsManager.frameModel.mute.set(false);
  }

  void adjustVol(ContentsModel model, double val) {
    _audioPlayer.setVolume(widget.contentsManager.frameModel.volume.value / 100);
    widget.contentsManager.frameModel.volume.set(val);
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

  void stopMusic() {
    //print('stopMusic()');
    _audioPlayer.stop();
    _audioPlayer.dispose();
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
        frameModel.musicPlayerSizeType = MusicPlayerSizeEnum.values[index];
        break;
      }
      index++;
    }
    // if (_selectedSize.isEmpty) {
    //   logger.fine('Selected size is not specified ${widget.size} ');
    //   _selectedSize = CretaStudioLang['playerSize']!.values.toList()[0];
    // }

    if (frameModel.mute.value) {
      _audioPlayer.setVolume(frameModel.volume.value / 100);
    }

    _init();
    afterBuild();
    initMixin();
    volumeButtonKey = GlobalObjectKey<MusicControlBtnState>(
        'volumeButtonKey${widget.contentsManager.frameModel.mid}');
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
      // if (StudioVariables.isAutoPlay == true) { // 자동재생 안됨
      //   _audioPlayer.play();
      // }
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      logger.fine("Error loading playlist: $e");
      logger.fine(stackTrace);
    }
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.contentsManager.orderMapIterator((ele) {
        if (ele.isRemoved.value == true) return null;
        if (StudioVariables.isAutoPlay == true) {
          Timer.periodic(const Duration(seconds: 1), (timer) {
            // 딜레이 없이는 자동재생 안됨
            timer.cancel();
            _audioPlayer.play();
          });
        }

        ContentsModel model = ele as ContentsModel;
        if (model.isShow.value == false) return null;
        if (model.isMusic()) {
          String key = widget.contentsManager.frameModel.mid;
          GlobalObjectKey<MusicPlayerFrameState>? musicKey = BookMainPage.musicKeyMap[key];
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
    //print('MusicPlayerFrame.dispose');
    _audioPlayer.stop();
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
      logger.fine('invalid index $ind');
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
    double frameScale = StudioVariables.applyScale / 0.7025000000000001;
    double iconSize = iconBTNSize * StudioVariables.applyScale;
    double dampX = 0;
    double dampY = 0;
    FrameModel frameModel = widget.contentsManager.frameModel;

    if (frameModel.musicPlayerSizeType == MusicPlayerSizeEnum.Big) {
      dampX = -1;
      dampY = 8;
    } else {
      dampX = 23;
      dampY = 32;
    }
    //Size? volumeBtSize = CretaCommonUtils.getSize(volumeButtonKey);
    //if (volumeBtSize != null) {
    //print('volumeBtSize = $volumeBtSize');
    if (frameModel.musicPlayerSizeType == MusicPlayerSizeEnum.Big ||
        frameModel.musicPlayerSizeType == MusicPlayerSizeEnum.Medium) {
      _volumePosition = CretaCommonUtils.getPosition(volumeButtonKey);
      //_volumePosition = Offset(rect.left, rect.top);
      if (_volumePosition != null) {
        double offsetX = frameModel.posX.value * StudioVariables.applyScale +
            BookMainPage.pageOffset.dx +
            iconSize +
            dampX;
        double offsetY = frameModel.posY.value * StudioVariables.applyScale +
            BookMainPage.pageOffset.dy +
            iconSize / 2 +
            dampY +
            170;
        _volumePosition = _volumePosition! - Offset(offsetX, offsetY);
        // print('_volumePosition $_volumePosition');
      } else {
        logger.fine('Volume Icon Button Position is null');
      }
    }
    // List<String> sizeStrList = CretaStudioLang['playerSize']!.values.toList();

    if (StudioVariables.applyScale <= 0.34) {
      return const Icon(Icons.queue_music_outlined);
    }
    switch (frameModel.musicPlayerSizeType) {
      case MusicPlayerSizeEnum.Big:
        return _musicFullSize(frameScale);
      case MusicPlayerSizeEnum.Medium:
        return _musicMedSize(frameScale);
      case MusicPlayerSizeEnum.Small:
        return _musicSmallSize(frameScale);
      case MusicPlayerSizeEnum.Tiny:
        return _musicTinySize(frameScale);
      default:
        return _musicFullSize(frameScale);
    }
  }

  Widget _musicFullSize(double scaleVal) {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            height: _isPlaylistOpened ? 680.0 * scaleVal : 560.0 * scaleVal,
            // padding: EdgeInsets.symmetric(horizontal: 24.0 * scaleVal, vertical: 16.0 * scaleVal),
            padding: EdgeInsets.symmetric(horizontal: 16.0 * scaleVal, vertical: 16.0 * scaleVal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _upperArea(scaleVal), // Image, Title, artist.
                _progressionBar(scaleVal: scaleVal),
                _controlButtons(scaleVal),
                SizedBox(height: 4.0 * scaleVal),
                _playList(scaleVal),
              ],
            ),
          ),
          if (_audioPlayer.isVolumeHover == true && _volumePosition != null)
            _volumeButton(scaleVal),
        ],
      ),
    );
  }

  Widget _volumeButton(double scaleVal) {
    FrameModel frameModel = widget.contentsManager.frameModel;
    return Positioned(
      top: _volumePosition!.dy * scaleVal,
      left: _volumePosition!.dx * scaleVal,
      child: StreamBuilder<double>(
          stream: _audioPlayer.volumeStream,
          builder: (context, snapshot) {
            double volumeValue = snapshot.data ?? 0.0;
            var icons = [
              Icon(Icons.volume_off, size: iconBTNSize / 2.0 * scaleVal),
              Icon(Icons.volume_down, size: iconBTNSize / 2.0 * scaleVal),
              Icon(Icons.volume_up, size: iconBTNSize / 2.0 * scaleVal),
            ];
            int index = 0;
            if (volumeValue > 0.0 && volumeValue <= 0.5) {
              index = 1;
            } else if (volumeValue > 0.5) {
              index = 2;
            }
            return MusicControlBtn(
              audioPlayer: _audioPlayer,
              frameId: widget.contentsManager.frameModel.mid,
              isShowVolume: true,
              iconSize: iconBTNSize * scaleVal,
              sliderHeight: (frameModel.musicPlayerSizeType == MusicPlayerSizeEnum.Big)
                  ? 120
                  : (frameModel.musicPlayerSizeType == MusicPlayerSizeEnum.Medium)
                      ? 100
                      : null,
              sliderWidth: (frameModel.musicPlayerSizeType == MusicPlayerSizeEnum.Big)
                  ? 26.0
                  : (frameModel.musicPlayerSizeType == MusicPlayerSizeEnum.Medium)
                      ? 22.0
                      : null,
              spaceY: (frameModel.musicPlayerSizeType == MusicPlayerSizeEnum.Big)
                  ? 180
                  : (frameModel.musicPlayerSizeType == MusicPlayerSizeEnum.Medium)
                      ? 160.0
                      : null,
              value: widget.contentsManager.frameModel.volume.value / 100,
              onHoverChanged: () {
                setState(() {});
              },
              onChanged: (value) {
                setState(() {
                  _audioPlayer.setVolume(value);
                  widget.contentsManager.frameModel.volume.set(value * 100);
                  // if (value > 0) {
                  //   widget.contentsManager.frameModel.mute.set(false);
                  // }
                });
              },
              child: IconButton(
                icon: icons[index],
                onPressed: () {
                  setState(
                    () {
                      if (volumeValue > 0) {
                        _audioPlayer.setVolume(0.0);
                      } else {
                        _audioPlayer
                            .setVolume(widget.contentsManager.frameModel.volume.value / 100);
                      }
                    },
                  );
                },
              ),
            );
          }),
    );
  }

  Widget _controlButtons(double scaleVal) {
    return ControlButtons(
      volumeButtonKey: volumeButtonKey,
      audioPlayer: _audioPlayer,
      contentsManager: widget.contentsManager,
      playlist: _playlist,
      onHoverChanged: () {
        setState(() {});
      },
      passOnPressed: () {
        setState(() {
          _isMusicPlaying = !_isMusicPlaying;
        });
      },
      scaleVal: scaleVal,
      toggleValue: _isMusicPlaying,
    );
  }

  Widget _playList(double scaleVal) {
    return Expanded(
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
            Text(CretaStudioLang['showPlayList']!, style: TextStyle(fontSize: 16.0 * scaleVal)),
        // trailWidget: Text('${widget.contentsManager.getAvailLength()} ${CretaLang['count']!}',
        //     style: dataStyle),
        onDelete: () {},
        hasRemoveButton: false,
        bodyWidget: Padding(
          padding: EdgeInsets.only(top: 6.0 * scaleVal),
          child: _orderPlaylist(scaleVal),
        ),
      ),
    );
  }

  Widget _upperArea(double scaleVal) {
    return Expanded(
      flex: _isPlaylistOpened ? 0 : 4,
      child: StreamBuilder<SequenceState?>(
        stream: _audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence.isEmpty ?? true) {
            return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: SizedBox(
                  width: 276.0 * scaleVal,
                  height: 276.0 * scaleVal,
                  child: Image.asset('no_image.png', fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 8.0 * scaleVal),
              Text(CretaStudioLang["addPlayList"], //'플레이 리스트에 노래를 추가하세요!',
                  style: TextStyle(fontSize: 20 * scaleVal)),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: SizedBox(
                        width: 276.0 * scaleVal,
                        height: 276.0 * scaleVal,
                        child: Image.network(metadata.artUri.toString(), fit: BoxFit.cover),
                      ),
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
                        style: TextStyle(fontSize: 20.0 * scaleVal, fontWeight: FontWeight.bold),
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
                        size: widget.contentsManager.frameModel.musicPlayerSizeType,
                        contentsId: metadata.id,
                        scaleVal: scaleVal),
                  ],
                ),
                Text(metadata.artist!, style: TextStyle(fontSize: 14.0 * scaleVal)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _progressionBar(
      {required double scaleVal,
      double barHeight = 4.0,
      double thumRadius = 6.0,
      double fontSize = 14.0,
      bool isSmallSize = false}) {
    return StreamBuilder<PositionData>(
      stream: _positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return ProgressBar(
          barHeight: barHeight * scaleVal,
          // baseBarColor: CretaColor.bufferedColor.withOpacity(0.24),
          baseBarColor: CretaColor.text.shade300,
          bufferedBarColor: CretaColor.bufferedColor,
          progressBarColor: Colors.black87,
          thumbRadius: thumRadius * scaleVal,
          thumbGlowRadius: 8.0 * scaleVal,
          thumbColor: Colors.black87,
          timeLabelTextStyle: isSmallSize
              ? const TextStyle(color: Colors.transparent)
              : TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize * scaleVal),
          progress: positionData?.position ?? Duration.zero,
          buffered: positionData?.bufferedPosition ?? Duration.zero,
          total: positionData?.duration ?? Duration.zero,
          onSeek: _audioPlayer.seek,
        );
      },
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
      required MusicPlayerSizeEnum size,
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
      padding: EdgeInsets.symmetric(horizontal: 16.0 * scaleVal),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _medSizeUpperArea(scaleVal),
              _progressionBar(scaleVal: scaleVal),
              _controlButtons(scaleVal),
            ],
          ),
          if (_audioPlayer.isVolumeHover == true && _volumePosition != null)
            _volumeButton(scaleVal),
        ],
      ),
    );
  }

  Widget _medSizeUpperArea(double scaleVal) {
    return Flexible(
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: SizedBox(
                    width: 90.0 * scaleVal,
                    height: 90.0 * scaleVal,
                    child: Image.network(metadata.artUri.toString(), fit: BoxFit.cover),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _musicVisualization(
                      size: widget.contentsManager.frameModel.musicPlayerSizeType,
                      contentsId: metadata.id,
                      scaleVal: scaleVal,
                    ),
                    SizedBox(
                      width: 160 * scaleVal,
                      child: Text(
                        metadata.title,
                        maxLines: 1,
                        // style: Theme.of(context).textTheme.titleMedium,
                        style: TextStyle(fontSize: 18.0 * scaleVal, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(metadata.artist!, style: TextStyle(fontSize: 14.0 * scaleVal)),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _musicSmallSize(double scaleVal) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0 * scaleVal, horizontal: 8.0 * scaleVal),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _smallSizeImg(scaleVal),
          Expanded(child: _smallSizeRightArea(scaleVal)),
        ],
      ),
    );
  }

  Widget _smallSizeImg(double scaleVal) {
    return StreamBuilder<SequenceState?>(
      stream: _audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox.shrink();
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: SizedBox(
            width: 80.0 * scaleVal,
            height: 80.0 * scaleVal,
            child: Image.network(metadata.artUri.toString(), fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget _smallSizeRightArea(double scaleVal) {
    return StreamBuilder<SequenceState?>(
      stream: _audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox.shrink();
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 6.0 * scaleVal),
              child: Text(
                metadata.title,
                maxLines: 1,
                style: TextStyle(fontSize: 16.0 * scaleVal, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(metadata.artist!, style: TextStyle(fontSize: 12.0 * scaleVal)),
            Expanded(
              child: SizedBox(
                width: 180.0 * scaleVal,
                child: _progressionBar(scaleVal: scaleVal, isSmallSize: true),
              ),
            ),
            _controlButtons(scaleVal),
          ],
        );
      },
    );
  }

  Widget _musicTinySize(double scaleVal) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox(
          width: double.infinity,
          height: double.infinity,
        ),
        _controlButtons(scaleVal),
      ],
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
