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
import 'package:rxdart/rxdart.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../player/music/creta_music_mixin.dart';
import 'music_common.dart';

class LeftMenuMusic extends StatefulWidget {
  final ContentsManager contentsManager;
  final Size size;

  const LeftMenuMusic({super.key, required this.contentsManager, required this.size});

  @override
  State<LeftMenuMusic> createState() => LeftMenuMusicState();
}

class LeftMenuMusicState extends State<LeftMenuMusic> {
  static int _nextmediaId = 0;
  late AudioPlayer _audioPlayer; // play local audio file

  static Random random = Random();
  static int randomNumber = random.nextInt(100);
  static String url = 'https://picsum.photos/200/?random=$randomNumber';

  void addMusic(ContentsModel model) {
    _playlist.add(AudioSource.uri(Uri.parse(model.remoteUrl!),
        tag: MediaItem(
          id: model.mid,
          title: model.name,
          artist: 'Unknown artist',
          artUri: Uri.parse(url),
        )));
  }

  final _playlist = ConcatenatingAudioSource(
    children: [],
    // AudioSource.uri(
    //   Uri.parse("asset:///assets/audio/canone.mp3"),
    //   tag: MediaItem(
    //     id: '${_nextmediaId++}',
    //     title: "Variatio 3 a 1 Clav.Canone all'Unisuono'",
    //     artist: 'Kimiko Ishizaka',
    //     artUri: Uri.parse(
    //         'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
    //   ),
    // ),
    // AudioSource.uri(
    //   Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
    //   tag: MediaItem(
    //     id: '${_nextmediaId++}',
    //     artist: "Science Friday",
    //     title: "From Cat Rheology To Operatic Incompetence",
    //     artUri: Uri.parse("asset:///assets/creta-watercolor.png"),
    //   ),
    // ),
    // AudioSource.uri(
    //   Uri.parse("https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
    //   tag: MediaItem(
    //     id: '${_nextmediaId++}',
    //     artist: "Science Friday",
    //     title: "A Salute To Head-Scratching Science (30 seconds)",
    //     artUri: Uri.parse(
    //         "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
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
          GlobalObjectKey<LeftMenuMusicState>? musicKey = musicKeyMap[key];
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
    // _audioPlayer = AudioPlayer()..setAsset('assets/audio/canone.mp3'); // set the assets audio
    _audioPlayer = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
    // _audioPlayer.positionStream;
    // _audioPlayer.bufferedPositionStream;
    // _audioPlayer.durationStream;
    afterBuild();
  }

  Future<void> _init() async {
    // await _audioPlayer
    //     .setLoopMode(LoopMode.all); // set the playlist to going to the previous or next track
    // await _audioPlayer.setAudioSource(_playlist);
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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                          child: SizedBox(
                        width: 250.0,
                        height: 250.0,
                        child: Image.network(metadata.artUri.toString(), fit: BoxFit.cover),
                      )),
                      const SizedBox(height: 16.0),
                      Text(metadata.title, style: Theme.of(context).textTheme.titleLarge),
                      Text(metadata.artist!),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return
                    // SeekBar(
                    //   duration: positionData?.duration ?? Duration.zero,
                    //   position: positionData?.position ?? Duration.zero,
                    //   bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                    //   onChangeEnd: _audioPlayer.seek,
                    // );
                    ProgressBar(
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
            // const SizedBox(height: 6.0),
            ControlButtons(audioPlayer: _audioPlayer),
          ],
        ),
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
  const ControlButtons({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volumn slider dialog
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: audioPlayer.volumeStream,
              onChanged: audioPlayer.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
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
            onPressed: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: audioPlayer.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: audioPlayer.speedStream,
                onChanged: audioPlayer.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}
