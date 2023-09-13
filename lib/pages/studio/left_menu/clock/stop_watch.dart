import 'package:creta03/design_system/creta_color.dart';
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
  bool _isStopPressed = false;
  final bool _isLapPressed = true;

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
      if (!_isStopPressed) {
        // print('_isStopPressed $_isStopPressed');
        _stopWatchTimer.onStartTimer();
      } else {
        // print('_isStopPressed $_isStopPressed');
        _stopWatchTimer.onStopTimer();
      }
      _isStopPressed = !_isStopPressed;
    });
  }

  void _lapOrResetTimer() {
    setState(() {
      if (_isLapPressed && _isStopPressed) {
        _stopWatchTimer.onAddLap();
      } else {
        _stopWatchTimer.onResetTimer();
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
                  backgroundColor: !_isStopPressed ? Colors.green[200] : Colors.red[200],
                  fixedSize: const Size(64.0, 64.0),
                  shape: const CircleBorder(),
                ),
                child: Text(
                  !_isStopPressed ? 'Start' : 'Stop',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: !_isStopPressed ? Colors.green[700] : Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _lapOrResetTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CretaColor.text[200],
                  fixedSize: const Size(64.0, 64.0),
                  shape: const CircleBorder(),
                ),
                child: Text(
                  _isLapPressed && _isStopPressed ? 'Lap' : 'Reset',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: CretaColor.text[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Lap Time
          Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            height: 150.0,
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
