import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/pages/studio/left_menu/clock/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import '../../studio_variables.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  final _isHours = true;

  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  int initialTime = 0;

  bool _isTimeStarted = false;
  bool _isPaused = false;

  late StopWatchTimer _stopWatchTimer = StopWatchTimer();

  void resetTimer() {
    _hoursController.text = '';
    _minutesController.text = '';
    _secondsController.text = '';

    setState(() {
      _isTimeStarted = false;
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

    _stopWatchTimer.setPresetTime(mSec: initialTime * 1000);

    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(0),
      // onChange: (value) => {},
      // onChangeRawSecond: (value) => {},
      // onChangeRawMinute: (value) => {},
      // onStopped: () {},
      onEnded: () {
        resetTimer();
      },
    );
  }

  @override
  void dispose() async {
    super.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: StudioVariables.workHeight,
        padding: const EdgeInsets.all(8.0),
        // Display stop watch time
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !_isTimeStarted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _hoursController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'hrs',
                            hintStyle: TextStyle(fontSize: 16.0),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: _minutesController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'min',
                            hintStyle: TextStyle(fontSize: 16.0),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: _secondsController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'sec',
                            hintStyle: TextStyle(fontSize: 16.0),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : StreamBuilder(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.value,
                    builder: (context, snapshot) {
                      final value = snapshot.data!;
                      final displayTime = StopWatchTimer.getDisplayTime(value, hours: _isHours);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          displayTime,
                          style: const TextStyle(
                            fontSize: 40.0,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!_isTimeStarted)
                    ElevatedButton(
                      onPressed: () {
                        int hours = int.tryParse(_hoursController.text) ?? 00;
                        int minutes = int.tryParse(_minutesController.text) ?? 00;
                        int seconds = int.tryParse(_secondsController.text) ?? 00;
                        int totalTime = ((hours * 60 + minutes) * 60 + seconds) * 1000;

                        _stopWatchTimer.onResetTimer();
                        _stopWatchTimer.setPresetTime(mSec: totalTime);
                        _stopWatchTimer.onStartTimer();
                        setState(() {
                          _isTimeStarted = true;
                          _isPaused = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[200],
                        fixedSize: const Size(64.0, 64.0),
                        shape: const CircleBorder(),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 32.0,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  if (_isTimeStarted && !_isPaused)
                    ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onStopTimer();
                        setState(() {
                          _isPaused = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CretaColor.text[700],
                        fixedSize: const Size(64.0, 64.0),
                        shape: const CircleBorder(),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.pause_outlined,
                          size: 28.0,
                          color: Colors.amber[700],
                        ),
                      ),
                    ),
                  if (_isTimeStarted && _isPaused)
                    ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onStartTimer();
                        setState(() {
                          _isPaused = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CretaColor.text[700],
                        fixedSize: const Size(64.0, 64.0),
                        shape: const CircleBorder(),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 32.0,
                          color: Colors.amber[700],
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      _stopWatchTimer.clearPresetTime();
                      setState(() {
                        _isTimeStarted = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CretaColor.text[700],
                      fixedSize: const Size(64.0, 64.0),
                      shape: const CircleBorder(),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close_rounded,
                        size: 28.0,
                        color: CretaColor.text[200],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
