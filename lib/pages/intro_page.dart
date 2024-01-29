// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/popup/release_note_popup.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:hycop/hycop.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:hycop/hycop.dart';

//import '../../routes.dart';
import '../design_system/component/snippet.dart';
import '../design_system/creta_font.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});
  static final List<String> cretaVersionList = [
    "0.5.15",
    "0.5.14",
    "0.5.13",
    "0.5.12",
    "0.5.11",
    "0.5.10",
    "0.5.09",
    "0.5.08",
    "0.5.07",
    "0.5.06",
    "0.5.05",
    "0.5.04",
    "0.5.03",
    "0.5.02",
    "0.5.01",
    "0.5.00",
  ];
  static const String hycopVersion = "0.4.17";
  static final String buildNumber = "20240129-21(${HycopFactory.toServerTypeString()})";

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
      title: Row(
        children: const [
          SizedBox(
            width: 24,
          ),
          Image(
            image: AssetImage('assets/creta_logo_blue.png'),
            //width: 120,
            height: 20,
          ),
        ],
      ),
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
