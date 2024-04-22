import 'dart:async';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/material.dart';

import '../../../../../lang/creta_studio_lang.dart';
import '../../../studio_constant.dart';
import '../../../studio_variables.dart';
import 'stickerview.dart';

class MainSymbol extends StatefulWidget {
  final Sticker sticker;
  const MainSymbol({
    super.key,
    required this.sticker,
  });

  @override
  State<MainSymbol> createState() => _MainSymbolState();
}

class _MainSymbolState extends State<MainSymbol> {
  bool _mainSymbolSwitch = true;
  Timer? _mainSymbolSwitchTimer;

  @override
  void initState() {
    super.initState();
    _mainSymbolSwitchTimer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      if (widget.sticker.isMain && StudioVariables.isPreview == false) {
        setState(() {
          _mainSymbolSwitch = !_mainSymbolSwitch;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mainSymbolSwitchTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: LayoutConst.stikerOffset / 2 + 4,
      top: LayoutConst.stikerOffset / 2 + 4,
      child: SizedBox(
        width: 18,
        height: 18,
        child:
            // CircleAvatar(
            //   backgroundColor: Colors.white.withOpacity(0.5),
            //   //radius: 16,
            //   child:
            Tooltip(
          message: CretaStudioLang['mainFrameExTooltip']!,
          child: AnimatedSwitcherPlus.translationLeft(
            duration: const Duration(milliseconds: 1000),
            child: Container(
              key: ValueKey("_mainSymbolSwitch$_mainSymbolSwitch"),
              //padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  //color: _mainSymbolSwitch ? Colors.blue.shade50 : Colors.red.shade50,
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    image: AssetImage(
                        (_mainSymbolSwitch ? 'assets/expiredTime.png' : 'assets/nextPage.png')),
                    fit: BoxFit.cover,
                  )),
              // child: Center(
              //   child: Icon(
              //     _mainSymbolSwitch ? Icons.auto_stories_outlined : Icons.update_outlined,
              //     size: 16,
              //     color: CretaColor.primary,
              //   ),
              // ),
            ),
          ),
        ),

        // Icon(
        //   Icons.auto_stories_outlined,
        //   size: 16,
        //   color: CretaColor.primary,
        // ),
      ),
      //),
    );
  }
}
