import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../lang/creta_studio_lang.dart';

class CretaTimelineSample1 extends StatelessWidget {
  const CretaTimelineSample1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple,
            Colors.blue,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Center(
            child: Column(
          children: [
            const Text(
              'Timeline Showcase',
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: CretaStudioLang.timelineStart.length,
                itemBuilder: (BuildContext context, int index) {
                  return TimelineTile(
                    alignment: TimelineAlign.start,
                    // lineXY: 0.3,
                    isFirst: index == 0,
                    isLast: index == CretaStudioLang.timelineStart.length - 1,
                    indicatorStyle: IndicatorStyle(
                      width: 40,
                      height: 40,
                      indicator: _IndicatorExample(number: '${index + 1}'),
                      drawGap: true,
                    ),
                    beforeLineStyle: LineStyle(
                      color: Colors.white.withOpacity(0.2),
                      thickness: 5,
                    ),
                    afterLineStyle: LineStyle(
                      color: Colors.white.withOpacity(0.2),
                      thickness: 2,
                    ),
                    // startChild: Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                    //     child: Text(
                    //       CretaStudioLang.timelineEnd[index],
                    //       style: const TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 16.0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    endChild: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                      child: Text(
                        CretaStudioLang.timelineStart[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class _IndicatorExample extends StatelessWidget {
  const _IndicatorExample({Key? key, required this.number}) : super(key: key);

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 4,
          ),
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
