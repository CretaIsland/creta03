// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/popup/release_note_popup.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:hycop/hycop.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:hycop/hycop.dart';

//import '../../routes.dart';
import '../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_font.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});
  static final List<String> cretaVersionList = [
    "0.6.53",
    "0.6.52",
    "0.6.51",
    "0.6.50",
    "0.6.49",
    "0.6.48",
    "0.6.47",
    "0.6.46",
    "0.6.45",
    "0.6.44",
    "0.6.43",
    "0.6.42",
    "0.6.41",
    "0.6.40",
    "0.6.39",
    "0.6.38",
    "0.6.37",
    "0.6.36",
    "0.6.35",
    "0.6.34",
    "0.6.33",
    "0.6.32",
    "0.6.31",
  ];
  static const String hycopVersion = "0.4.46";
  static final String buildNumber = "20240621-17(${HycopFactory.toServerTypeString()})";

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset('assets/landing_page_banner.mp4');
    controller.initialize().then((value) {
      setState(() {
        controller.setVolume(
            0); // 안하면 에러발생 : NotAllowedError: play() failed because the user didn't interact with the document first.
        controller.play();
        controller.setLooping(true);
      });
    });
  }
  //
  // void doAfterLogin() {
  //   print('doAfterLogin');
  //   Navigator.of(context).pop();
  //   Routemaster.of(context).push(AppRoutes.intro);
  // }
  //
  // void doAfterSignup() {
  //   print('doAfterSignup');
  //   Navigator.of(context).pop();
  // }
  //
  // void onErrorReport(String errMsg) {
  //   print('onErrorReport($errMsg)');
  //   showSnackBar(context, errMsg);
  // }

  BuildContext getBuildContext() {
    return context;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double videoWidth = width;
    double videoHeight = width * 0.5625; // 0.5625 = 1080 / 1920
    if (videoHeight > height) {
      videoHeight = height;
      videoWidth = height * 1.77; // 1.77 = 1920 / 1080
    }

    return Snippet.CretaScaffoldOfCommunity(
      //title: Text('Community page'),
      onFoldButtonPressed: () {
        setState(() {});
      },

      // title: Row(
      //   children: const [
      //     SizedBox(
      //       width: 24,
      //     ),
      //     Image(
      //       image: AssetImage('assets/creta_logo_blue.png'),
      //       //width: 120,
      //       height: 20,
      //     ),
      //   ],
      // ),
      context: context,
      // doAfterLogin: doAfterLogin,
      // doAfterSignup: doAfterSignup,
      // onErrorReport: onErrorReport,
      getBuildContext: getBuildContext,
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                width: videoWidth,
                height: videoHeight,
                child: VideoPlayer(controller),
              ),
              SizedBox(
                width: videoWidth,
                height: videoHeight,
                child: Center(
                  child: TextButton(
                    child: Text(
                      "Version ${IntroPage.cretaVersionList.first} (hycop ${IntroPage.hycopVersion}) - build ${IntroPage.buildNumber}",
                      style: CretaFont.headlineLarge,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ReleaseNoteDialog(versionList: IntroPage.cretaVersionList);
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
