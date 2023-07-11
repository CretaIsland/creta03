// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../model/app_enums.dart';
import '../../pages/studio/studio_variables.dart';
import '../creta_abs_media_widget.dart';
import 'creta_image_player.dart';

class CretaImagerWidget extends CretaAbsPlayerWidget {
  const CretaImagerWidget({super.key, required super.player});

  @override
  CretaImagePlayerWidgetState createState() => CretaImagePlayerWidgetState();
}

class CretaImagePlayerWidgetState extends State<CretaImagerWidget>
    with SingleTickerProviderStateMixin {
  Timer? _aniTimer;
  bool _animateFlag = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    if (widget.player.model!.imageAniType.value == ImageAniType.move) {
      _aniTimer ??= Timer.periodic(const Duration(seconds: 6), (t) {
        setState(() {
          _animateFlag = !_animateFlag;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.stop();
    _aniTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final CretaImagePlayer player = widget.player as CretaImagePlayer;

    if (StudioVariables.isAutoPlay) {
      player.model!.setPlayState(PlayState.start);
    } else {
      player.model!.setPlayState(PlayState.pause);
    }
    //Size outSize = widget.getOuterSize(widget.model!.aspectRatio.value);

    double topLeft = player.acc.frameModel.getRealradiusLeftTop(StudioVariables.applyScale);
    double topRight = player.acc.frameModel.getRealradiusRightTop(StudioVariables.applyScale);
    double bottomLeft = player.acc.frameModel.getRealradiusLeftBottom(StudioVariables.applyScale);
    double bottomRight = player.acc.frameModel.getRealradiusRightBottom(StudioVariables.applyScale);

    String uri = player.model!.getURI();
    String errMsg = '${player.model!.name} uri is null';
    if (uri.isEmpty) {
      logger.fine(errMsg);
    }
    logger.fine("uri=<$uri>");
    player.buttonIdle();

    // return ClipRRect(
    //   borderRadius: BorderRadius.only(
    //     topRight: Radius.circular(topRight),
    //     topLeft: Radius.circular(topLeft),
    //     bottomRight: Radius.circular(bottomRight),
    //     bottomLeft: Radius.circular(bottomLeft),
    //   ),
    //   child: SizedBox.expand(
    //     child: FittedBox(
    //       alignment: Alignment.center,
    //       fit: BoxFit.cover,
    //       child: SizedBox(
    //         width: outSize.width,
    //         height: outSize.height,
    //         child: uri.isEmpty
    //             ? noImage(errMsg)
    //             : Image.network(
    //                 uri,
    //                 fit: BoxFit.cover,
    //                 errorBuilder: (context, error, stackTrace) {
    //                   errMsg = '${widget.model!.name} ${error.toString()}';
    //                   logger.fine(errMsg);
    //                   return noImage(errMsg);
    //                 },
    //               ),
    //       ),
    //     ),
    //   ),
    // );

    Widget drawImage = Container(
      decoration: BoxDecoration(
          //shape: BoxShape.circle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft),
            topRight: Radius.circular(topRight),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
          ),
          //image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(widget.model!.url))),
          image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(uri))),
    );

    if (player.model!.imageAniType.value == ImageAniType.move) {
      Size size = player.acc.getRealSize();
      return OverflowBox(
        maxHeight: size.height * 1.5,
        maxWidth: size.width * 1.5,
        child: AnimatedContainer(
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOutCubic,
          width: _animateFlag ? size.width : size.width * 1.5,
          height: _animateFlag ? size.height : size.height * 1.5,
          child: drawImage,

          // child: Stack(
          //   children: [
          //     Transform.translate(
          //       offset: const Offset(5, 5),
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(3),
          //         child: Opacity(
          //           opacity: 0.5,
          //           child: drawImage,
          //         ),
          //       ),
          //     ),
          //     Positioned.fill(
          //       child: BackdropFilter(
          //         filter: ImageFilter.blur(
          //           sigmaX: 3,
          //           sigmaY: 3,
          //         ),
          //         child: Container(color: Colors.transparent),
          //       ),
          //     ),
          //     ClipRRect(
          //       borderRadius: BorderRadius.circular(3),
          //       child: drawImage,
          //     ),
          //   ],
          // ),
        ),
      );
    }

    return drawImage;
  }
}
