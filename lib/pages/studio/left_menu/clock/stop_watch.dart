import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  final _isHours = true;
  bool _isStartPressed = false;
  bool _isResetPressed = false;
  bool _isShown = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) => {},
    onChangeRawSecond: (value) => {},
    onChangeRawMinute: (value) => {},
    onStopped: () {},
    onEnded: () {},
  );

  final _scrollController = ScrollController();

  void _startOrStopTimer() {
    setState(() {
      _isStartPressed = !_isStartPressed;
      if (_isStartPressed) {
        _stopWatchTimer.onStartTimer();
        _isResetPressed = false;
        _isShown = true;
      } else {
        _stopWatchTimer.onStopTimer();
        _isResetPressed = true;
      }
    });
  }

  void _lapOrResetTimer() {
    setState(() {
      if (_isResetPressed) {
        _stopWatchTimer.onResetTimer();
        _isResetPressed = false;
        _isShown = false;
      } else {
        _stopWatchTimer.onAddLap();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) => {});
    _stopWatchTimer.minuteTime.listen((value) => {});
    _stopWatchTimer.secondTime.listen((value) => {});
    _stopWatchTimer.records.listen((value) => {});
    _stopWatchTimer.fetchStopped.listen((value) => {});
    _stopWatchTimer.fetchEnded.listen((value) => {});

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: StudioVariables.workHeight,
      padding: const EdgeInsets.all(8.0),
      // Display stop watch time
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<int>(
            stream: _stopWatchTimer.rawTime,
            initialData: _stopWatchTimer.rawTime.value,
            builder: (context, snap) {
              final value = snap.data!;
              final displayTime = StopWatchTimer.getDisplayTime(value, hours: _isHours);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  displayTime,
                  style: const TextStyle(
                    fontSize: 40,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          // Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _startOrStopTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: !_isStartPressed ? Colors.green[200] : Colors.red[200],
                  fixedSize: const Size(64.0, 64.0),
                  shape: const CircleBorder(),
                ),
                child: Icon(
                  !_isStartPressed ? Icons.play_arrow_rounded : Icons.stop_rounded,
                  size: 28.0,
                  color: !_isStartPressed ? Colors.green[700] : Colors.red[700],
                ),
              ),
              ElevatedButton(
                onPressed: _lapOrResetTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CretaColor.text[700],
                  fixedSize: const Size(64.0, 64.0),
                  shape: const CircleBorder(),
                ),
                child: Icon(
                  !_isResetPressed ? Icons.add : Icons.refresh_sharp,
                  size: 28.0,
                  color: CretaColor.text[200],
                ),
              ),
            ],
          ),
          // Lap Time
          if (_isShown)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              height: 120.0,
              child: StreamBuilder<List<StopWatchRecord>>(
                stream: _stopWatchTimer.records,
                initialData: _stopWatchTimer.records.value,
                builder: (context, snap) {
                  final value = snap.data!;
                  if (value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      final data = value[index];
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lap ${index + 1}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    ' ${data.displayTime}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      );
                    },
                    itemCount: value.length,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
