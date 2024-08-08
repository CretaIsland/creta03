// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields
import 'package:creta_common/common/creta_const.dart';
import 'package:provider/provider.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/pages/studio/left_menu/music/music_player_frame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:uuid/uuid.dart';
import 'package:neonpen/neonpen.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_ex_slider.dart';
import '../../../../design_system/buttons/creta_tab_button.dart';
import '../../../../design_system/buttons/creta_toggle_button.dart';
import '../../../../design_system/component/creta_proprty_slider.dart';
import '../../../../design_system/component/time_input_widget.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../design_system/extra_text_style.dart';
import '../../../../design_system/menu/creta_drop_down_button.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import '../../../../player/text/creta_text_switcher.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../../studio_snippet.dart';
import '../../studio_variables.dart';
import '../property_mixin.dart';

class ContentsProperty extends StatefulWidget {
  final ContentsModel model;
  final FrameManager frameManager;
  final BookModel? book;
  const ContentsProperty(
      {super.key, required this.model, required this.frameManager, required this.book});

  @override
  State<ContentsProperty> createState() => _ContentsPropertyState();
}

class _ContentsPropertyState extends State<ContentsProperty> with PropertyMixin {
  ContentsManager? _contentsManager;

  // static bool _isInfoOpen = false;
  //static bool _isLinkControlOpen = false;
  static bool _isPlayControlOpen = false;
  //static bool _isTextFontColorOpen = false;
  static bool _textAIOpen = false;
  static bool _isTextBorderOpen = false;
  static bool _isMusicAudioControl = false;
  static bool _isTextAni = false;

  // static bool _isImageFilterOpen = false;

  ContentsEventController? _sendEvent;
  //ContentsEventController? _receiveEvent;
  //OffsetEventController? _linkSendEvent;
  //BoolEventController? _linkReceiveEvent;

  bool _tagEnabled = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    logger.finest('_ContentsPropertyState.initState');

    super.initMixin();
    super.initState();

    final ContentsEventController sendEvent = Get.find(tag: 'contents-property-to-main');
    final ContentsEventController sendEventText = Get.find(tag: 'text-property-to-textplayer');

    if (widget.model.isText()) {
      _sendEvent = sendEventText;
    } else {
      _sendEvent = sendEvent;
    }

    // final OffsetEventController linkSendEvent = Get.find(tag: 'on-link-to-link-widget');
    // _linkSendEvent = linkSendEvent;

    // final BoolEventController linkReceiveEvent = Get.find(tag: 'link-widget-to-property');
    // _linkReceiveEvent = linkReceiveEvent;
    //final ContentsEventController receiveEvent = Get.find(tag: 'contents-main-to-property');
    //_receiveEvent = receiveEvent;

    _contentsManager = widget.frameManager.getContentsManager(widget.model.parentMid.value);
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  bool isAuthor() =>
      widget.book != null && widget.book!.creator == AccountManager.currentLoginUser.email;

  @override
  Widget build(BuildContext context) {
    //FrameModel frameModel = _contentsManager!.frameModel;
    bool isNormalText = (widget.model.isText() && widget.model.textType == TextType.normal);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContentsManager>.value(
          value: _contentsManager!,
        ),
      ],
      child: Column(children: [
        // propertyDivider(height: 28),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       ..._info(),
        //     ],
        //   ),
        // ),
        // propertyDivider(height: 28),
        // Padding(
        //   padding: EdgeInsets.only(
        //       left: horizontalPadding, right: horizontalPadding - (isAuthor() ? 16 : 0)),
        //   child: _copyRight(),
        // ),

        if (!widget.model.isMusic()) propertyDivider(height: 28),
        // if (!widget.model.isText() && !widget.model.isMusic()) _linkControl(),
        // if (!widget.model.isText() && !widget.model.isMusic()) propertyDivider(height: 28),
        if (!widget.model.isText() && !widget.model.isMusic()) _imageControl(),
        if (widget.model.isText()) _textFontColor(),
        if (!widget.model.isMusic()) propertyDivider(height: 28),
        if (widget.model.isImage()) _imageFilter(),
        if (isNormalText) _textBorder(),
        if (isNormalText) propertyDivider(height: 28),
        if (isNormalText) _textAni(),
        if (isNormalText) propertyDivider(height: 28),
        if (isNormalText) _textAI(),
        if (isNormalText) propertyDivider(height: 28),
        if (widget.model.isMusic()) _musicAudioControl(),
        if (widget.model.isMusic() || widget.model.isImage()) propertyDivider(height: 28),
        _infoUrl(),
        propertyDivider(height: 28),
        _hashTag(),
      ]),
    );
    //});
  }

  Widget _musicAudioControl() {
    String musicMuted;
    if (_contentsManager!.frameModel.mute.value == true) {
      musicMuted = CretaStudioLang["mute"]; //'음소거'; //muted
    } else {
      musicMuted = CretaStudioLang["unmute"]; //'음소거 해제'; //unmuted
    }
    String trails = '${_contentsManager!.frameModel.volume.value.round()}, $musicMuted';
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
      child: propertyCard(
        isOpen: _isMusicAudioControl,
        onPressed: () {
          setState(() {
            _isMusicAudioControl = !_isMusicAudioControl;
          });
        },
        titleWidget: Text(CretaStudioLang['musicAudioControl']!, style: CretaFont.titleSmall),
        trailWidget: Text(trails, style: CretaFont.bodySmall),
        hasRemoveButton: false,
        onDelete: () {},
        bodyWidget: _musicAudioSettingBody(),
      ),
    );
  }

  Widget _musicAudioSettingBody() {
    return Column(
      children: [
        _musicVolSlider(),
        _musicMutedBody(),
      ],
    );
  }

  Widget _musicMutedBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: propertyLine(
        name: CretaStudioLang['musicMutedControl']!,
        widget: _musicMutedToggle(),
      ),
    );
  }

  Widget _musicMutedToggle() {
    bool isMusicMuted = _contentsManager!.frameModel.mute.value;
    return CretaToggleButton(
      key: GlobalObjectKey('_musicMutedToggle$isMusicMuted${widget.model.mid}'),
      width: 54 * 0.75,
      height: 28 * 0.75,
      defaultValue: isMusicMuted,
      onSelected: (value) {
        isMusicMuted = value;
        GlobalObjectKey<MusicPlayerFrameState>? musicKey =
            BookMainPage.musicKeyMap[widget.model.parentMid.value];
        if (musicKey != null) {
          if (_contentsManager!.frameModel.mute.value == false) {
            musicKey.currentState?.mutedMusic(widget.model);
          } else {
            musicKey.currentState?.resumedMusic(widget.model);
          }
        } else {
          logger.severe('musicKey is null');
        }
        widget.frameManager.notify();
        setState(() {});
        // }
      },
    );
  }

  Widget _musicVolSlider() {
    double minVol = 0.0;
    double maxVol = 100.0;
    double musicVol = _contentsManager!.frameModel.volume.value;

    if (musicVol < minVol) {
      musicVol = minVol;
    } else if (musicVol > maxVol) {
      musicVol = maxVol;
    }
    return propertyLine(
      name: CretaStudioLang['musicVol']!,
      widget: CretaExSlider(
        valueType: SliderValueType.normal,
        value: musicVol,
        textType: CretaTextFieldType.number,
        min: minVol,
        max: maxVol,
        onChanngeComplete: (val) {
          GlobalObjectKey<MusicPlayerFrameState>? musicKey =
              BookMainPage.musicKeyMap[widget.model.parentMid.value];
          if (musicKey != null) {
            musicKey.currentState?.adjustVol(widget.model, val);
          } else {
            logger.severe('musicKey is null');
          }
          widget.frameManager.notify();
        },
        onChannged: (val) {
          GlobalObjectKey<MusicPlayerFrameState>? musicKey =
              BookMainPage.musicKeyMap[widget.model.parentMid.value];
          if (musicKey != null) {
            musicKey.currentState?.adjustVol(widget.model, val);
          } else {
            logger.severe('musicKey is null');
          }
          // _contentsManager!.frameModel.volume.set(val);
          widget.frameManager.notify();
        },
      ),
    );
  }

  Widget _textFontColor() {
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
      child: colorPropertyCard(
        title: CretaLang['fontColor']!,
        color1: widget.model.fontColor.value,
        color2: widget.model.fontColor.value,
        opacity: widget.model.opacity.value,
        gradationType: GradationType.none,
        cardOpenPressed: () {
          setState(() {});
        },
        onOpacityDragComplete: (value) {
          //setState(() {
          widget.model.opacity.set(value);
          ExtraTextStyle.setLastTextStyle(
            widget.model.makeTextStyle(context, applyScale: StudioVariables.applyScale),
            widget.model,
          );

          _contentsManager?.notify();
          if (widget.model.textType == TextType.clock || widget.model.textType == TextType.date) {
            widget.frameManager.notify();
          }
          //_sendEvent!.sendEvent(widget.model);
        },
        onOpacityDrag: (value) {
          widget.model.opacity.set(value);
          _contentsManager?.notify();
          //_sendEvent!.sendEvent(widget.model);
          ExtraTextStyle.setLastTextStyle(
              widget.model.makeTextStyle(context, applyScale: StudioVariables.applyScale),
              widget.model);
        },
        onColor1Changed: (color) {
          setState(() {
            widget.model.fontColor.set(color);
            ExtraTextStyle.setLastTextStyle(
                widget.model.makeTextStyle(context, applyScale: StudioVariables.applyScale),
                widget.model);
          });
          //_contentsManager?.notify();
          _sendEvent!.sendEvent(widget.model);
          if (widget.model.textType == TextType.clock) {
            widget.frameManager.notify();
          }
        },
        onColorIndicatorClicked: () {
          PropertyMixin.isColorOpen = true;
          setState(() {});
        },
        onDelete: () {
          setState(() {
            widget.model.fontColor.set(Colors.black);
            ExtraTextStyle.setLastTextStyle(
              widget.model.makeTextStyle(context, applyScale: StudioVariables.applyScale),
              widget.model,
            );
          });
          _sendEvent!.sendEvent(widget.model);
          if (widget.model.textType == TextType.clock) {
            widget.frameManager.notify();
          }
        },
      ),
      //   propertyCard(
      //     isOpen: _isTextFontColorOpen,
      //     onPressed: () {
      //       setState(() {
      //         _isTextFontColorOpen = !_isTextFontColorOpen;
      //       });
      //     },
      //     titleWidget: Text(CretaLang['fontColor']!, style: CretaFont.titleSmall),
      //     //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
      //     trailWidget: Text(
      //       '${CretaCommonUtils.extractColorString(widget.model.fontColor.value.toString())},${(1 - widget.model.opacity.value) * 100}%',
      //       textAlign: TextAlign.right,
      //       style: CretaFont.titleSmall.copyWith(
      //         overflow: TextOverflow.fade,
      //         color: widget.model.fontColor.value.withOpacity(widget.model.opacity.value),
      //         fontFamily: widget.model.font.value,
      //         fontWeight: StudioConst.fontWeight2Type[widget.model.fontWeight.value],
      //       ),
      //     ),
      //     hasRemoveButton: false,
      //     onDelete: () {},
      //     bodyWidget: _fontColorBody(),
      //   ),
    );
  }

  // Widget _fontColorBody() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       propertyLine(
  //         // fontColor
  //         name: CretaStudioLang['color']!,
  //         widget: colorIndicator(
  //           widget.model.fontColor.value,
  //           widget.model.opacity.value,
  //           onColorChanged: (color) {
  //             setState(() {
  //               widget.model.fontColor.set(color);
  //             });
  //             //_contentsManager?.notify();
  //             _sendEvent!.sendEvent(widget.model);
  //           },
  //           onClicked: () {},
  //         ),
  //       ),
  //       propertyLine(
  //         // Opacity
  //         name: CretaStudioLang['opacity']!,
  //         widget: CretaExSlider(
  //           valueType: SliderValueType.reverse,
  //           value: widget.model.opacity.value,
  //           min: 0,
  //           max: 100,
  //           onChanngeComplete: (val) {
  //             //setState(() {
  //             widget.model.opacity.set(val);
  //             //});
  //             _contentsManager?.notify();
  //             //_sendEvent!.sendEvent(widget.model);
  //           },
  //           onChannged: (val) {
  //             widget.model.opacity.set(val);
  //             _contentsManager?.notify();
  //             //_sendEvent!.sendEvent(widget.model);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _textAI() {
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
      child: propertyCard(
        isOpen: _textAIOpen,
        onPressed: () {
          setState(() {
            _textAIOpen = !_textAIOpen;
          });
        },
        titleWidget: Text(CretaLang['fontAI']!, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: Text(StudioConst.code2LangMap[widget.model.lang.value]!,
            textAlign: TextAlign.right,
            // style: CretaFont.titleSmall.copyWith(
            //   overflow: TextOverflow.fade,
            //   color: widget.model.fontColor.value,
            //   fontFamily: widget.model.font.value,
            //   fontWeight: StudioConst.fontWeight2Type[widget.model.fontWeight.value],
            // ),
            style: DefaultTextStyle.of(context).style.copyWith(
                overflow: TextOverflow.fade,
                fontFamily: widget.model.font.value,
                //color: widget.model.fontColor.value.withOpacity(widget.model.opacity.value),
                decoration: (widget.model.isUnderline.value && widget.model.isStrike.value)
                    ? TextDecoration.combine([TextDecoration.underline, TextDecoration.lineThrough])
                    : widget.model.isUnderline.value
                        ? TextDecoration.underline
                        : widget.model.isStrike.value
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                //fontWeight: model!.isBold.value ? FontWeight.bold : FontWeight.normal,
                fontWeight: CretaConst.fontWeight2Type[widget.model.fontWeight.value],
                fontStyle: widget.model.isItalic.value ? FontStyle.italic : FontStyle.normal)),
        hasRemoveButton: false,
        onDelete: () {},
        bodyWidget: _fontControlBody(),
      ),
    );
  }

  Widget _fontControlBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //_fontDecoBar(),
        // propertyLine(
        //   // letterSpacing  자간
        //   name: CretaStudioLang['letterSpacing']!,
        //   widget: CretaExSlider(
        //     valueType: SliderValueType.normal,
        //     value: widget.model.letterSpacing.value,
        //     textType: CretaTextFieldType.number,
        //     min: -10,
        //     max: 10,
        //     onChanngeComplete: (val) {
        //       //setState(() {
        //       widget.model.letterSpacing.set(val);
        //       //});
        //       _contentsManager?.notify();
        //       //_sendEvent!.sendEvent(widget.model);
        //     },
        //     onChannged: (val) {
        //       widget.model.letterSpacing.set(val);
        //       _contentsManager?.notify();
        //       //_sendEvent!.sendEvent(widget.model);
        //     },
        //   ),
        // ),
        // propertyLine(
        //   // lineHeight  행간
        //   name: CretaStudioLang['lineHeight']!,
        //   widget: CretaExSlider(
        //     valueType: SliderValueType.normal,
        //     textType: CretaTextFieldType.number,
        //     value: widget.model.lineHeight.value,
        //     min: 0,
        //     max: 100,
        //     onChanngeComplete: (val) {
        //       //setState(() {
        //       widget.model.lineHeight.set(val);
        //       //});
        //       _contentsManager?.notify();
        //       //_sendEvent!.sendEvent(widget.model);
        //     },
        //     onChannged: (val) {
        //       widget.model.lineHeight.set(val);
        //       _contentsManager?.notify();
        //       //_sendEvent!.sendEvent(widget.model);
        //     },
        //   ),
        // ),
        // propertyLine(
        //   // scaleFactor  장평
        //   name: CretaStudioLang['scaleFactor']!,
        //   widget: CretaExSlider(
        //     postfix: '%',
        //     valueType: SliderValueType.normal,
        //     textType: CretaTextFieldType.number,
        //     value: widget.model.scaleFactor.value,
        //     min: 50,
        //     max: 200,
        //     onChanngeComplete: (val) {
        //       //setState(() {
        //       widget.model.scaleFactor.set(val);
        //       //});
        //       _contentsManager?.notify();
        //       //_sendEvent!.sendEvent(widget.model);
        //     },
        //     onChannged: (val) {
        //       widget.model.scaleFactor.set(val);
        //       _contentsManager?.notify();
        //       //_sendEvent!.sendEvent(widget.model);
        //     },
        //   ),
        // ),
        _translateRow(widget.model),
        propertyLine(
          // TTS
          topPadding: 10,
          name: CretaStudioLang['tts']!,
          widget: CretaToggleButton(
            width: 54 * 0.75,
            height: 28 * 0.75,
            defaultValue: widget.model.isTTS.value,
            onSelected: (value) {
              mychangeStack.startTrans();
              widget.model.isTTS.set(value);
              widget.model.mute.set(!value);
              mychangeStack.endTrans();
              _contentsManager?.notify();
              setState(() {});
            },
          ),
        ),
        if (widget.model.isTTS.value) const SizedBox(height: 14),
        if (widget.model.isTTS.value) _textDurationWidget(widget.model),
        // CretaFontSelector(
        //   // 폰트, 폰트 weight
        //   defaultFont: widget.model.font.value,
        //   defaultFontWeight: widget.model.fontWeight.value,
        //   onFontChanged: (val) {
        //     if (val != widget.model.font.value) {
        //       widget.model.fontWeight.set(400); // 폰트가 변경되면, weight 도 초기화
        //       widget.model.font.set(val);

        //       logger.fine('save ${widget.model.mid}-----------------');
        //       logger.fine('save ${widget.model.font.value}----------');
        //       _sendEvent!.sendEvent(widget.model);
        //     }
        //   },
        //   onFontWeightChanged: (val) {
        //     if (val != widget.model.fontWeight.value) {
        //       widget.model.fontWeight.set(val);
        //       _sendEvent!.sendEvent(widget.model);
        //     }
        //   },
        //   textStyle: dataStyle,
        // ),
        // propertyLine(
        //   // 프레임 크기에 자동 맞춤
        //   name: CretaStudioLang['autoSizeFont']!,
        //   widget: CretaToggleButton(
        //     width: 54 * 0.75,
        //     height: 28 * 0.75,
        //     defaultValue: widget.model.isAutoSize.value,
        //     onSelected: (value) {
        //       widget.model.isAutoSize.set(value);
        //       _sendEvent!.sendEvent(widget.model);
        //       setState(() {});
        //     },
        //   ),
        // ),
        //if (widget.model.isAutoSize.value == false) _fontSizeArea2(),
      ],
    );
  }

  // Widget _fontDecoBar() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 20),
  //     child: CretaFontDecoBar(
  //       bold: widget.model.isBold.value,
  //       italic: widget.model.isItalic.value,
  //       underline: widget.model.isUnderline.value,
  //       strike: widget.model.isStrike.value,
  //       toggleBold: (val) {
  //         widget.model.isBold.set(val);
  //         _sendEvent!.sendEvent(widget.model);
  //       },
  //       toggleItalic: (val) {
  //         widget.model.isItalic.set(val);
  //         _sendEvent!.sendEvent(widget.model);
  //       },
  //       toggleUnderline: (val) {
  //         widget.model.isUnderline.set(val);
  //         _sendEvent!.sendEvent(widget.model);
  //       },
  //       toggleStrikethrough: (val) {
  //         widget.model.isStrike.set(val);
  //         _sendEvent!.sendEvent(widget.model);
  //       },
  //     ),
  //   );
  // }

  Widget _translateRow(ContentsModel model) {
    return propertyLine(
      topPadding: 10,
      name: CretaStudioLang['translate']!,
      widget: CretaDropDownButton(
        align: MainAxisAlignment.start,
        selectedColor: CretaColor.text[700]!,
        textStyle: dataStyle,
        width: 200,
        height: 36,
        itemHeight: 24,
        dropDownMenuItemList: CretaUtils.getLangItem(
            defaultValue: model.lang.value,
            onChanged: (val) async {
              model.lang.set(val);
              if (model.remoteUrl != null) {
                Translation result = await model.remoteUrl!.translate(to: model.lang.value);
                model.remoteUrl = result.text;
                model.url = result.text;
                model.name = result.text;
                model.save();
              }
              _contentsManager?.notify();
              setState(() {});
            }),
      ),
    );
  }

  Widget _textDurationWidget(ContentsModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(CretaLang['playDuration']!, style: titleStyle),
          if (model.playTime.value >= 0)
            TimeInputWidget(
              textWidth: 30,
              textStyle: titleStyle,
              initValue: (model.playTime.value / 1000).round(),
              onValueChnaged: (duration) {
                logger.fine('save : ${model.mid}');
                model.playTime.set(duration.inSeconds * 1000.0);
                _contentsManager?.notify();
              },
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(CretaLang['onlyOnce']!, style: titleStyle),
              ),
              CretaToggleButton(
                  width: 54 * 0.75,
                  height: 28 * 0.75,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        //model.reservPlayTime();
                        model.playTime.set(-1);
                      } else {
                        model.playTime.set(3000);
                        //model.resetPlayTime();
                      }
                    });
                    _contentsManager?.notify();
                  },
                  defaultValue: model.playTime.value < 0),
            ],
          )
        ],
      ),
    );
  }

  // Widget _fontSizeArea2() {
  //   return propertyLine2(
  //     // 프레임 크기에 자동 맞춤
  //     widget1: CretaDropDownButton(
  //       align: MainAxisAlignment.start,
  //       selectedColor: CretaColor.text[700]!,
  //       textStyle: dataStyle,
  //       width: 176,
  //       height: 36,
  //       itemHeight: 24,
  //       dropDownMenuItemList: _getFontSizeItem(
  //           defaultValue: widget.model.fontSizeType.value,
  //           onChanged: (val) {
  //             widget.model.fontSizeType.set(val);
  //             if (FontSizeType.userDefine != widget.model.fontSizeType.value) {
  //               widget.model.fontSize.set(FontSizeType.enumToVal[val]!);
  //             }
  //             _sendEvent!.sendEvent(widget.model);
  //             setState(() {});
  //           }),
  //     ),
  //     widget2: CretaExSlider(
  //       //disabled: widget.model.fontSizeType.value != FontSizeType.userDefine,
  //       key: GlobalKey(),
  //       min: 6,
  //       max: CretaConst.maxFontSize,
  //       value: widget.model.fontSize.value,
  //       valueType: SliderValueType.normal,
  //       sliderWidth: 136,
  //       onChanngeComplete: (val) {
  //         setState(() {
  //           widget.model.fontSize.set(val);
  //           FontSizeType? fontSyzeType = FontSizeType.valToEnum[val];
  //           if (fontSyzeType == null ||
  //               fontSyzeType == FontSizeType.userDefine ||
  //               fontSyzeType == FontSizeType.none ||
  //               fontSyzeType == FontSizeType.end) {
  //             if (widget.model.fontSizeType.value != FontSizeType.userDefine) {
  //               widget.model.fontSizeType.set(FontSizeType.userDefine);
  //             }
  //           } else {
  //             if (widget.model.fontSizeType.value != fontSyzeType) {
  //               widget.model.fontSizeType.set(fontSyzeType);
  //             }
  //           }
  //           _sendEvent!.sendEvent(widget.model);
  //         });
  //       },
  //       onChannged: (val) {
  //         widget.model.fontSize.set(val);
  //         _sendEvent!.sendEvent(widget.model);
  //       },
  //     ),
  //   );
  // }

  // List<CretaMenuItem> _getFontSizeItem(
  //     {required FontSizeType defaultValue, required void Function(FontSizeType) onChanged}) {
  //   return CretaStudioLang['textSizeMap']!.keys.map(
  //     (sizeStr) {
  //       double sizeVal = CretaStudioLang['textSizeMap']![sizeStr]!;
  //       double currentVal = FontSizeType.enumToVal[defaultValue]!;
  //       return CretaMenuItem(
  //           caption: sizeStr,
  //           onPressed: () {
  //             onChanged(FontSizeType.valToEnum[sizeVal]!);
  //           },
  //           selected: sizeVal == currentVal);
  //     },
  //   ).toList();
  // }

  Widget _imageControl() {
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
      child: propertyCard(
        isOpen: _isPlayControlOpen,
        onPressed: () {
          setState(() {
            _isPlayControlOpen = !_isPlayControlOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['imageControl']!, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: Text(
          _trailString(),
          textAlign: TextAlign.right,
          style: CretaFont.titleSmall.copyWith(overflow: TextOverflow.fade),
        ),
        hasRemoveButton: false,
        onDelete: () {},
        bodyWidget: _imageControlBody(),
      ),
    );
  }

  String _trailString() {
    int idx = widget.model.fit.value.index;
    if (idx > ContentsFitType.none.index && idx < ContentsFitType.end.index) {
      return CretaStudioLang['fitList']!.keys.toList()[idx - 1];
    }
    return '';
  }

  Widget _imageControlBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CretaPropertySlider(
            // 투명도
            key: GlobalKey(),
            name: CretaStudioLang['opacity']!,
            min: 0,
            max: 100,
            value: CretaCommonUtils.validCheckDouble(widget.model.opacity.value, 0, 1),
            valueType: SliderValueType.reverse,
            onChannged: (value) {
              // widget.model.opacity.set(value);
              // //widget.model.save();
              // logger.fine('opacity=${widget.model.opacity.value}');
              // _sendEvent!.sendEvent(widget.model);
            },
            onChanngeComplete: (value) {
              //print('opacity = $value');
              widget.model.opacity.set(value);
              //widget.model.save();
              logger.fine('opacity=${widget.model.opacity.value}');
              //_contentsManager!.invalidatePlayerWidget(widget.model);
              // opacity 의 위치상, 여기서는 contentsMain 을 setState 해야한다.
              _invalidateContentsMain();
              _invalidateContentsThumb();
              //_sendEvent!.sendEvent(widget.model);
            },
            postfix: '%',
          ),
          //  피팅 fitting
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(CretaStudioLang['fitting']!, style: titleStyle),
                Consumer<ContentsManager>(builder: (context, contentsManager, child) {
                  return CretaTabButton(
                    key: ValueKey('fit${widget.model.mid}/${widget.model.fit.value}'),
                    onEditComplete: (value) {
                      int idx = 1;
                      for (String val in CretaStudioLang['fitList']!.values) {
                        if (value == val) {
                          widget.model.fit.set(ContentsFitType.values[idx]);
                          break;
                        }
                        idx++;
                      }
                      _contentsManager!.invalidatePlayerWidget(widget.model);
                      _invalidateContentsThumb();
                      //_sendEvent!.sendEvent(widget.model);
                    },
                    width: 75,
                    height: 24,
                    selectedTextColor: CretaColor.primary,
                    unSelectedTextColor: CretaColor.text[700]!,
                    selectedColor: Colors.white,
                    unSelectedColor: CretaColor.text[100]!,
                    selectedBorderColor: CretaColor.primary,
                    defaultString: _getFit(),
                    buttonLables: CretaStudioLang['fitList']!.keys.toList(),
                    buttonValues: [...CretaStudioLang['fitList']!.values.toList()],
                  );
                }),
              ],
            ),
          ),
          propertyLine(
            // 좌우반전
            name: CretaStudioLang['flip']!,
            widget: Consumer<ContentsManager>(builder: (context, contentsManager, child) {
              return CretaToggleButton(
                key: ValueKey('isFlip${widget.model.mid}/${widget.model.isFlip.value}'),
                width: 54 * 0.75,
                height: 28 * 0.75,
                defaultValue: widget.model.isFlip.value,
                onSelected: (value) {
                  widget.model.isFlip.set(value);
                  _contentsManager!.invalidatePlayerWidget(widget.model);
                  _invalidateContentsThumb();
                  //_sendEvent!.sendEvent(widget.model);
                  setState(() {});
                },
              );
            }),
          ),
          propertyLine(
            // 회전 각도
            name: CretaStudioLang['rotateConTooltip']!,
            widget: Consumer<ContentsManager>(builder: (context, contentsManager, child) {
              return RepaintBoundary(
                child: CretaExSlider(
                  //key: ValueKey('angle${widget.model.mid}/${widget.model.angle.value}'),
                  valueType: SliderValueType.normal,
                  value: widget.model.angle.value,
                  min: 0,
                  max: 360,
                  onChanngeComplete: (val) {
                    widget.model.angle.set(val);
                    _contentsManager!.invalidatePlayerWidget(widget.model);

                    //_sendEvent!.sendEvent(widget.model);
                    setState(() {});
                  },
                  onChannged: (val) {
                    widget.model.angle.set(val);
                    _contentsManager!.invalidatePlayerWidget(widget.model);
                    _invalidateContentsThumb();
                    //_sendEvent!.sendEvent(widget.model);
                    setState(() {});
                  },
                ),
              );
            }),
          ),
          if (widget.model.isImage())
            propertyLine(
              // 이미지 AniType
              name: CretaStudioLang['ani']!,
              widget: CretaToggleButton(
                width: 54 * 0.75,
                height: 28 * 0.75,
                defaultValue: widget.model.imageAniType.value == ImageAniType.move ? true : false,
                onSelected: (value) {
                  widget.model.imageAniType.set(value ? ImageAniType.move : ImageAniType.none);
                  _contentsManager!.invalidatePlayerWidget(widget.model);
                  _invalidateContentsThumb();
                  //_sendEvent!.sendEvent(widget.model);
                  setState(() {});
                },
              ),
            ),
        ],
      ),
    );
  }

  String _getFit() {
    switch (widget.model.fit.value) {
      case ContentsFitType.cover:
        return 'cover';
      case ContentsFitType.fill:
        return 'fill';
      case ContentsFitType.free:
        return 'free';
      default:
        return 'cover';
    }
  }

  Widget _imageFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: imageFilterCard(
        imageFilterType: widget.model.filter.value,
        onPressed: () {
          setState(() {});
        },
        onImageFilterChanged: (val) {
          setState(() {
            widget.model.filter.set(val);
          });
          //_sendEvent!.sendEvent(widget.model);
          _contentsManager!.invalidatePlayerWidget(widget.model);
          _invalidateContentsThumb();
        },
        onDelete: () {
          setState(() {
            widget.model.filter.set(ImageFilterType.none);
          });
          //_sendEvent!.sendEvent(widget.model);
          _contentsManager!.invalidatePlayerWidget(widget.model);
          _invalidateContentsThumb();
        },
      ),
    );
  }

  Widget _textBorder() {
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
      child: propertyCard(
        isOpen: _isTextBorderOpen,
        onPressed: () {
          setState(() {
            _isTextBorderOpen = !_isTextBorderOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['border']!, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: Text(
          'A',
          textAlign: TextAlign.right,
          style: widget.model.outLineWidth.value > 0
              ? CretaFont.titleSmall.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = widget.model.outLineWidth.value / 10
                    ..color = widget.model.outLineColor.value,
                )
              : CretaFont.titleSmall,
        ),
        hasRemoveButton: widget.model.outLineWidth.value > 0,
        onDelete: () {
          setState(() {
            widget.model.outLineWidth.set(0);
          });
          _sendEvent!.sendEvent(widget.model);
        },
        bodyWidget: _textBorderBody(),
      ),
    );
  }

  Widget _textBorderBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        propertyLine(
          // 테두리 색
          name: CretaStudioLang['color']!,
          widget: colorIndicator(
            widget.model.outLineColor.value,
            widget.model.opacity.value,
            onColorChanged: (color) {
              //setState(() {
              widget.model.outLineColor.set(color);
              //});
              _sendEvent!.sendEvent(widget.model);
            },
            onClicked: () {},
          ),
        ),
        propertyLine(
          // 테두리 두께
          name: CretaStudioLang['outlineWidth']!,
          widget: CretaExSlider(
            valueType: SliderValueType.normal,
            value: widget.model.outLineWidth.value,
            min: 0,
            max: 36,
            onChanngeComplete: (val) {
              //setState(() {
              widget.model.outLineWidth.set(val);
              //});
              _contentsManager?.notify();
              //_sendEvent!.sendEvent(widget.model);
            },
            onChannged: (val) {
              widget.model.outLineWidth.set(val);
              _contentsManager?.notify();
              //_sendEvent!.sendEvent(widget.model);
            },
          ),
        ),
      ],
    );
  }

  // Widget _linkControl() {
  //   bool isLinkEditMode = widget.model.isLinkEditMode;
  //   return StreamBuilder<bool>(
  //       stream: _linkReceiveEvent!.eventStream.stream,
  //       builder: (context, snapshot) {
  //         if (snapshot.data != null && snapshot.data is bool) {
  //           if (snapshot.data != null) {
  //             isLinkEditMode = snapshot.data!;
  //           }
  //         }
  //         logger.fine('_linkControl ($isLinkEditMode)');
  //         // if (offset == Offset.zero) {
  //         //   return const SizedBox.shrink();
  //         // }
  //         return Padding(
  //           padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
  //           child: propertyCard(
  //             isOpen: _isLinkControlOpen,
  //             onPressed: () {
  //               setState(() {
  //                 _isLinkControlOpen = !_isLinkControlOpen;
  //               });
  //             },
  //             titleWidget: Text(CretaStudioLang['linkControl']!, style: CretaFont.titleSmall),
  //             //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
  //             trailWidget: _linkToggle(isLinkEditMode),
  //             hasRemoveButton: false,
  //             onDelete: () {},
  //             bodyWidget: _linkControlBody(isLinkEditMode),
  //           ),
  //         );
  //       });
  // }

  // Widget _linkControlBody(bool isLinkEditMode) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 16.0),
  //     child: propertyLine(
  //       // 링크 편집 모드
  //       name: CretaStudioLang['linkControl']!,
  //       widget: _linkToggle(isLinkEditMode),
  //     ),
  //   );
  // }

  // Widget _linkToggle(bool isLinkEditMode) {
  //   logger.fine('_linkToggle ($isLinkEditMode)');
  //   return CretaToggleButton(
  //     key: GlobalObjectKey('_linkToggle$isLinkEditMode${widget.model.mid}'),
  //     width: 54 * 0.75,
  //     height: 28 * 0.75,
  //     defaultValue: isLinkEditMode,
  //     onSelected: (value) {
  //       widget.model.isLinkEditMode = value;
  //       if (widget.model.isLinkEditMode == true) {
  //         StudioVariables.isAutoPlay = true;
  //       }
  //       _linkSendEvent!.sendEvent(Offset(1, 1));
  //       setState(() {});
  //     },
  //   );
  // }
  Widget _infoUrl() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: PropertyMixin.isInfoUrlOpen,
        onPressed: () {
          setState(() {
            PropertyMixin.isInfoUrlOpen = !PropertyMixin.isInfoUrlOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['infoUrl'] ?? '연결 웹 주소', style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: widget.model.infoUrl.value.length < 3
            ? SizedBox.shrink()
            : SizedBox(
                width: 160,
                child: Text(
                  widget.model.infoUrl.value,
                  style: CretaFont.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        hasRemoveButton: widget.model.infoUrl.value.isNotEmpty,
        onDelete: () {
          widget.model.infoUrl.set('');
          BookMainPage.bookManagerHolder!.notify();
        },
        bodyWidget: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CretaTextField(
            limit: 5000,
            height: 60,
            textFieldKey: GlobalKey(),
            value: widget.model.infoUrl.value,
            hintText: '',
            //controller: textController,
            onEditComplete: (String value) {
              widget.model.infoUrl.set(value);
              _contentsManager?.notify();
              //BookMainPage.bookManagerHolder!.notify();
            },
          ),
        ),
      ),
    );
  }

  Widget _hashTag() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: PropertyMixin.isHashTagOpen,
        onPressed: () {
          setState(() {
            PropertyMixin.isHashTagOpen = !PropertyMixin.isHashTagOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['hashTab']!, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: widget.model.hashTag.value.length < 3
            ? SizedBox.shrink()
            : SizedBox(
                width: 160,
                child: Text(
                  widget.model.hashTag.value,
                  style: CretaFont.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        hasRemoveButton: widget.model.hashTag.value.isNotEmpty,
        onDelete: () {
          widget.model.hashTag.set('');
          BookMainPage.bookManagerHolder!.notify();
        },
        bodyWidget: Column(children: _tagBody()),
      ),
    );
  }

  List<Widget> _tagBody() {
    String val = widget.model.hashTag.value;
    int rest = StudioConst.maxTextLimit - 2 - val.length;
    if (rest <= 0) {
      logger.warning('len1 overflow $rest');
      _tagEnabled = false;
    }
    return hashTagWrapper.hashTag(
      hasTitle: false,
      top: 12,
      model: widget.model,
      minTextFieldWidth: LayoutConst.rightMenuWidth - horizontalPadding * 2,
      onTagChanged: (value) {},
      onSubmitted: (value) {
        setState(() {
          _tagEnabled = (value == null) ? false : true;
        });
        _hasTagChanged();
      },
      onDeleted: (value) {
        BookMainPage.bookManagerHolder!.notify();
      },
      limit: StudioConst.maxTextLimit - 2,
      enabled: _tagEnabled,
      rest: rest > 0 ? rest - 1 : 0,
    );
  }

  void _hasTagChanged() {
    if (_contentsManager != null) {
      ContentsModel? contentsModel = _contentsManager!.getCurrentModel();
      if (contentsModel != null && contentsModel.mid == widget.model.mid) {
        _contentsManager!.reOrdering();
        _contentsManager!.gotoNext();
        return;
      }
    }
    BookMainPage.bookManagerHolder!.notify();
  }

  Widget _textAni() {
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
      child: propertyCard(
        isOpen: _isTextAni,
        onPressed: () {
          setState(() {
            _isTextAni = !_isTextAni;
          });
        },
        titleWidget: Text(CretaStudioLang['ani']!, style: CretaFont.titleSmall),
        trailWidget: Text(
          widget.model.aniType.value.name,
          textAlign: TextAlign.right,
          style: CretaFont.titleSmall,
        ),
        hasRemoveButton: widget.model.aniType.value != TextAniType.none,
        onDelete: () {
          setState(() {
            widget.model.aniType.set(TextAniType.none);
          });
          _sendEvent!.sendEvent(widget.model);
        },
        bodyWidget: _textAniBody(context, widget.model),
      ),
    );
  }

  Widget _textAniBody(BuildContext context, ContentsModel model) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 0,
          right: 22,
          top: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 속도 슬라이더 바
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: propertyLine(
                name: CretaStudioLang['speed']!,
                widget: CretaExSlider(
                  valueType: SliderValueType.normal,
                  value: model.anyDuration.value,
                  onChanngeComplete: (val) {
                    //setState(() {
                    model.anyDuration.set(val);
                    //});
                    _contentsManager?.notify();
                    _sendEvent!.sendEvent(widget.model);
                  },
                  onChannged: (val) {},
                  min: 0,
                  max: 100,
                ),
              ),
            ),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(
                width: 250,
                height: 36,
                child: transitionText(
                  model,
                  TextAniType.randomTransition,
                  CretaStudioLang['transition']![0],
                )),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(
                width: 250,
                height: 36,
                child: transitionText(
                  model,
                  TextAniType.fadeTransition,
                  CretaStudioLang['transition']![1],
                )),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(
                width: 250,
                height: 36,
                child: transitionText(
                  model,
                  TextAniType.slideTransition,
                  CretaStudioLang['transition']![2],
                )),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(
                width: 250,
                height: 36,
                child: transitionText(
                  model,
                  TextAniType.scaleTransition,
                  CretaStudioLang['transition']![3],
                )),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(
                width: 250,
                height: 36,
                child: transitionText(
                  model,
                  TextAniType.rotateTransition,
                  CretaStudioLang['transition']![4],
                )),
            StudioSnippet.smallDivider(height: 10),
            // SizedBox(
            //     width: 250,
            //     height: 36,
            //     child: transitionText(
            //       model,
            //       TextAniType.sizeTransition,
            //       CretaStudioLang['transition']![5],
            //     )),
            // StudioSnippet.smallDivider(height: 10),
            // 옆으로 흐르는 문자열
            SizedBox(width: 250, height: 36, child: tickerSide(model)),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(width: 250, height: 36, child: tickerUpDown(model)),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(width: 250, height: 36, child: rotateText(model)),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(width: 250, height: 36, child: bounceText(model)),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(width: 250, height: 36, child: fidgetText(model)),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(width: 250, height: 36, child: fadeText(model)),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(width: 250, height: 36, child: shimmerText(model)),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(width: 250, height: 36, child: typewriterText(model)),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(width: 250, height: 36, child: wavyText(model)),
            StudioSnippet.smallDivider(height: 10),
            SizedBox(width: 250, height: 36, child: neonText(model)),
          ],
        ));
  }

  Widget tickerSide(ContentsModel model) {
    String text = "${CretaStudioLang['tickerSide']!} ";
    int textSize = CretaCommonUtils.getStringSize(text);
    // duration 이 50 이면 실제로는 5-7초 정도에  문자열을 다 흘려보내다.
    // 따라서 문자열의 길이에  anyDuration / 10  정도의 값을 곱해본다.
    int duration = (textSize * 0.75).ceil() * ((101 - model.anyDuration.value) / 10).ceil();
    return TextButton(
        onPressed: () {
          setState(() {
            model.aniType.set(TextAniType.tickerSide);
            if (model.anyDuration.value == 0) {
              model.anyDuration.set(50);
            }
          });
          _sendEvent!.sendEvent(widget.model);
        },
        child: ScrollLoopAutoScroll(
            key: ValueKey(Uuid().v4()),
            // ignore: sort_child_properties_last
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: dataStyle,
            ), //required
            scrollDirection: Axis.horizontal, //required
            delay: Duration(seconds: 1),
            duration: Duration(seconds: duration),
            gap: 25,
            reverseScroll: false,
            duplicateChild: 25,
            enableScrollInput: true,
            delayAfterScrollInput: Duration(seconds: 1)));
  }

  Widget tickerUpDown(ContentsModel model) {
    String text = "${CretaStudioLang['tickerSide']!} ";
    int textSize = CretaCommonUtils.getStringSize(text);
    // duration 이 50 이면 실제로는 5-7초 정도에  문자열을 다 흘려보내다.
    // 따라서 문자열의 길이에  anyDuration / 10  정도의 값을 곱해본다.
    int duration = (textSize * 0.75).ceil() * ((101 - model.anyDuration.value) / 10).ceil();
    return TextButton(
        onPressed: () {
          setState(() {
            model.aniType.set(TextAniType.tickerUpDown);
            if (model.anyDuration.value == 0) {
              model.anyDuration.set(50);
            }
          });
          _sendEvent!.sendEvent(widget.model);
        },
        child: ScrollLoopAutoScroll(
            key: ValueKey(Uuid().v4()),
            // ignore: sort_child_properties_last
            child: Text(
              CretaStudioLang['tickerUpDown']!,
              textAlign: TextAlign.left,
              style: dataStyle,
            ), //required
            scrollDirection: Axis.vertical, //required
            delay: Duration(seconds: 1),
            duration: Duration(seconds: duration),
            gap: 25,
            reverseScroll: false,
            duplicateChild: 25,
            enableScrollInput: true,
            delayAfterScrollInput: Duration(seconds: 1)));
  }

  Widget rotateText(ContentsModel model) {
    return TextButton(
      onPressed: () {
        setState(() {
          model.aniType.set(TextAniType.rotate);
          if (model.anyDuration.value == 0) {
            model.anyDuration.set(50);
          }
        });
        _sendEvent!.sendEvent(widget.model);
      },
      child: TextAnimator(
        CretaStudioLang['rotateText']!,
        style: dataStyle,
        atRestEffect: WidgetRestingEffects.rotate(),
        incomingEffect: WidgetTransitionEffects(
            blur: const Offset(2, 2), duration: const Duration(milliseconds: 600)),
        outgoingEffect: WidgetTransitionEffects(
            blur: const Offset(2, 2), duration: const Duration(milliseconds: 600)),
      ),
    );
  }

  Widget bounceText(ContentsModel model) {
    return TextButton(
      onPressed: () {
        setState(() {
          model.aniType.set(TextAniType.bounce);
          if (model.anyDuration.value == 0) {
            model.anyDuration.set(50);
          }
        });
        _sendEvent!.sendEvent(widget.model);
      },
      child: TextAnimator(
        CretaStudioLang['bounce']!,
        style: dataStyle,
        incomingEffect: WidgetTransitionEffects.incomingScaleDown(),
        atRestEffect: WidgetRestingEffects.bounce(),
        outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(),
      ),
    );
  }

  Widget fidgetText(ContentsModel model) {
    return TextButton(
      onPressed: () {
        setState(() {
          model.aniType.set(TextAniType.fidget);
          if (model.anyDuration.value == 0) {
            model.anyDuration.set(50);
          }
        });
        _sendEvent!.sendEvent(widget.model);
      },
      child: TextAnimator(
        CretaStudioLang['fidget']!,
        style: dataStyle,
        incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(),
        atRestEffect: WidgetRestingEffects.fidget(),
        outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToBottom(),
      ),
    );
  }

  Widget fadeText(ContentsModel model) {
    return TextButton(
      onPressed: () {
        setState(() {
          model.aniType.set(TextAniType.fade);
          if (model.anyDuration.value == 0) {
            model.anyDuration.set(50);
          }
        });
        _sendEvent!.sendEvent(widget.model);
      },
      child: TextAnimator(
        CretaStudioLang['fade']!,
        style: dataStyle,
        incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(),
        atRestEffect: WidgetRestingEffects.pulse(), // fade
        outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToBottom(),
      ),
    );
  }

  Widget shimmerText(ContentsModel model) {
    return TextButton(
      onPressed: () {
        setState(() {
          model.aniType.set(TextAniType.shimmer);
          if (model.anyDuration.value == 0) {
            model.anyDuration.set(50);
          }
        });
        _sendEvent!.sendEvent(widget.model);
      },
      child: Shimmer.fromColors(
          baseColor: model.fontColor.value,
          highlightColor: model.outLineColor.value == Colors.transparent
              ? Colors.red
              : model.outLineColor.value,
          child: Text(CretaStudioLang['shimmer']!)),
    );
  }

  Widget typewriterText(ContentsModel model) {
    return TextButton(
      onPressed: () {
        setState(() {
          model.aniType.set(TextAniType.typewriter);
          if (model.anyDuration.value == 0) {
            model.anyDuration.set(50);
          }
        });
        _sendEvent!.sendEvent(widget.model);
      },
      child: AnimatedTextKit(
        onTap: () {
          setState(() {
            model.aniType.set(TextAniType.typewriter);
            if (model.anyDuration.value == 0) {
              model.anyDuration.set(50);
            }
          });
          _sendEvent!.sendEvent(widget.model);
        },
        repeatForever: true,
        animatedTexts: [
          TypewriterAnimatedText(CretaStudioLang['typewriter']!,
              textAlign: TextAlign.center,
              textStyle: dataStyle,
              speed: Duration(milliseconds: 505 - model.anyDuration.value.round() * 5)),
        ],
      ),
    );
  }

  Widget wavyText(ContentsModel model) {
    return TextButton(
      onPressed: () {
        setState(() {
          model.aniType.set(TextAniType.wavy);
          if (model.anyDuration.value == 0) {
            model.anyDuration.set(50);
          }
        });
        _sendEvent!.sendEvent(widget.model);
      },
      child: AnimatedTextKit(
        onTap: () {
          setState(() {
            model.aniType.set(TextAniType.wavy);
            if (model.anyDuration.value == 0) {
              model.anyDuration.set(50);
            }
          });
          _sendEvent!.sendEvent(widget.model);
        },
        repeatForever: true,
        animatedTexts: [
          WavyAnimatedText(CretaStudioLang['wavy']!,
              textAlign: TextAlign.center,
              textStyle: dataStyle,
              speed: Duration(milliseconds: 505 - model.anyDuration.value.round() * 5)),
        ],
      ),
    );
  }

  Widget neonText(ContentsModel model) {
    return TextButton(
      onPressed: () {
        setState(() {
          model.aniType.set(TextAniType.neon);
          if (model.anyDuration.value == 0) {
            model.anyDuration.set(50);
          }
        });
        _sendEvent!.sendEvent(widget.model);
      },
      child: Neonpen(
        text: Text(
          CretaStudioLang['neon']!,
          style: dataStyle,
        ),
        color:
            model.outLineColor.value == Colors.transparent ? Colors.red : model.outLineColor.value,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        opacity: 0.8,
        emphasisWidth: 5,
        emphasisOpacity: 0.5,
        emphasisAngleDegree: 0.5,
        enableLineZiggle: true,
        lineZiggleLevel: 1,
        isDoubleLayer: false,
      ),
    );
  }

  Widget transitionText(ContentsModel model, TextAniType aniType, String title) {
    return TextButton(
      onPressed: () {
        setState(() {
          model.aniType.set(aniType);
          if (model.anyDuration.value == 0) {
            model.anyDuration.set(50);
          }
        });
        _sendEvent!.sendEvent(widget.model);
      },
      child: CretaTextSwitcher(
          text: '$title \n $title',
          stopDuration: Duration(seconds: 2),
          switchDuration: Duration(seconds: 1),
          aniType: aniType,
          builder: (index, eachLine) {
            return Text(
              eachLine,
              key: ValueKey<int>(index),
              style: dataStyle,
            );
          }),
    );
  }

  void _invalidateContentsThumb() {
    _contentsManager!
        .invalidateContentsThumb(widget.frameManager.pageModel.mid, widget.model.parentMid.value);
  }

  void _invalidateContentsMain() {
    widget.frameManager
        .invalidateContentsMain(widget.frameManager.pageModel.mid, widget.model.parentMid.value);
  }
}
