// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors
import 'dart:math';

import 'package:creta03/player/doc/creta_doc_mixin.dart';
import 'package:creta03/player/music/creta_music_mixin.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../data_io/key_handler.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../../model/frame_model_util.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../../../player/text/creta_text_mixin.dart';
import '../../book_main_page.dart';
import '../../left_menu/music/music_player_frame.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';

class ContentsThumbnail extends StatefulWidget {
  final FrameModel frameModel;
  final PageModel pageModel;
  final FrameManager frameManager;
  final ContentsManager contentsManager;
  final double width;
  final double height;
  final double applyScale;

  const ContentsThumbnail({
    super.key,
    required this.frameModel,
    required this.pageModel,
    required this.frameManager,
    required this.contentsManager,
    required this.width,
    required this.height,
    required this.applyScale,
  });

  @override
  State<ContentsThumbnail> createState() => ContentsThumbnailState();
}

class ContentsThumbnailState extends CretaState<ContentsThumbnail>
    with CretaTextMixin, CretaDocMixin, CretaMusicMixin {
  //ContentsManager? _contentsManager;
  //CretaPlayTimer? _playerHandler;
  ContentsEventController? _receiveEvent;
  ContentsEventController? _receiveTextEvent;
  //ContentsEventController? _sendEvent;

  @override
  void initState() {
    logger.fine('ContentsThumbnail initState');
    super.initState();

    final ContentsEventController receiveEvent = Get.find(tag: 'contents-property-to-main');
    _receiveEvent = receiveEvent;
    final ContentsEventController receiveTextEvent = Get.find(tag: 'text-property-to-textplayer');
    _receiveTextEvent = receiveTextEvent;
    applyScale = widget.applyScale;
  }

  @override
  void dispose() {
    logger.fine('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.contentsManager.onceDBGetComplete) {
      //logger.fine('already onceDBGetComplete');
      return _consumerFunc();
    }
    logger.fine('wait onceDBGetComplete');
    var retval = CretaManager.waitDatum(
      managerList: [widget.contentsManager],
      consumerFunc: _consumerFunc,
    );
    return retval;
  }

  bool isURINotNull(ContentsModel model) {
    return model.url.isNotEmpty || (model.remoteUrl != null && model.remoteUrl!.isNotEmpty);
  }

  Widget _consumerFunc() {
    return Consumer<ContentsManager>(builder: (context, contentsManager, child) {
      int contentsCount = contentsManager.getShowLength();

      if (widget.frameModel.isTextType()) {
        // 텍스트의 경우
        return StreamBuilder<AbsExModel>(
            stream: _receiveTextEvent!.eventStream.stream,
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data is ContentsModel) {
                ContentsModel model = snapshot.data! as ContentsModel;
                contentsManager.updateModel(model);
                logger.fine('model updated ${model.name}, ${model.url}');
              }
              //logger.fine('ContentsThumbnail StreamBuilder<AbsExModel> $contentsCount');

              if (contentsCount > 0) {
                if (widget.frameModel.isTextType()) {
                  // ContentsModel? model = contentsManager.getFirstModel();
                  ContentsModel model = contentsManager.getFirstModel()!;
                  //print(model.remoteUrl!);
                  if (model.contentsType == ContentsType.document ||
                      model.contentsType == ContentsType.pdf) {
                    // String elips = '';
                    // for (int i = 0; i < model.remoteUrl!.length; i++) {
                    //   elips += '.';
                    // }
                    String displayString =
                        model.contentsType == ContentsType.document ? 'Word Pad' : 'PDF';

                    if (_showBorder()) {
                      return DottedBorder(
                        dashPattern: const [6, 6],
                        strokeWidth: 2,
                        strokeCap: StrokeCap.round,
                        color: CretaColor.text[700]!,
                        child: Center(
                          //htmlText: model.remoteUrl!,
                          child: Text(displayString, style: CretaFont.bodyMedium),
                        ),
                      );
                    }
                    return Center(
                      //htmlText: model.remoteUrl!,
                      child: Text(displayString, style: CretaFont.bodyMedium),
                    );
                    // return AdjustedHtmlView(
                    //   htmlText: model.remoteUrl!,
                    //   htmlValidator: HtmlValidator.loose(),
                    // );
                  } else {
                    //print('widget.applyScale: ${widget.applyScale}');
                    // print(
                    //     'thumbnail playText invoked   -----${widget.frameModel.height.value}--------');
                    return playText(
                      context,
                      null,
                      model,
                      contentsManager.getRealSize(applyScale: applyScale),
                      isThumbnail: true,
                    );
                  }
                }
              }
              logger.fine('there is no contents');
              return SizedBox.shrink();
            });
      } else if (widget.frameModel.isMusicType()) {
        //print('this is music frame'); // 뮤직의 경우
        if (FrameModelUtil.isBackgroundMusic(widget.frameModel)) {
          return showBGM(applyScale);
        }
        return StreamBuilder<AbsExModel>(
            stream: _receiveEvent!.eventStream.stream,
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data is ContentsModel) {
                ContentsModel model = snapshot.data! as ContentsModel;
                contentsManager.updateModel(model);
                logger.fine('model updated ${model.name}, ${model.url}');
              }
              //logger.fine('ContentsThumbnail StreamBuilder<AbsExModel> $contentsCount');

              if (contentsCount > 0) {
                if (widget.frameModel.frameType == FrameType.music) {
                  GlobalObjectKey<MusicPlayerFrameState>? musicKey =
                      BookMainPage.musicKeyMap[widget.frameModel.mid];
                  if (musicKey == null) {
                    musicKey = GlobalObjectKey<MusicPlayerFrameState>(
                        'Music${widget.pageModel.mid}/${widget.frameModel.mid}');
                    BookMainPage.musicKeyMap[widget.frameModel.mid] = musicKey;
                  }
                  //print(model.remoteUrl!);

                  String selectedSize = '';
                  int index = 0;
                  FrameModel frameModel = widget.contentsManager.frameModel;
                  Size frameSize = Size(frameModel.width.value, frameModel.height.value);
                  for (Size ele in StudioConst.musicPlayerSize) {
                    if (frameSize == ele) {
                      selectedSize = CretaStudioLang['playerSize']!.values.toList()[index];
                      break;
                    }
                    index++;
                  }
                  List<dynamic> size = CretaStudioLang['playerSize']!.values.toList();
                  if (selectedSize == size[0]) {
                    return Container(
                      alignment: Alignment.center,
                      // child: Image.asset('bigSize_music_app.png'),
                      child: Image.asset('music-visual-big.png'),
                    );
                  } else if (selectedSize == size[1]) {
                    return Container(
                      alignment: Alignment.center,
                      // child: Image.asset('medSize_music_app.png'),
                      child: Image.asset('music-visual-med.png'),
                    );
                  } else if (selectedSize == size[2]) {
                    return Container(
                      alignment: Alignment.center,
                      // child: Image.asset('smallSize_music_app.png'),
                      child: Image.asset('music-visual-small.png'),
                    );
                  } else if (selectedSize == size[3]) {
                    return Container(
                      alignment: Alignment.center,
                      // child: Image.asset('miniSize_music_app.png'),
                      child: Image.asset('music-tiny.png'),
                    );
                  }
                  return const SizedBox.shrink();
                }
              } else {
                //print('No music contents here');
              }
              logger.fine('Music thumbnailUrl has NO content');
              return SizedBox.shrink();
            });
      }
      // 텍스트가 아닌 경우.
      return StreamBuilder<ContentsModel>(
          stream: _receiveEvent!.eventStream.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data is ContentsModel) {
              ContentsModel model = snapshot.data!;
              contentsManager.updateModel(model);
              logger.info(
                  "'contents-property-to-main' event received , model updated ${model.name}, thumbnail=${model.thumbnailUrl}, ${model.thumbnailUrl}");
            }
            if (contentsCount > 0) {
              late String thumbnailUrl;
              late String name;
              late BoxFit boxfit;
              late bool isFlip;
              late double angle;
              late double opacity;
              (name, thumbnailUrl, boxfit, isFlip, angle, opacity) = contentsManager.getThumbnail();
              if (thumbnailUrl.isNotEmpty) {
                logger.info("---------------name=$name");
                logger.info("thumbnail=$thumbnailUrl");

                Widget drawImage = Container(
                  key: GlobalObjectKey(
                      'CustomImage${widget.pageModel.mid}/${widget.frameModel.mid}$thumbnailUrl'),
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    //fit: BoxFit.cover,
                    fit: boxfit,
                    image: NetworkImage(thumbnailUrl),
                  )),
                );

                Widget opacityImage =
                    opacity < 1.0 ? Opacity(opacity: opacity, child: drawImage) : drawImage;

                Widget angleImage = angle > 0
                    ? Transform.rotate(
                        angle: CretaCommonUtils.degreeToRadian(angle),
                        child: opacityImage,
                      )
                    : opacityImage;

                return isFlip
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: angleImage)
                    : angleImage;
              } else {
                logger.warning('noThumbnail !!!');
              }
            }
            logger.fine('there is no contents');
            return SizedBox.shrink();
          });

      // 텍스트가 아닌 경우
    });
  }

  bool _showBorder() {
    if (widget.frameModel.isWeatherTYpe()) {
      return false;
    }
    return (widget.frameModel.bgColor1.value == widget.pageModel.bgColor1.value ||
            widget.frameModel.bgColor1.value == Colors.transparent) &&
        (widget.frameModel.borderWidth.value == 0 ||
            widget.frameModel.borderColor.value == widget.pageModel.bgColor1.value) &&
        (widget.frameModel.isNoShadow());
  }
}
