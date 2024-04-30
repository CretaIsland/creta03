// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields
import 'dart:math' as math;
import 'package:creta03/pages/studio/right_menu/frame/trans_example_box.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/buttons/creta_ex_slider.dart';
import '../../../../design_system/buttons/creta_tab_button.dart';
import '../../../../design_system/buttons/creta_toggle_button.dart';
import '../../../../design_system/component/colorPicker/shadow_indicator.dart';
import '../../../../design_system/component/example_box_mixin.dart';
import '../../../../design_system/component/shape/shape_indicator.dart';
import '../../../../design_system/component/creta_proprty_slider.dart';
import '../../../../design_system/component/time_input_widget.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../design_system/menu/creta_widget_drop_down.dart';
import '../../../../design_system/text_field/creta_text_field.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../../model/frame_model_util.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../property_mixin.dart';

// class CornerOpenFlag {
//   bool value = false;
// }

// class LeftTopSelected extends CornerOpenFlag {}

// class RightTopSelected extends CornerOpenFlag {}

// class LeftBottomSelected extends CornerOpenFlag {}

// class RightBottomSelected extends CornerOpenFlag {}

class FrameProperty extends StatefulWidget {
  final FrameModel model;
  final PageModel? pageModel;
  const FrameProperty({super.key, required this.model, this.pageModel});

  @override
  State<FrameProperty> createState() => _FramePropertyState();
}

class _FramePropertyState extends State<FrameProperty> with PropertyMixin {
  // ignore: unused_field
  //late ScrollController _scrollController;
  // ignore: unused_field
  // ignore: unused_field
  FrameManager? _frameManager;
  BookModel? _bookModel;
  bool _isFullScreen = false;
  static bool _isTransitionOpen = false;
  static bool _isFrameTransOpen = false;
  static bool _isBorderOpen = false;
  static bool _isShadowOpen = false;
  static bool _isSizeOpen = true;
  static bool _isRadiusOpen = false;

  static bool _isShapeOpen = false;
  bool _matched = false;
  bool _isCustom = false;
  //NextContentTypes _selectedType = NextContentTypes.none;
  // LeftTopSelected _isLeftTopSelected = LeftTopSelected();
  // RightTopSelected _isRightTopSelected = RightTopSelected();
  // LeftBottomSelected _isLeftBottomSelected = LeftBottomSelected();
  // RightBottomSelected _isRightBottomSelected = RightBottomSelected();

  // List<Image> _imageList = [
  //   Image.asset('assets/line0.png'),
  //   Image.asset('assets/line1.png'),
  //   Image.asset('assets/line2.png'),
  //   Image.asset('assets/line3.png'),
  //   Image.asset('assets/line4.png'),
  //   Image.asset('assets/line5.png'),
  // ];

  FrameEventController? _sendEvent;
  FrameEventController? _receiveEvent;

  bool _tagEnabled = true;

  Widget _borderStyle(double width, double height, double dottedLength, double dottedSpace) {
    return Container(
      margin: EdgeInsets.only(
          left: (boderStyleDropBoxWidth - width) / 2,
          right: (boderStyleDropBoxWidth - width) / 2,
          top: height),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: RDottedLineBorder(
          dottedLength: dottedLength,
          dottedSpace: dottedSpace,
          top: BorderSide(),
        ),
      ),
    );
  }

  void _notifyToThumbnail() {
    if (widget.pageModel != null) {
      notifyToThumbnail(widget.pageModel!);
    } else {
      logger.severe('something wrong, pageModel is null');
    }
  }

  void _invalidateFrame() {
    if (!_frameManager!.refreshFrame(widget.model.mid)) {
      // key 를 찾지못한 경우만, sendEvent 를 한다.
      _sendEvent!.sendEvent(widget.model);
    }
    _notifyToThumbnail();
    //_invalidateFrame();  // _sendEvent!.sendEvent(widget.model);;
  }

  @override
  void initState() {
    logger.finest('_FramePropertyState.initState');

    super.initMixin();
    super.initState();

    _bookModel = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;

    _isRadiusOpen = !(widget.model.radiusLeftBottom.value == widget.model.radiusRightBottom.value &&
        widget.model.radiusRightBottom.value == widget.model.radiusLeftTop.value &&
        widget.model.radiusLeftTop.value == widget.model.radiusRightTop.value);

    final FrameEventController sendEvent = Get.find(tag: 'frame-property-to-main');
    _sendEvent = sendEvent;
    final FrameEventController receiveEvent = Get.find(tag: 'frame-main-to-property');
    _receiveEvent = receiveEvent;

    logger.finest(
        'spread=${widget.model.shadowSpread.value}, blur=${widget.model.shadowBlur.value},direction=${widget.model.shadowDirection.value}, distance=${widget.model.shadowOffset.value}');

    _frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isFullScreen = widget.model.isFullScreenTest(_bookModel!);
    //final NextContentTypes selectedType = widget.model.nextContentTypes.value;
    // if (_model == null) {
    //   return SizedBox.shrink();
    // }
    //sendEvent = Get.find(/*tag: 'frameEvent1'*/);

    // final FrameEventController bController = Get.find(tag: 'main2pro');
    // receiveEvent = bController;

    // return StreamBuilder<FrameModel>(
    //     stream: receiveEvent!.eventStream.stream,
    //     builder: (context, snapshot) {
    //       if (snapshot.data != null && snapshot.data!.mid == widget.model.mid) {
    //         snapshot.data!.copyTo(widget.model);
    //       }
    logger.finest(
        'build : spread=${widget.model.shadowSpread.value}, blur=${widget.model.shadowBlur.value},direction=${widget.model.shadowDirection.value}, distance=${widget.model.shadowOffset.value}');
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top: 0),
        child: _pageSize(),
      ),
      propertyDivider(),
      _pageColor(),
      propertyDivider(),
      _frameTransition(),
      propertyDivider(),
      _gradation(),
      propertyDivider(),
      _texture(),
      propertyDivider(),
      _pageTransition(),
      propertyDivider(),
      _border(),
      propertyDivider(),
      _shadow(),
      propertyDivider(),
      _shape(),
      propertyDivider(),
      _event(),
      propertyDivider(),
      _hashTag(),
    ]);
    //});
  }

  Widget _pageSize() {
    return StreamBuilder<AbsExModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.mid == widget.model.mid) {
            (snapshot.data! as FrameModel).copyTo(widget.model);
          }

          double height = widget.model.height.value;
          double width = widget.model.width.value;

          if (BookMainPage.containeeNotifier!.isOpenSize) {
            _isSizeOpen = true;
          }

          return Column(
            children: [
              propertyCard(
                padding: horizontalPadding,
                isOpen: _isSizeOpen,
                onPressed: () {
                  setState(() {
                    _isSizeOpen = !_isSizeOpen;
                    BookMainPage.containeeNotifier!.setOpenSize(_isSizeOpen);
                  });
                },
                titleWidget: Text(CretaStudioLang['frameSize']!, style: CretaFont.titleSmall),
                trailWidget: widget.model.isOverlay.value == true
                    ? Row(
                        children: [
                          Text('${width.round()} x ${height.round()}', style: dataStyle),
                          Transform.rotate(
                            angle: math.pi / 6,
                            child: IconButton(
                              icon: Icon(Icons.push_pin_outlined,
                                  color: widget.pageModel != null &&
                                          widget.pageModel!.mid != widget.model.parentMid.value
                                      ? CretaColor.stateNormal
                                      : CretaColor.stateCritical),
                              iconSize: 20,
                              onPressed: () {
                                _setOverlay(false);
                              },
                            ),
                          ),
                        ],
                      )
                    : Text('${width.round()} x ${height.round()}', style: dataStyle),
                onDelete: () {},
                hasRemoveButton: false,
                bodyWidget: _pageSizeBody(width, height),
              ),
              if (widget.model.isMusicType()) _musicPlayerSize(),
              if (widget.model.isNewsType()) _newsFrameSize(),
            ],
          );
        });
  }

  String _getCurrentSizeString() {
    int index = 0;
    Size frameSize = Size(widget.model.width.value, widget.model.height.value);
    MusicPlayerSizeEnum currentSize = MusicPlayerSizeEnum.Big;
    for (Size ele in StudioConst.musicPlayerSize) {
      if (frameSize == ele) {
        currentSize = MusicPlayerSizeEnum.values[index];
        return StudioConst.sizeEnumMap[currentSize]!;
      }
      index++;
    }
    logger.fine('wrong size $frameSize');
    return StudioConst.sizeEnumMap[MusicPlayerSizeEnum.Big]!;
  }

  Widget _musicPlayerSize() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 30, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(CretaStudioLang['playersize']!, style: titleStyle),
          CretaTabButton(
            defaultString: _getCurrentSizeString(),
            onEditComplete: (value) {
              int idx = 0;
              widget.model.musicPlayerSizeType = StudioConst.sizeStringMap[value]!;
              for (String val in CretaStudioLang['playerSize']!.values) {
                if (value == val) {
                  mychangeStack.startTrans();
                  widget.model.width.set(StudioConst.musicPlayerSize[idx].width);
                  widget.model.height.set(StudioConst.musicPlayerSize[idx].height);
                  mychangeStack.endTrans();
                  break;
                }
                idx++;
              }
              // _invalidateFrame();
              _sendEvent!.sendEvent(widget.model);
              _notifyToThumbnail();
            },
            width: 55,
            height: 24,
            selectedTextColor: CretaColor.primary,
            unSelectedTextColor: CretaColor.text[700]!,
            selectedColor: Colors.white,
            unSelectedColor: CretaColor.text[100]!,
            selectedBorderColor: CretaColor.primary,
            buttonLables: CretaStudioLang['playerSize']!.keys.toList(),
            buttonValues: [...CretaStudioLang['playerSize']!.values.toList()],
          ),
        ],
      ),
    );
  }

  String _getCurrentNewsSizeString() {
    int index = 0;
    Size frameSize = Size(widget.model.width.value, widget.model.height.value);
    NewsSizeEnum currentSize = NewsSizeEnum.Big;
    for (Size ele in StudioConst.newsFrameSize) {
      if (frameSize == ele) {
        currentSize = NewsSizeEnum.values[index];
        return StudioConst.newsSizeEnumMap[currentSize]!;
      }
      index++;
    }
    logger.fine('wrong size $frameSize');
    return StudioConst.sizeEnumMap[MusicPlayerSizeEnum.Big]!;
  }

  Widget _newsFrameSize() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 30, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(CretaStudioLang['playersize']!, style: titleStyle),
          CretaTabButton(
            defaultString: _getCurrentNewsSizeString(),
            onEditComplete: (value) {
              int idx = 0;
              widget.model.newsSizeType = StudioConst.newsSizeMap[value]!;
              for (String val in CretaStudioLang['newsSize']!.values) {
                if (value == val) {
                  mychangeStack.startTrans();
                  widget.model.width.set(StudioConst.newsFrameSize[idx].width);
                  widget.model.height.set(StudioConst.newsFrameSize[idx].height);
                  mychangeStack.endTrans();
                  break;
                }
                idx++;
              }
              // _invalidateFrame();
              _sendEvent!.sendEvent(widget.model);
              _notifyToThumbnail();
            },
            width: 55,
            height: 24,
            selectedTextColor: CretaColor.primary,
            unSelectedTextColor: CretaColor.text[700]!,
            selectedColor: Colors.white,
            unSelectedColor: CretaColor.text[100]!,
            selectedBorderColor: CretaColor.primary,
            buttonLables: CretaStudioLang['newsSize']!.keys.toList(),
            buttonValues: [...CretaStudioLang['newsSize']!.values.toList()],
          ),
        ],
      ),
    );
  }

  Widget _pageSizeBody(double width, double height) {
    //return Column(children: [
    //Text(CretaStudioLang['pageSize']!, style: CretaFont.titleSmall),
    return Column(
      children: [
// 첫번쨰 줄  posX,y
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 97,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CretaStudioLang['posX']!,
                      style: titleStyle,
                    ),
                    CretaTextField.xshortNumber(
                      defaultBorder: Border.all(color: CretaColor.text[100]!),
                      width: 45,
                      limit: 5,
                      textFieldKey: GlobalKey(),
                      value: widget.model.posX.value.round().toString(),
                      hintText: '',
                      onEditComplete: ((value) {
                        logger.info('onEditComplete');
                        widget.model.posX.set(int.parse(value).toDouble());
                        _sendEvent?.sendEvent(widget.model);
                        _notifyToThumbnail();
                      }),
                      minNumber: 0,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 64),
              SizedBox(
                width: 97,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CretaStudioLang['posY']!,
                      style: titleStyle,
                    ),
                    CretaTextField.xshortNumber(
                      defaultBorder: Border.all(color: CretaColor.text[100]!),
                      width: 45,
                      limit: 5,
                      textFieldKey: GlobalKey(),
                      value: widget.model.posY.value.round().toString(),
                      //value: widget.model.posY.value.toString(),
                      hintText: '',
                      minNumber: 0,
                      onEditComplete: ((value) {
                        widget.model.posY.set(int.parse(value).toDouble());
                        _sendEvent?.sendEvent(widget.model);
                        _notifyToThumbnail();
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!widget.model.isMusicType())
          // 두번째 줄  width, height
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 258,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //SizedBox(
                        //width: 97,
                       // child: 
                       Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CretaStudioLang['width']!,
                              style: titleStyle,
                            ),
                            CretaTextField.xshortNumber(
                              defaultBorder: Border.all(color: CretaColor.text[100]!),
                              width: 45,
                              limit: 5,
                              textFieldKey: GlobalKey(),
                              value: widget.model.width.value.round().toString(),
                              hintText: '',
                              onEditComplete: ((value) {
                                logger.info('onEditComplete');
                                _sizeChanged(value, widget.model.width, widget.model.height);
                              }),
                              minNumber: LayoutConst.minFrameSize.toDouble(),
                              maxNumber: _bookModel!.width.value,
                            ),
                          ],
                        ),
                      //),
                      BTN.fill_gray_i_m(
                          tooltip: CretaStudioLang['fixedRatio']!,
                          tooltipBg: CretaColor.text[400]!,
                          icon: widget.model.isFixedRatio.value
                              ? Icons.lock_outlined
                              : Icons.lock_open_outlined,
                          iconColor: widget.model.isFixedRatio.value
                              ? CretaColor.primary
                              : CretaColor.text[700]!,
                          onPressed: () {
                            setState(() {
                              widget.model.isFixedRatio.set(!widget.model.isFixedRatio.value);
                            });
                            _sendEvent!.sendEvent(widget.model);
                          }),
                      //SizedBox(
                      //width: 97,
                      //child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            CretaStudioLang['height']!,
                            style: titleStyle,
                          ),
                          SizedBox(width: 15),
                          CretaTextField.xshortNumber(
                            defaultBorder: Border.all(color: CretaColor.text[100]!),
                            width: 45,
                            limit: 5,
                            textFieldKey: GlobalKey(),
                            value: widget.model.height.value.round().toString(),
                            hintText: '',
                            minNumber: LayoutConst.minFrameSize.toDouble(),
                            maxNumber: _bookModel!.height.value,
                            onEditComplete: ((value) {
                              _sizeChanged(value, widget.model.height, widget.model.width);
                            }),
                          ),
                        ],
                      ),
                      //),
                    ],
                  ),
                ),
                BTN.fill_gray_i_m(
                    tooltip: CretaStudioLang['fullscreenTooltip']!,
                    tooltipBg: CretaColor.text[400]!,
                    iconSize: 18,
                    icon:
                        _isFullScreen ? Icons.fullscreen_exit_outlined : Icons.fullscreen_outlined,
                    onPressed: () {
                      if (_bookModel == null) return;
                      setState(() {
                        widget.model.toggleFullscreen(_isFullScreen, _bookModel!);
                        logger.finest('sendEvent');
                        //_invalidateFrame();
                        _sendEvent!.sendEvent(widget.model);
                        _notifyToThumbnail();
                        //_frameManager?.refreshFrame(widget.model.mid, deep: true);
                      });
                    }),
              ],
            ),
          ),
        // 세번째 줄   overlay
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
          child: propertyLine(
            // overlay
            topPadding: 10,
            name: CretaStudioLang['overlayFrame']!,
            widget: CretaToggleButton(
              width: 54 * 0.75,
              height: 28 * 0.75,
              defaultValue: widget.model.isOverlay.value,
              onSelected: _setOverlay,
            ),
          ),
        ),
        if (!widget.model.isMusicType())
          //  다섯번째 줄  autofit,
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
              //child: BTN.line_blue_t_m(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BTN.fill_gray_ti_m(
                    width: 180,
                    icon: Icons.crop_original_outlined,
                    text: CretaStudioLang['autoFitContents']!,
                    onPressed: () async {
                      if (_frameManager == null) {
                        logger.fine('frameManager is null');
                        return;
                      }
                      mychangeStack.startTrans();
                      widget.model.isAutoFit.set(true, save: false);
                      widget.model.isFixedRatio.set(true, save: false);
                      await _frameManager?.resizeFrame2(widget.model, invalidate: true);
                      mychangeStack.endTrans();
                      //_frameManager?.refreshFrame(widget.model.mid, deep: true);
                      //_sendEvent?.sendEvent(widget.model);
                      setState(() {});
                    },
                  ),
                ],
              )
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       CretaStudioLang['autoFitContents']!,
              //       style: titleStyle,
              //     ),
              //     CretaToggleButton(
              //       defaultValue: widget.model.isAutoFit.value,
              //       onSelected: (value) {
              //         widget.model.isAutoFit.set(value);
              //         if (value == true) {
              //           setState(() {
              //             widget.model.isFixedRatio.set(value);
              //           });
              //           if (_frameManager == null) {
              //             logger.fine('frameManager is null');
              //           }
              //           _frameManager?.resizeFrame2(widget.model);
              //         } else {
              //           _frameManager?.notify();
              //         }
              //         _sendEvent?.sendEvent(widget.model);
              //       },
              //     ),
              //   ],
              // ),
              ),
        if (!widget.model.isMusicType())
          // 여섯번째 줄  rotate
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 97,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CretaStudioLang['angle']!,
                        style: titleStyle,
                      ),
                      CretaTextField.xshortNumber(
                        maxNumber: 360,
                        defaultBorder: Border.all(color: CretaColor.text[100]!),
                        width: 45,
                        limit: 5,
                        textFieldKey: GlobalKey(),
                        value: widget.model.angle.value.round().toString(),
                        hintText: '',
                        onEditComplete: ((value) {
                          logger.finest('onEditComplete $value');
                          double newValue = int.parse(value).toDouble();
                          if (widget.model.angle.value == newValue) {
                            return;
                          }
                          widget.model.angle.set(newValue);
                          //BookMainPage.bookManagerHolder!.notify();
                          //_sendEvent!.sendEvent(widget.model);
                          _invalidateFrame();
                          logger.finest('onEditComplete ${widget.model.angle.value}');
                        }),
                        minNumber: 0,
                      ),
                      // Text(
                      //   "90",
                      //   style: titleStyle,
                      // ),
                      // BTN.fill_gray_i_m(
                      //     iconSize: 18,
                      //     icon: Icons.rotate_90_degrees_ccw_outlined,
                      //     onPressed: () {
                      //       widget.model.angle.set((widget.model.angle.value + 270) % 360);
                      //       logger.finest('sendEvent');
                      //       _sendEvent!.sendEvent(widget.model);
                      //     }),
                    ],
                  ),
                ),
                BTN.fill_gray_i_m(
                    tooltip: CretaStudioLang['angleTooltip']!,
                    tooltipBg: CretaColor.text[400]!,
                    iconSize: 18,
                    icon: Icons.rotate_90_degrees_ccw_outlined,
                    onPressed: () {
                      setState(() {
                        int turns = (widget.model.angle.value / 15).round() - 1;
                        double angle = (turns * 15.0) % 360;
                        if (angle < 0) {
                          angle = 360 - angle;
                        }
                        widget.model.angle.set(angle);
                      });
                      logger.finest('sendEvent');
                      //_sendEvent!.sendEvent(widget.model);
                      _invalidateFrame();
                    }),
                BTN.fill_gray_i_m(
                    tooltip: CretaStudioLang['angleTooltip']!,
                    tooltipBg: CretaColor.text[400]!,
                    iconSize: 18,
                    icon: Icons.rotate_90_degrees_cw_outlined,
                    onPressed: () {
                      setState(() {
                        int turns = (widget.model.angle.value / 15).round() + 1;
                        widget.model.angle.set((turns * 15.0) % 360);
                      });

                      logger.finest('sendEvent');
                      //_sendEvent!.sendEvent(widget.model);
                      _invalidateFrame();
                    }),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text('${CretaStudioLang['inSideRotate']!} ', style: titleStyle),
                //     CretaToggleButton(
                //       width: 54 * 0.75,
                //       height: 28 * 0.75,
                //       defaultValue: widget.model.isInsideRotate.value,
                //       onSelected: (value) {
                //         widget.model.isInsideRotate.set(value);
                //         _sendEvent!.sendEvent(widget.model);
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        // 일곱번째 줄  radius
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 97,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CretaStudioLang['radius']!,
                      style: titleStyle,
                    ),
                    CretaTextField.xshortNumber(
                      maxNumber: 999,
                      defaultBorder: Border.all(color: CretaColor.text[100]!),
                      width: 45,
                      limit: 5,
                      textFieldKey: GlobalKey(),
                      value: widget.model.radius.value.round().toString(),
                      hintText: '',
                      onEditComplete: ((value) {
                        logger.finest('onEditComplete $value');
                        double newValue = int.parse(value).toDouble();
                        if (widget.model.radius.value == newValue) {
                          return;
                        }
                        setState(() {
                          mychangeStack.startTrans();
                          widget.model.radius.set(newValue);
                          widget.model.radiusLeftTop.set(newValue);
                          widget.model.radiusRightTop.set(newValue);
                          widget.model.radiusRightBottom.set(newValue);
                          widget.model.radiusLeftBottom.set(newValue);
                          mychangeStack.endTrans();
                        });
                        //BookMainPage.bookManagerHolder!.notify();
                        //_sendEvent!.sendEvent(widget.model);
                        _invalidateFrame();
                        logger.finest('onEditComplete ${widget.model.radius.value}');
                      }),
                      minNumber: 0,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 17),
              BTN.fill_gray_i_m(
                  tooltip: CretaStudioLang['cornerTooltip']!,
                  tooltipBg: CretaColor.text[400]!,
                  iconSize: 18,
                  icon: Icons.rounded_corner_outlined,
                  onPressed: () {
                    setState(() {
                      _isRadiusOpen = !_isRadiusOpen;
                    });
                  }),
            ],
          ),
        ),
        _isRadiusOpen
            ? Padding(
                padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _cornerRadius(
                            cornerValue: widget.model.radiusLeftTop,
                            onEditComplete: ((value) {
                              widget.model.radiusLeftTop.set(value);
                              _invalidateFrame();
                              logger.fine('onEditComplete applied=$value');
                            }),
                            onSelected: (name, value, nvMap) {},
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _cornerRadius(
                            cornerValue: widget.model.radiusLeftBottom,
                            onEditComplete: ((value) {
                              widget.model.radiusLeftBottom.set(value);
                              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
                              logger.fine('onEditComplete applied=$value');
                            }),
                            onSelected: (name, value, nvMap) {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 49,
                      height: 49,
                      child: Wrap(
                        spacing: 1,
                        runSpacing: 1,
                        children: [
                          RotatedBox(
                            quarterTurns: 3,
                            child: Icon(Icons.rounded_corner_outlined,
                                size: 24,
                                color: widget.model.radiusLeftTop.value > 0
                                    ? CretaColor.primary
                                    : CretaColor.text[200]!),
                          ),
                          RotatedBox(
                            quarterTurns: 0,
                            child: Icon(Icons.rounded_corner_outlined,
                                size: 24,
                                color: widget.model.radiusRightTop.value > 0
                                    ? CretaColor.primary
                                    : CretaColor.text[200]!),
                          ),
                          RotatedBox(
                            quarterTurns: 2,
                            child: Icon(Icons.rounded_corner_outlined,
                                size: 24,
                                color: widget.model.radiusLeftBottom.value > 0
                                    ? CretaColor.primary
                                    : CretaColor.text[200]!),
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Icon(Icons.rounded_corner_outlined,
                                size: 24,
                                color: widget.model.radiusRightBottom.value > 0
                                    ? CretaColor.primary
                                    : CretaColor.text[200]!),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _cornerRadius(
                            cornerValue: widget.model.radiusRightTop,
                            onEditComplete: ((value) {
                              widget.model.radiusRightTop.set(value);
                              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
                              logger.fine('onEditComplete applied=$value');
                            }),
                            onSelected: (name, value, nvMap) {},
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _cornerRadius(
                            cornerValue: widget.model.radiusRightBottom,
                            onEditComplete: ((value) {
                              widget.model.radiusRightBottom.set(value);
                              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
                              logger.fine('onEditComplete applied=$value');
                            }),
                            onSelected: (name, value, nvMap) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _cornerRadius({
    // required bool isLeftWidget,
    // required CornerOpenFlag openFlag,
    required UndoAble<double> cornerValue,
    required void Function(double) onEditComplete,
    required void Function(String, bool, Map<String, bool>) onSelected,
  }) {
    return CretaTextField.xshortNumber(
      //enabled: openFlag.value,
      align: TextAlign.center,
      maxNumber: 999,
      defaultBorder: Border.all(color: CretaColor.text[100]!),
      width: 45,
      limit: 5,
      textFieldKey: GlobalKey(),
      value: cornerValue.value.round().toString(),
      hintText: '',
      onEditComplete: ((value) {
        logger.fine('onEditComplete org=$value');
        double newValue = int.parse(value).toDouble();
        // if (cornerValue.value == newValue) {
        //   return;
        // }
        onEditComplete.call(newValue);
      }),
      minNumber: 0,
    );
    // if (isLeftWidget == true) {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     children: [
    //       CretaTextField.xshortNumber(
    //         enabled: openFlag.value,
    //         align: TextAlign.center,
    //         maxNumber: 360,
    //         defaultBorder: Border.all(color: CretaColor.text[100]!),
    //         width: 45,
    //         limit: 5,
    //         textFieldKey: GlobalKey(),
    //         value: cornerValue.value.round().toString(),
    //         hintText: '',
    //         onEditComplete: ((value) {
    //           logger.finest('onEditComplete $value');
    //           double newValue = int.parse(value).toDouble();
    //           if (cornerValue.value == newValue) {
    //             return;
    //           }
    //           cornerValue.set(newValue);
    //           //BookMainPage.bookManagerHolder!.notify();
    //           _invalidateFrame();  // _sendEvent!.sendEvent(widget.model);;
    //           logger.finest('onEditComplete ${cornerValue.value}');
    //           onEditComplete.call(value);
    //         }),
    //         minNumber: 0,
    //       ),
    //       CretaCheckbox(
    //         density: 0,
    //         onSelected: (name, value, nvMap) {
    //           if (value == false) {
    //             openFlag.value = value;
    //             cornerValue.set(0);
    //             //BookMainPage.bookManagerHolder!.notify();
    //             _invalidateFrame();  // _sendEvent!.sendEvent(widget.model);;
    //             logger.finest('onEditComplete ${cornerValue.value}');
    //           } else {
    //             setState(() {
    //               openFlag.value = value;
    //             });
    //           }
    //           onSelected.call(name, value, nvMap);
    //         },
    //         valueMap: {"": (cornerValue.value != 0)},
    //       ),
    //     ],
    //   );
    // }

    // return Row(
    //   mainAxisAlignment = MainAxisAlignment.start,
    //   children = [
    //     CretaCheckbox(
    //       density: 0,
    //       onSelected: (name, value, nvMap) {
    //         if (value == false) {
    //           openFlag.value = value;
    //           cornerValue.set(0);
    //           //BookMainPage.bookManagerHolder!.notify();
    //           _invalidateFrame();  // _sendEvent!.sendEvent(widget.model);;
    //           logger.finest('onEditComplete ${cornerValue.value}');
    //         } else {
    //           setState(() {
    //             openFlag.value = value;
    //           });
    //         }
    //         onSelected.call(name, value, nvMap);
    //       },
    //       valueMap: {"": (cornerValue.value != 0)},
    //     ),
    //     CretaTextField.xshortNumber(
    //       enabled: openFlag.value,
    //       align: TextAlign.center,
    //       maxNumber: 360,
    //       defaultBorder: Border.all(color: CretaColor.text[100]!),
    //       width: 45,
    //       limit: 5,
    //       textFieldKey: GlobalKey(),
    //       value: cornerValue.value.round().toString(),
    //       hintText: '',
    //       onEditComplete: ((value) {
    //         logger.finest('onEditComplete $value');
    //         double newValue = int.parse(value).toDouble();
    //         if (cornerValue.value == newValue) {
    //           return;
    //         }
    //         cornerValue.set(newValue);
    //         //BookMainPage.bookManagerHolder!.notify();
    //         _invalidateFrame();  // _sendEvent!.sendEvent(widget.model);;
    //         logger.finest('onEditComplete ${cornerValue.value}');
    //         onEditComplete.call(value);
    //       }),
    //       minNumber: 0,
    //     ),
    //   ],q
    // );
  }

  // Widget _eachCorner()
  // {
  //   return  child: SizedBox(
  //                 width: 97,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     CretaIconCheckbox(
  //                       onSelected: (name, value, nvMap) {},
  //                       valueMap: {
  //                         Icons.rounded_corner_outlined: (widget.model.radiusLeftTop.value != 0)
  //                       },
  //                       iconTurns: 3,
  //                     ),
  //                     SizedBox(width:10),
  //                     CretaTextField.xshortNumber(
  //                       maxNumber: 360,
  //                       defaultBorder: Border.all(color: CretaColor.text[100]!),
  //                       width: 45,
  //                       limit: 5,
  //                       textFieldKey: GlobalKey(),
  //                       value: widget.model.radiusLeftTop.value.round().toString(),
  //                       hintText: '',
  //                       onEditComplete: ((value) {
  //                         logger.finest('onEditComplete $value');
  //                         double newValue = int.parse(value).toDouble();
  //                         if (widget.model.radiusLeftTop.value == newValue) {
  //                           return;
  //                         }
  //                         widget.model.radiusLeftTop.set(newValue);
  //                         //BookMainPage.bookManagerHolder!.notify();
  //                         _invalidateFrame();  // _sendEvent!.sendEvent(widget.model);;
  //                         logger.finest('onEditComplete ${widget.model.radiusLeftTop.value}');
  //                       }),
  //                       minNumber: 0,
  //                     ),
  //                   ],
  //                 ),
  //               );
  // }
  void _sizeChanged(
    String value,
    UndoAble<double> targetAttr,
    UndoAble<double> counterAttr,
  ) {
    logger.finest('onEditComplete $value');
    double oldValue = targetAttr.value;
    double newValue = int.parse(value).toDouble();
    if (targetAttr.value == newValue) {
      return;
    }

    targetAttr.set(newValue);
    if (widget.model.isFixedRatio.value == true) {
      setState(() {
        double ratio = counterAttr.value / oldValue;
        counterAttr.set((newValue * ratio).roundToDouble());
      });
    }

    //BookMainPage.bookManagerHolder!.notify();
    _sendEvent!.sendEvent(widget.model);
    _notifyToThumbnail();
    logger.finest('onEditComplete ${targetAttr.value}');
  }

  Widget _pageColor() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: colorPropertyCard(
        title: CretaStudioLang['frameBgColor']!,
        color1: widget.model.bgColor1.value,
        color2: widget.model.bgColor2.value,
        opacity: widget.model.opacity.value,
        gradationType: widget.model.gradationType.value,
        cardOpenPressed: () {
          setState(() {});
        },
        onOpacityDragComplete: (value) {
          //setState(() {
          widget.model.opacity.set(value);
          logger.finest('opacity1=${widget.model.opacity.value}');
          //});

          //_sendEvent!.sendEvent(widget.model);
          _invalidateFrame();
        },
        onOpacityDrag: (value) {
          // widget.model.opacity.set(value, save: false);
          // logger.finest('opacity1=${widget.model.opacity.value}');
          //_sendEvent!.sendEvent(widget.model);
        },
        onColor1Changed: (val) {
          setState(() {
            widget.model.bgColor1.set(val);
            //print('model.bgColor1 = ${widget.model.bgColor1.value}');
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
        onColorIndicatorClicked: () {
          PropertyMixin.isColorOpen = true;
          setState(() {});
        },
        onDelete: () {
          setState(() {
            widget.model.bgColor1.set(Colors.transparent);
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
      ),
    );
  }

  Widget _frameTransition() {
    logger.finest('frameTransition=${widget.model.nextContentTypes.value}');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: _isFrameTransOpen,
        onPressed: () {
          setState(() {
            _isFrameTransOpen = !_isFrameTransOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['contentFlipEffect']!, style: CretaFont.titleSmall),
        trailWidget: Text(
          widget.model.nextContentTypes.value == NextContentTypes.none
              ? ''
              : CretaStudioLang['nextContentTypes']![widget.model.nextContentTypes.value.index],
          textAlign: TextAlign.right,
          style: CretaFont.titleSmall.copyWith(overflow: TextOverflow.fade),
        ),
        hasRemoveButton: widget.model.nextContentTypes.value != NextContentTypes.none,
        onDelete: () {
          setState(() {
            widget.model.nextContentTypes.set(NextContentTypes.none);
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
        bodyWidget: _nextContentTypes(),
      ),
    );
  }

  Widget _nextContentTypes() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        children: [
          for (int i = 1; i < NextContentTypes.end.index; i++)
            TransExampleBox(
              key: ValueKey(
                  'nextContentType=${NextContentTypes.values[i].name} + ${_isTypeSelected(i, NextContentTypes.values[i])}}'),
              frameManager: _frameManager!,
              model: widget.model,
              nextContentTypes: NextContentTypes.values[i],
              name: CretaStudioLang['nextContentTypes']![i],
              selectedType: _isTypeSelected(i, widget.model.nextContentTypes.value),
              onTypeSelected: () {
                setState(() {});
                _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
              },
            )
        ],
      ),
    );
  }

  bool _isTypeSelected(int index, NextContentTypes selectedType) {
    return NextContentTypes.values[index] == selectedType;
  }

  Widget _gradation() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: gradationCard(
        onPressed: () {
          setState(() {});
        },
        bgColor1: widget.model.bgColor1.value,
        bgColor2: widget.model.bgColor2.value,
        opacity: widget.model.opacity.value,
        gradationType: widget.model.gradationType.value,
        onGradationTapPressed: (GradationType type, Color color1, Color color2) {
          logger.finest('GradationIndicator clicked');
          setState(() {
            if (widget.model.gradationType.value == type) {
              widget.model.gradationType.set(GradationType.none);
            } else {
              widget.model.gradationType.set(type);
            }
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
        onColor2Changed: (Color val) {
          setState(() {
            widget.model.bgColor2.set(val);
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
        onColorIndicatorClicked: () {
          setState(() {
            PropertyMixin.isGradationOpen = true;
          });
        },
        onDelete: () {
          setState(() {
            widget.model.gradationType.set(GradationType.none);
            widget.model.bgColor2.set(Colors.transparent);
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
      ),
    );
  }

  Widget _texture() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: textureCard(
        textureType: widget.model.textureType.value,
        onPressed: () {
          setState(() {});
        },
        onTextureTapPressed: (val) {
          setState(() {
            widget.model.textureType.set(val);
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
          //BookMainPage.bookManagerHolder?.notify();
        },
        onDelete: () {
          setState(() {
            widget.model.textureType.set(TextureType.none);
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
      ),
    );
  }

  Widget _pageTransition() {
    //logger.severe('pageTransition=${widget.model.transitionEffect.value}');
    List<AnimationType> animations =
        AnimationType.toAniListFromInt(widget.model.transitionEffect.value);
    String trails = '';
    for (var ele in animations) {
      logger.finest('animationTy=[$ele]');
      if (trails.isNotEmpty) {
        trails += "+";
      }
      trails += CretaLang['animationTypes']![ele.index];
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: _isTransitionOpen,
        onPressed: () {
          setState(() {
            _isTransitionOpen = !_isTransitionOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['ani']!, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: SizedBox(
          width: 140,
          child: Text(
            trails,
            textAlign: TextAlign.right,
            style: CretaFont.titleSmall.copyWith(overflow: TextOverflow.fade),
          ),
        ),
        hasRemoveButton: widget.model.transitionEffect.value != 0,
        onDelete: () {
          setState(() {
            widget.model.transitionEffect.set(0);
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
        bodyWidget: _transitionBody(),
      ),
    );
  }

  Widget _transitionBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (int i = 1; i < AnimationType.end.index; i++)
                AniExampleBox(
                    key: ValueKey('frame=${AnimationType.values[i].name}+${_isSelect(i)}'),
                    model: widget.model,
                    name: CretaLang['animationTypes']![i],
                    aniType: AnimationType.values[i],
                    selected: _isSelect(i),
                    onSelected: () {
                      setState(() {});
                      _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
                      //BookMainPage.bookManagerHolder!.notify();
                    }),
              // AniExampleBox(model: widget.model, name: CretaStudioLang['flip']!, aniType: AnimationType.flip),
              // AniExampleBox(model: widget.model, name: CretaStudioLang['shake']!, aniType: AnimationType.shake),
              // AniExampleBox(model: widget.model, name: CretaStudioLang['shimmer']!, aniType: AnimationType.shimmer),
            ],
          ),
          _speed(),
          _delay(),
          _repeat(),
          _reverse(),
        ],
      ),
    );
  }

  // 속도 슬라이더 바
  Widget _speed() {
    double duration = widget.model.aniDuration.value.toDouble() / 100.0;
    if (duration > 100) duration = 100;
    return propertyLine(
      name: CretaStudioLang['speed']!,
      widget: CretaExSlider(
          valueType: SliderValueType.normal,
          value: duration,
          onChanngeComplete: (val) {
            //setState(() {
            widget.model.aniDuration.set(val.round() * 100);
            //});
            //_frameManager?.notify();
            //_sendEvent!.sendEvent(widget.model);
            _invalidateFrame();
          },
          onChannged: (val) {},
          min: 0,
          max: 100),
    );
  } // delay 슬라이더 바

  Widget _delay() {
    double delay = widget.model.aniDelay.value.toDouble() / 100;
    if (delay > 100) delay = 100;
    return propertyLine(
      name: CretaStudioLang['delay']!,
      widget: CretaExSlider(
        valueType: SliderValueType.normal,
        value: delay,
        onChanngeComplete: (val) {
          //setState(() {
          widget.model.aniDelay.set(val.round() * 100);
          //});
          //_frameManager?.notify();
          //_sendEvent!.sendEvent(widget.model);
          _invalidateFrame();
        },
        onChannged: (val) {},
        min: 0,
        max: 100,
      ),
    );
  }

  // 무한반복 Toggle Button
  Widget _repeat() {
    int oldRepeatCount = widget.model.aniRepeat.value;
    return Padding(
      padding: const EdgeInsets.only(
        top: 6, /*left: 30, right: 24*/
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisAlignment: (widget.model.aniRepeat.value != 0)
        //     ? MainAxisAlignment.spaceBetween
        //     : MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: propertyLine(
              name: CretaStudioLang['repeatOrOnce']!,
              widget: CretaToggleButton(
                width: 54 * 0.75,
                height: 28 * 0.75,
                defaultValue: (widget.model.aniRepeat.value == 0),
                onSelected: (value) {
                  widget.model.aniRepeat.set(value == true
                      ? 0
                      : oldRepeatCount == 0
                          ? 1
                          : oldRepeatCount);
                  //_sendEvent?.sendEvent(widget.model);
                  //_frameManager?.notify();
                  _invalidateFrame();
                  setState(() {});
                },
              ),
            ),
          ),
          if (widget.model.aniRepeat.value != 0)
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: SizedBox(
                width: 120,
                child: propertyLine(
                  name: CretaStudioLang['repeatCount']!,
                  widget: CretaTextField.shortNumber(
                    width: 50,
                    defaultBorder: Border.all(color: CretaColor.text[100]!),
                    textFieldKey: GlobalKey(),
                    value: widget.model.aniRepeat.value.toString(),
                    hintText: '',
                    onEditComplete: ((value) {
                      widget.model.aniRepeat.set(int.parse(value));
                      //_sendEvent?.sendEvent(widget.model);
                      //_frameManager?.notify();
                      //setState(() {});
                      _invalidateFrame();
                      setState(() {});
                    }),
                    minNumber: 0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 리버스 Toggle Button
  Widget _reverse() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 6, /*left: 30, right: 24*/
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisAlignment: (widget.model.aniRepeat.value != 0)
        //     ? MainAxisAlignment.spaceBetween
        //     : MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: propertyLine(
              name: CretaStudioLang['reverseMove']!,
              widget: CretaToggleButton(
                width: 54 * 0.75,
                height: 28 * 0.75,
                defaultValue: widget.model.aniReverse.value,
                onSelected: (value) {
                  widget.model.aniReverse.set(value);
                  //_sendEvent?.sendEvent(widget.model);
                  //_frameManager?.notify();
                  _invalidateFrame();
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSelect(int i) {
    return AnimationType.values[i].value & widget.model.transitionEffect.value ==
        AnimationType.values[i].value;
  }

  Widget _border() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: _isBorderOpen,
        onPressed: () {
          setState(() {
            _isBorderOpen = !_isBorderOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['border']!, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: widget.model.borderWidth.value == 0
            ? SizedBox.shrink()
            : colorIndicator(
                widget.model.borderColor.value,
                1.0,
                onColorChanged: (color) {
                  widget.model.borderColor.set(color);
                  _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
                },
                onClicked: () {
                  setState(() {
                    _isBorderOpen = true;
                  });
                },
              ),
        hasRemoveButton: widget.model.borderWidth.value != 0,
        onDelete: () {
          setState(() {
            widget.model.borderWidth.set(0);
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
        bodyWidget: _borderBody(
            color1: widget.model.borderColor.value,
            borderWidth: widget.model.borderWidth.value,
            onBorderWidthChanged: (value) {
              widget.model.borderWidth.set(value);
              logger.finest('borderWidth=${widget.model.borderWidth.value}');
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
              setState(() {});
            },
            onBorderWidthChangeComplete: (value) {
              setState(() {});
            },
            onColor1Changed: (color) {
              setState(() {
                widget.model.borderColor.set(color);
              });
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
            },
            // onPositionChanged: (value) {
            //   int idx = 1;
            //   for (String val in CretaStudioLang['borderPositionList']!.values) {
            //     if (value == val) {
            //       widget.model.borderPosition.set(BorderPositionType.values[idx]);
            //     }
            //     idx++;
            //   }
            //   _invalidateFrame();  // _sendEvent!.sendEvent(widget.model);;
            // },
            onPositionChanged: (value) {
              int idx = 1;
              for (String val in CretaStudioLang['borderCapList']!.values) {
                if (value == val) {
                  widget.model.borderCap.set(BorderCapType.values[idx]);
                }
                idx++;
              }
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
            },
            onStyleChanged: (value) {
              if (value == null || value == 0) {
                widget.model.borderType.set(0);
              } else {
                widget.model.borderType.set(value);
              }
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
            }),
      ),
    );
  }

  Widget _borderBody({
    required Color color1,
    required double borderWidth,
    required void Function(double) onBorderWidthChanged,
    required void Function(double) onBorderWidthChangeComplete,
    required void Function(String) onPositionChanged,
    required void Function(int?) onStyleChanged,
    required Function(Color) onColor1Changed,
  }) {
    return Column(
      children: [
        //_gradationButton(),
        propertyLine(
          // 보더 색
          name: CretaStudioLang['color']!,
          widget: colorIndicator(color1, 1.0, onColorChanged: onColor1Changed, onClicked: () {}),
        ),

        CretaPropertySlider(
          // 보더 두께
          name: CretaStudioLang['borderWidth']!,
          min: 0,
          max: 36,
          value: borderWidth,
          valueType: SliderValueType.normal,
          onChannged: onBorderWidthChanged,
          //onChanngeComplete: onBorderWidthChangeComplete,
          onChanngeComplete: onBorderWidthChanged,
        ),

        // 보더 마감
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CretaStudioLang['borderCap']!, style: titleStyle),
              CretaTabButton(
                onEditComplete: onPositionChanged,
                width: 75,
                height: 24,
                selectedTextColor: CretaColor.primary,
                unSelectedTextColor: CretaColor.text[700]!,
                selectedColor: Colors.white,
                unSelectedColor: CretaColor.text[100]!,
                selectedBorderColor: CretaColor.primary,
                defaultString: _getBorderCap(),
                buttonLables: CretaStudioLang['borderCapList']!.keys.toList(),
                buttonValues: [...CretaStudioLang['borderCapList']!.values.toList()],
              ),
            ],
          ),
        ),

        // 보더 스타일
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CretaStudioLang['style']!, style: titleStyle),
              // CretaImageDropDown(
              //   imageList: _imageList,
              //   defaultValue: widget.model.borderType.value,
              //   onChanged: onStyleChanged,
              //   width: 180,
              //   height: 24,
              // ),
              CretaWidgetDropDown(
                items: [
                  choiceStringElement(CretaStudioLang['noBorder']!, 156, 30),
                  ...CretaCommonUtils.borderStyle.map((e) {
                    return _borderStyle(156, 10, e[0], e[1]);
                  }).toList(),
                ],
                defaultValue: widget.model.borderType.value,
                onSelected: onStyleChanged,
                width: boderStyleDropBoxWidth,
                height: 32,
              ),
            ],
          ),
        ),
        if (widget.model.borderWidth.value > 0)
          // Glowing 효과
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: propertyLine(
              topPadding: 10,
              name: CretaStudioLang['glowingBorder']!,
              widget: CretaExSlider(
                valueType: SliderValueType.normal,
                value: widget.model.glowSize.value.toDouble(),
                onChanngeComplete: (val) {
                  widget.model.glowSize.set(val.round());
                  _invalidateFrame();
                },
                onChannged: (val) {},
                min: 0,
                max: 70,
              ),
            ),
          ),
      ],
    );
  }

  // String _getBorderPostion() {
  //   switch (widget.model.borderPosition.value) {
  //     case BorderPositionType.inSide:
  //       return 'inSide';
  //     case BorderPositionType.outSide:
  //       return 'outSide';
  //     default:
  //       return 'center';
  //   }
  // }

  String _getBorderCap() {
    switch (widget.model.borderCap.value) {
      case BorderCapType.miter:
        return 'miter';
      case BorderCapType.bevel:
        return 'bevel';
      default:
        return 'round';
    }
  }

  Widget _shadow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: _isShadowOpen,
        onPressed: () {
          setState(() {
            _isShadowOpen = !_isShadowOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['shadow']!, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: widget.model.isNoShadow()
            ? SizedBox.shrink()
            : ShadowIndicator(
                color: widget.model.shadowColor.value,
                spread: widget.model.shadowSpread.value,
                blur: widget.model.shadowBlur.value,
                direction: widget.model.shadowDirection.value,
                distance: widget.model.shadowOffset.value,
                opacity: CretaCommonUtils.validCheckDouble(widget.model.shadowOpacity.value, 0, 1),
                isSelected: false,
                width: 24,
                height: 24,
                isSample: true,
                onTapPressed: (spread, blur, direction, distance, opacity) {
                  setState(() {
                    _isShadowOpen = !_isShadowOpen;
                  });
                },
              ),
        hasRemoveButton: widget.model.isNoShadow() == false,
        onDelete: () {
          setState(() {
            mychangeStack.startTrans();
            widget.model.shadowSpread.set(0);
            widget.model.shadowBlur.set(0);
            widget.model.shadowDirection.set(0);
            widget.model.shadowOffset.set(0);
            widget.model.shadowColor.set(Colors.transparent);
            mychangeStack.endTrans();
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
        bodyWidget: _shodowBody(
            shadowColor: widget.model.shadowColor.value,
            shadowOpacity: widget.model.shadowOpacity.value,
            shadowSpread: widget.model.shadowSpread.value,
            shadowBlur: widget.model.shadowBlur.value,
            shadowDirection: widget.model.shadowDirection.value,
            shadowOffset: widget.model.shadowOffset.value,
            onColorChanged: (color) {
              setState(() {
                widget.model.shadowColor.set(color);
              });
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
            },
            onOpacityChanged: (value) {
              widget.model.shadowOpacity.set(value);
              logger.finest('shadowOpacity=${widget.model.shadowOpacity.value}');
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
            },
            onSpreadChanged: (value) {
              widget.model.shadowSpread.set(value);
              logger.finest('shadowSpread=${widget.model.shadowSpread.value}');
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
            },
            onBlurChanged: (value) {
              widget.model.shadowBlur.set(value);
              logger.finest('shadowBlur=${widget.model.shadowBlur.value}');
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
            },
            onDirectionChanged: (value) {
              widget.model.shadowDirection.set(value);
              logger.finest('shadowDirection=${widget.model.shadowDirection.value}');
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
            },
            onOffsetChanged: (value) {
              widget.model.shadowOffset.set(value);
              logger.finest('shadowOffset=${widget.model.shadowOffset.value}');
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
            },
            onShadowSampleSelected: (spread, blur, direction, distance, opactiy) {
              logger.fine('spread=$spread, blur=$blur, direction=$direction, distance=$distance,');
              setState(() {
                mychangeStack.startTrans();
                widget.model.shadowSpread.set(spread, save: false);
                widget.model.shadowBlur.set(blur, save: false);
                widget.model.shadowDirection.set(direction, save: false);
                widget.model.shadowOffset.set(distance, save: false);
                widget.model.shadowOpacity.set(opactiy, save: false);
                widget.model.save();
                mychangeStack.endTrans();
              });
              _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
            }

            // onOpacityChangeComplete: (value) {
            //   setState(() {});
            // },
            // onSpreadChangeComplete: (value) {
            //   setState(() {});
            // },
            // onBlurChangeComplete: (value) {
            //   setState(() {});
            // },
            // onDirectionChangeComplete: (value) {
            //   setState(() {});
            // },
            // onOffsetChangeComplete: (value) {
            //   setState(() {});
            // },
            ),
      ),
    );
  }

  Widget _shodowBody({
    required Color shadowColor,
    required double shadowOpacity,
    required double shadowSpread,
    required double shadowBlur,
    required double shadowDirection,
    required double shadowOffset,
    required Function(Color) onColorChanged,
    required Function(double) onOpacityChanged,
    required Function(double) onSpreadChanged,
    required Function(double) onBlurChanged,
    required Function(double) onDirectionChanged,
    required Function(double) onOffsetChanged,
    required final void Function(
      double spread,
      double blur, //'assets/grid.png'
      double direction, //'assets/grid.png'
      double distance,
      double opacity,
    ) onShadowSampleSelected,
    // required Function(double) onOpacityChangeComplete,
    // required Function(double) onSpreadChangeComplete,
    // required Function(double) onBlurChangeComplete,
    // required Function(double) onDirectionChangeComplete,
    // required Function(double) onOffsetChangeComplete,
  }) {
    return Column(
      children: [
        //_shadowExampleButton(shadowColor, shadowOpacity, shadowSpread, shadowBlur,shadowDirection),

        propertyLine(
          // 그림자 색
          name: CretaStudioLang['color']!,
          widget: colorIndicator(
            shadowColor,
            CretaCommonUtils.validCheckDouble(shadowOpacity, 0, 1),
            onColorChanged: onColorChanged,
            onClicked: () {
              setState(() {
                _isShadowOpen = true;
              });
            },
          ),
        ),
        // // 안쪽 그림자 / 바깥쪽 그림자
        // Padding(
        //   padding: const EdgeInsets.only(top: 20.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(CretaStudioLang['shadowIn']!, style: titleStyle),
        //       CretaTabButton(
        //         onEditComplete: onShadowInChanged,
        //         width: 90,
        //         height: 24,
        //         selectedTextColor: CretaColor.primary,
        //         unSelectedTextColor: CretaColor.text[700]!,
        //         selectedColor: Colors.white,
        //         unSelectedColor: CretaColor.text[100]!,
        //         selectedBorderColor: CretaColor.primary,
        //         defaultString: shadowIn ? 'inSide' : 'outSide',
        //         buttonLables: CretaStudioLang['shadowInList']!.keys.toList(),
        //         buttonValues: CretaStudioLang['shadowInList']!.values.toList(),
        //       ),
        //     ],
        //   ),
        // ),
        _shadowListView(
          widget.model,
          onShadowSampleSelected,
        ),

        if (_isCustom)
          CretaPropertySlider(
            // 그림자 투명도
            key: GlobalKey(),
            name: CretaStudioLang['opacity']!,
            min: 0,
            max: 100,
            value: CretaCommonUtils.validCheckDouble(shadowOpacity, 0, 1),
            valueType: SliderValueType.reverse,
            onChannged: onOpacityChanged,
            onChanngeComplete: onOpacityChanged,
            //onChanngeComplete: onOpacityChangeComplete,
            postfix: '%',
          ),
        if (_isCustom)
          CretaPropertySlider(
            // 그림자 크기
            key: GlobalKey(),
            name: CretaStudioLang['spread']!,
            min: 0,
            max: 100,
            value: shadowSpread,
            valueType: SliderValueType.normal,
            onChannged: onSpreadChanged,
            onChanngeComplete: onSpreadChanged,
            //onChanngeComplete: onSpreadChangeComplete,
          ),
        if (_isCustom)
          CretaPropertySlider(
            // 그림자 블러
            key: GlobalKey(),
            name: CretaStudioLang['blur']!,
            min: 0,
            max: 24,
            value: shadowBlur,
            valueType: SliderValueType.normal,
            onChannged: onBlurChanged,
            onChanngeComplete: onBlurChanged,
            //onChanngeComplete: onBlurChangeComplete,
          ),
        if (_isCustom)
          CretaPropertySlider(
            // 그림자 방향거리
            key: GlobalKey(),
            name: CretaStudioLang['offset']!,
            min: 0,
            max: 36,
            value: shadowOffset,
            valueType: SliderValueType.normal,
            onChannged: onOffsetChanged,
            //onChanngeComplete: onOffsetChangeComplete,
            onChanngeComplete: onOffsetChanged,
          ),
        if (_isCustom)
          CretaPropertySlider(
            // 그림자 방향각도
            key: GlobalKey(),
            name: CretaStudioLang['direction']!,
            min: 0,
            max: 360,
            value: shadowDirection,
            valueType: SliderValueType.normal,
            onChannged: onDirectionChanged,
            //onChanngeComplete: onDirectionChangeComplete,
            onChanngeComplete: onDirectionChanged,
            postfix: '˚',
          ),
      ],
    );
  }

  Widget _shadowListView(
    FrameModel model,
    Function(
      double spread,
      double blur, //'assets/grid.png'
      double direction, //'assets/grid.png'
      double distance,
      double opacity,
    ) onTapPressed,
  ) {
    List<Widget> shadowList = [];
    // // 그림자 없음 버튼
    // shadowList.add(ShadowIndicator(
    //   color: model.shadowColor.value,
    //   spread: 0,
    //   blur: 0,
    //   direction: 0,
    //   distance: 0,
    //   opacity: 0,
    //   isSelected: model.isNoShadow(),
    //   onTapPressed: onTapPressed,
    //   hintText: CretaStudioLang['nothing']!,
    // ));

    int len = CretaUtils.shadowDataList.length;

    for (int i = 0; i < len - 1; i++) {
      //logger.finest('gradient: ${GradationType.values[i].toString()}');
      ShadowData data = CretaUtils.shadowDataList[i];
      bool selected = _isSameShadow(data, model);
      if (selected) {
        _matched = true;
      }
      shadowList.add(ShadowIndicator(
        color: model.shadowColor.value,
        spread: data.spread,
        blur: data.blur,
        direction: data.direction,
        distance: data.distance,
        opacity: data.opacity,
        isSelected: selected && !_isCustom,
        onTapPressed: ((spread, blur, direction, distance, opacity) {
          setState(() {
            _isCustom = false;
          });
          onTapPressed.call(spread, blur, direction, distance, opacity);
        }),
        hintText: data.title,
      ));
    }
    if (!_matched) {
      _isCustom = true;
    }
    // 제일 마지막 커스텀 버튼
    shadowList.add(ShadowIndicator(
      color: model.shadowColor.value,
      spread: model.shadowSpread.value,
      blur: model.shadowBlur.value,
      direction: model.shadowDirection.value,
      distance: model.shadowOffset.value,
      opacity: model.opacity.value,
      isSelected: _isCustom,
      onTapPressed: ((spread, blur, direction, distance, opacity) {
        setState(() {
          _isCustom = true;
        });
        onTapPressed.call(spread, blur, direction, distance, opacity);
      }),
      hintText: CretaStudioLang['custom']!,
      showShadow: false,
    ));

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      //child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: gradientList),
      child: Wrap(
        // spacing: 1,
        // runSpacing: 1,
        children: shadowList,
      ),
    );
  }

  bool _isSameShadow(ShadowData data, FrameModel model) {
    if (data.blur == model.shadowBlur.value &&
        data.direction == model.shadowDirection.value &&
        data.distance == model.shadowOffset.value &&
        data.spread == model.shadowSpread.value) {
      logger.finest('_isSameShadow true');
      return true;
    }
    logger.finest('_isSameShadow false');
    return false;
  }

  Widget _shape() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: _isShapeOpen,
        onPressed: () {
          setState(() {
            _isShapeOpen = !_isShapeOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['shape']!, style: CretaFont.titleSmall),
        trailWidget: widget.model.shape.value == ShapeType.none
            ? const SizedBox.shrink()
            : ShapeIndicator(
                shapeType: widget.model.shape.value,
                isSelected: false,
                onTapPressed: (value) {
                  setState(() {
                    _isShapeOpen = !_isShapeOpen;
                  });
                },
                width: 24,
                height: 24,
              ),
        hasRemoveButton: widget.model.shape.value != ShapeType.none,
        onDelete: () {
          setState(() {
            widget.model.shape.set(ShapeType.none);
          });
          _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
        },
        bodyWidget: _shapeListView(
          onShapeTapPressed: (value) {
            setState(() {
              widget.model.shape.set(value);
            });
            _invalidateFrame(); // _sendEvent!.sendEvent(widget.model);;
          },
        ),
      ),
    );
  }

  Widget _shapeListView({required void Function(ShapeType value) onShapeTapPressed}) {
    List<Widget> shapeList = [];
    for (int i = 1; i < ShapeType.end.index; i++) {
      ShapeType gType = ShapeType.values[i];
      shapeList.add(ShapeIndicator(
        shapeType: gType,
        isSelected: widget.model.shape.value == gType,
        onTapPressed: onShapeTapPressed,
        width: 36,
        height: 36,
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      //child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: gradientList),
      child: Wrap(children: shapeList),
    );
  }

  Widget _event() {
    return super.event(
      cretaModel: widget.model,
      mixinModel: widget.model,
      setState: () {
        setState(() {});
      },
      sendEventWidget: _sendEventWidget(),
      visibleButton: _visibleButton(),
      durationTypeWidget: _durationTypeWidget(),
      durationWidget: _durationWidget(),
      onDelete: () {
        setState(() {
          widget.model.eventSend.set('');
          widget.model.eventReceive.set('');
        });
      },
    );
  }

  Widget _visibleButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            CretaStudioLang['showWhenEventReceived']!,
            style: titleStyle,
          ),
          CretaToggleButton(
            defaultValue: widget.model.showWhenEventReceived.value,
            onSelected: (value) {
              widget.model.showWhenEventReceived.set(value);
              _sendEvent?.sendEvent(widget.model);
              _notifyToThumbnail();
            },
          ),
        ],
      ),
    );
  }

  Widget _sendEventWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            CretaStudioLang['eventSend']!,
            style: titleStyle,
          ),
          CretaTextField.short(
            width: 210,
            defaultBorder: Border.all(color: CretaColor.text[100]!),
            textFieldKey: GlobalKey(),
            value: widget.model.eventSend.value,
            hintText: '',
            onEditComplete: ((value) {
              widget.model.eventSend.set(value);
              _sendEvent?.sendEvent(widget.model);
              _notifyToThumbnail();
            }),
            minNumber: 0,
          ),
        ],
      ),
    );
  }

  Widget _durationTypeWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 30, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(CretaStudioLang['durationType']!, style: titleStyle),
          CretaWidgetDropDown(
            items: [
              ...CretaStudioLang['durationTypeList']!.keys.map((e) {
                return choiceStringElement(e, 156, 30);
              }).toList(),
            ],
            defaultValue: getDurationType(widget.model.durationType.value),
            onSelected: (val) {
              widget.model.durationType.set(DurationType.fromInt(val + 1));
              setState(() {});
            },
            width: boderStyleDropBoxWidth,
            height: 32,
          ),
        ],
      ),
    );
  }

  Widget _durationWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 30, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(CretaStudioLang['durationSpecifiedTime']!, style: titleStyle),
          TimeInputWidget(
            textStyle: titleStyle,
            initValue: widget.model.duration.value,
            onValueChnaged: (duration) {
              widget.model.duration.set(duration.inSeconds);
            },
          ),
        ],
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
        _tagEnabled = (value == null) ? false : true;
        BookMainPage.bookManagerHolder!.notify();
      },
      onDeleted: (value) {
        BookMainPage.bookManagerHolder!.notify();
      },
      limit: StudioConst.maxTextLimit - 2,
      enabled: _tagEnabled,
      rest: rest > 0 ? rest - 1 : 0,
    );
  }

  void _setOverlay(bool value) {
    if (_frameManager == null) {
      logger.fine('frameManager is null');
      return;
    }
    setState(() {
      FrameModelUtil.toggeleOverlay(value, _frameManager!, widget.model);
    });
    _sendEvent?.sendEvent(widget.model);
    _notifyToThumbnail();
    //BookMainPage.pageManagerHolder!.notify();
  }

/*
  Widget _eventBody() {
    //return Column(children: [
    //Text(CretaStudioLang['pageSize']!, style: CretaFont.titleSmall),
    List<String> hashTagList = CretaCommonUtils.jsonStringToList(widget.model.eventReceive.value);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
// 첫번쨰 줄  sendEvent
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CretaStudioLang['eventSend']!,
                style: titleStyle,
              ),
              CretaTextField.short(
                width: 210,
                defaultBorder: Border.all(color: CretaColor.text[100]!),
                textFieldKey: GlobalKey(),
                value: widget.model.eventSend.value,
                hintText: '',
                onEditComplete: ((value) {
                  widget.model.eventSend.set(value);
                  _sendEvent?.sendEvent(widget.model);
                }),
                minNumber: 0,
              ),
            ],
          ),
        ),
        // 두번쨰 줄,  receiveEvent
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CretaStudioLang['eventReceived']!,
                style: titleStyle,
              ),
              // CretaTextField.short(
              //   width: 210,
              //   defaultBorder: Border.all(color: CretaColor.text[100]!),
              //   textFieldKey: GlobalKey(),
              //   value: widget.model.eventSend.value,
              //   hintText: '',
              //   onEditComplete: ((value) {
              //     widget.model.eventReceive.set(value);
              //     _sendEvent?.sendEvent(widget.model);
              //   }),
              //   minNumber: 0,
              // ),
              SizedBox(
                width: 210,
                child: tagWidget(
                  hashTagList: hashTagList,
                  onTagChanged: (newValue) {
                    setState(() {
                      hashTagList.add(newValue);
                      String val = CretaCommonUtils.listToString(hashTagList);
                      logger.fine('eventReceive=$val');
                      widget.model.eventReceive.set(val);
                    });
                    logger.fine('onTagChanged $newValue input');

                    _sendEvent?.sendEvent(widget.model);
                  },
                  onSubmitted: (outstandingValue) {
                    setState(() {
                      hashTagList.add(outstandingValue);
                      String val = CretaCommonUtils.listToString(hashTagList);
                      logger.fine('eventReceive=$val');
                      widget.model.eventReceive.set(val);
                      logger.fine('onSubmitted $outstandingValue input');
                    });

                    _sendEvent?.sendEvent(widget.model);
                  },
                  onDeleted: (idx) {
                    setState(() {
                      hashTagList.removeAt(idx);
                      String val = CretaCommonUtils.listToString(hashTagList);
                      widget.model.eventReceive.set(val);
                      logger.finest('onDelete $idx');
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(top: 12, left: 30, right: 30),
        //   child:
        // ),
        // 세번쨰 줄,  이벤트를 받았을 때만 등장,  평소에도 등장
        widget.model.eventReceive.value.length > 2
            //widget.model.eventReceive.value.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CretaStudioLang['showWhenEventReceived']!,
                      style: titleStyle,
                    ),
                    CretaToggleButton(
                      defaultValue: widget.model.showWhenEventReceived.value,
                      onSelected: (value) {
                        widget.model.showWhenEventReceived.set(value);
                        _sendEvent?.sendEvent(widget.model);
                      },
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
        // 네번쨰 줄,
        //  등장후 지속시간 :  영구히,  콘텐츠가 끝날때까지, 지정된 시간동안
        widget.model.eventReceive.value.length > 2
            //widget.model.eventReceive.value.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 8, left: 30, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(CretaStudioLang['durationType']!, style: titleStyle),
                    CretaWidgetDropDown(
                      items: [
                        ...CretaStudioLang['durationTypeList']!.keys.map((e) {
                          return _choiceStringElement(e, 156, 30);
                        }).toList(),
                      ],
                      defaultValue: _getDurationType(),
                      onSelected: (val) {
                        widget.model.durationType.set(DurationType.fromInt(val + 1));
                        setState(() {});
                      },
                      width: boderStyleDropBoxWidth,
                      height: 32,
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
        widget.model.durationType.value == DurationType.specified
            ? Padding(
                padding: const EdgeInsets.only(top: 8, left: 30, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(CretaStudioLang['durationSpecifiedTime']!, style: titleStyle),
                    TimeInputWidget(
                      textStyle: titleStyle,
                      initValue: widget.model.duration.value,
                      onValueChnaged: (duration) {
                        widget.model.duration.set(duration.inSeconds);
                      },
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
  */
}

class AniExampleBox extends StatefulWidget {
  final FrameModel model;
  final String name;
  final AnimationType aniType;
  final bool selected;
  final Function onSelected;
  const AniExampleBox({
    super.key,
    required this.name,
    required this.aniType,
    required this.model,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<AniExampleBox> createState() => _AniExampleBoxState();
}

class _AniExampleBoxState extends State<AniExampleBox> with ExampleBoxStateMixin {
  @override
  void initState() {
    super.initMixin(widget.selected);
    super.initState();
  }

  void onSelected() {
    setState(() {
      // 여러개를 동시 적용하던것에서, 그냥 하나만 적용하는 것을 바꿈.
      //widget.model.transitionEffect.set(widget.model.transitionEffect.value | widget.aniType.value);
      widget.model.transitionEffect.set(widget.aniType.value);
    });
    widget.onSelected.call();
  }

  void onUnselected() {
    setState(() {
      int newVal = widget.model.transitionEffect.value - widget.aniType.value;
      if (newVal < 0) newVal = 0;
      widget.model.transitionEffect.set(newVal);
    });
    widget.onSelected.call();
  }

  void onNormalSelected() {
    setState(() {
      widget.model.transitionEffect.set(0);
      logger.finest('pageTrasitionValue = ${widget.model.transitionEffect.value}');
    });
    widget.onSelected.call();
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //return _selectAnimation();
    return super.buildMixin(context,
        setState: rebuild,
        onSelected: onSelected,
        onUnselected: onUnselected,
        selectWidget: selectWidget);
  }

  Widget selectWidget() {
    switch (widget.aniType) {
      case AnimationType.fadeIn:
        return isAni() ? _aniBox().fadeIn() : normalBox(widget.name);
      case AnimationType.flip:
        return isAni() ? _aniBox().flip() : normalBox(widget.name);
      case AnimationType.shake:
        return isAni() ? _aniBox().shake() : normalBox(widget.name);
      case AnimationType.blurXY:
        return isAni() ? _aniBox().blurXY() : normalBox(widget.name);
      case AnimationType.scaleXY:
        return isAni() ? _aniBox().scaleXY() : normalBox(widget.name);
      case AnimationType.rotate:
        return isAni() ? _aniBox().rotate() : normalBox(widget.name);
      case AnimationType.slideX:
        return isAni() ? _aniBox().slideX() : normalBox(widget.name);
      case AnimationType.slideY:
        return isAni() ? _aniBox().slideY() : normalBox(widget.name);
      default:
        return noAnimation(widget.name, onNormalSelected: onNormalSelected);
    }
  }

  Animate _aniBox() {
    return normalBox(widget.name).animate(
        onPlay: (controller) => controller.loop(
            period: Duration(
              milliseconds: 1000,
            ),
            count: 3,
            reverse: true));
  }
}
