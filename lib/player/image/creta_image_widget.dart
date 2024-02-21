// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../data_io/key_handler.dart';
import 'package:creta_common/model/app_enums.dart';
import '../../pages/studio/studio_variables.dart';
import '../creta_abs_media_widget.dart';
import 'creta_image_player.dart';

class CretaImagerWidget extends CretaAbsPlayerWidget {
  const CretaImagerWidget({super.key, required super.player});

  @override
  CretaImagePlayerWidgetState createState() => CretaImagePlayerWidgetState();
}

class CretaImagePlayerWidgetState extends CretaState<CretaImagerWidget>
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
      _aniTimer ??= Timer.periodic(const Duration(seconds: 4), (t) {
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

    Size size = player.acc.getRealSize();

    Widget drawImage = Center(
      child: Container(
        // width: size.width,
        // height: size.height,
        decoration: BoxDecoration(
            //shape: BoxShape.circle,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeft),
              topRight: Radius.circular(topRight),
              bottomLeft: Radius.circular(bottomLeft),
              bottomRight: Radius.circular(bottomRight),
            ),
            //image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(widget.model!.url))),
            //image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(uri))),

            image: DecorationImage(
                fit: player.model!.fit.value.toBoxFit(),
                image: CachedNetworkImageProvider(uri, cacheKey: uri))),
        //image: DecorationImage(fit: BoxFit.fill, image: CachedNetworkImageProvider(uri, cacheKey: uri))),
      ),
    );

    double angle = player.model!.angle.value;
    Widget angleImage = angle > 0
        ? Transform.rotate(
            angle: CretaCommonUtils.degreeToRadian(angle),
            child: drawImage,
          )
        : drawImage;

    Widget flipImage = player.model!.isFlip.value == true
        ? Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi), //  좌우를 반전시킨다.
            child: angleImage,
          )
        : angleImage;

    if (player.model!.imageAniType.value == ImageAniType.move) {
      return OverflowBox(
        maxHeight: size.height * 1.5,
        maxWidth: size.width * 1.5,
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutCubic,
          width: _animateFlag ? size.width : size.width * 1.5,
          height: _animateFlag ? size.height : size.height * 1.5,
          child: flipImage,

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

    return flipImage;
  }
}
