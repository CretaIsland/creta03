// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:routemaster/routemaster.dart';

import '../../routes.dart';
import '../design_system/component/snippet.dart';
//import '../design_system/creta_font.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

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
        controller.setVolume(0); // 안하면 에러발생 : NotAllowedError: play() failed because the user didn't interact with the document first.
        controller.play();
        controller.setLooping(true);
      });
    });
  }

  void doAfterLogin() {
    Routemaster.of(context).push(AppRoutes.intro);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Snippet.CretaScaffoldOfCommunity(
      //title: Snippet.logo('Intro page'),
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
      // child: Center(
      //   child: Text(
      //     "Version 0.1.2 (hycop 0.2.9)",
      //     style: CretaFont.headlineLarge,
      //   ),
      // ),
      doAfterLogin: doAfterLogin,

      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              height: width * 0.5625,
              child: VideoPlayer(controller),
            ),
          ],
        ),
      ),
      // child: SizedBox(
      //   width: width,
      //   height: height,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Container(
      //         width: width,
      //         constraints: BoxConstraints(
      //           maxWidth: width,
      //           maxHeight: height,
      //         ),
      //         //height: 480,
      //         child: VideoPlayer(controller),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
