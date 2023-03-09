// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/buttons/creta_tab_button.dart';
import '../../../../design_system/buttons/creta_toggle_button.dart';
import '../../../../design_system/component/colorPicker/shadow_indicator.dart';
import '../../../../design_system/component/creta_proprty_slider.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/menu/creta_widget_drop_down.dart';
import '../../../../design_system/text_field/creta_text_field.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/frame_model.dart';
import '../../book_main_page.dart';
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
  const FrameProperty({super.key, required this.model});

  @override
  State<FrameProperty> createState() => _FramePropertyState();
}

class _FramePropertyState extends State<FrameProperty> with PropertyMixin {
  // ignore: unused_field
  //late ScrollController _scrollController;
  final double horizontalPadding = 24;
  final double boderStyleDropBoxWidth = 224;
  // ignore: unused_field
  // ignore: unused_field
  FrameManager? _frameManager;
  static bool _isTransitionOpen = false;
  static bool _isBorderOpen = false;
  static bool _isShadowOpen = false;
  static bool _isSizeOpen = false;
  static bool _isRadiusOpen = false;
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

  Widget _noBorder(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Text(
          CretaStudioLang.noBorder,
          textAlign: TextAlign.center,
          style: CretaFont.titleSmall,
        ),
      ),
    );
  }

  @override
  void initState() {
    logger.fine('_FramePropertyState.initState');

    super.initMixin();
    super.initState();

    _isRadiusOpen = !(widget.model.radiusLeftBottom.value == widget.model.radiusRightBottom.value &&
        widget.model.radiusRightBottom.value == widget.model.radiusLeftTop.value &&
        widget.model.radiusLeftTop.value == widget.model.radiusRightTop.value);

    final FrameEventController sendEvent = Get.find(tag: 'frame-property-to-main');
    _sendEvent = sendEvent;
    final FrameEventController receiveEvent = Get.find(tag: 'frame-main-to-property');
    _receiveEvent = receiveEvent;

    logger.fine(
        'spread=${widget.model.shadowSpread.value}, blur=${widget.model.shadowBlur.value},direction=${widget.model.shadowDirection.value}, distance=${widget.model.shadowOffset.value}');
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _model = BookMainPage.pageManagerHolder!.getSelectedFrame();
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
    logger.fine(
        'build : spread=${widget.model.shadowSpread.value}, blur=${widget.model.shadowBlur.value},direction=${widget.model.shadowDirection.value}, distance=${widget.model.shadowOffset.value}');
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: _pageSize(),
      ),
      propertyDivider(),
      _pageColor(),
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
    ]);
    //});
  }

  Widget _pageSize() {
    return StreamBuilder<FrameModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.mid == widget.model.mid) {
            snapshot.data!.copyTo(widget.model);
          }

          double height = widget.model.height.value;
          double width = widget.model.width.value;

          if (BookMainPage.containeeNotifier!.isOpenSize) {
            _isSizeOpen = true;
          }

          return propertyCard(
            padding: horizontalPadding,
            isOpen: _isSizeOpen,
            onPressed: () {
              setState(() {
                _isSizeOpen = !_isSizeOpen;
                BookMainPage.containeeNotifier!.setOpenSize(_isSizeOpen);
              });
            },
            titleWidget: Text(CretaStudioLang.frameSize, style: CretaFont.titleSmall),
            trailWidget: Text('${width.round()} x ${height.round()}', style: dataStyle),
            bodyWidget: _pageSizeBody(width, height),
          );
        });
  }

  Widget _pageSizeBody(double width, double height) {
    //return Column(children: [
    //Text(CretaStudioLang.pageSize, style: CretaFont.titleSmall),
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
                      CretaStudioLang.posX,
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
                        widget.model.posX.set(int.parse(value).toDouble());
                        _sendEvent?.sendEvent(widget.model);
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
                      CretaStudioLang.posY,
                      style: titleStyle,
                    ),
                    CretaTextField.xshortNumber(
                      defaultBorder: Border.all(color: CretaColor.text[100]!),
                      width: 45,
                      limit: 5,
                      textFieldKey: GlobalKey(),
                      value: widget.model.posY.value.round().toString(),
                      hintText: '',
                      minNumber: 0,
                      onEditComplete: ((value) {
                        widget.model.posY.set(int.parse(value).toDouble());
                        _sendEvent?.sendEvent(widget.model);
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                    SizedBox(
                      width: 97,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            CretaStudioLang.width,
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
                              _sizeChanged(value, widget.model.width, widget.model.height);
                            }),
                            minNumber: 10,
                          ),
                        ],
                      ),
                    ),
                    BTN.fill_gray_i_m(
                        tooltip: CretaStudioLang.fixedRatio,
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
                        }),
                    SizedBox(
                      width: 97,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            CretaStudioLang.height,
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
                            minNumber: 10,
                            onEditComplete: ((value) {
                              _sizeChanged(value, widget.model.height, widget.model.width);
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BTN.fill_gray_i_m(
                  tooltip: CretaStudioLang.fullscreenTooltip,
                  tooltipBg: CretaColor.text[400]!,
                  iconSize: 18,
                  icon: Icons.fullscreen_outlined,
                  onPressed: () {
                    BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
                    if (book == null) return;
                    if (_isFullScreen(book)) return;
                    setState(() {
                      mychangeStack.startTrans();
                      widget.model.height.set(book.height.value);
                      widget.model.width.set(book.width.value);
                      widget.model.posX.set(0);
                      widget.model.posY.set(0);
                      mychangeStack.endTrans();
                    });
                    logger.finest('sendEvent');
                    _sendEvent!.sendEvent(widget.model);
                  }),
            ],
          ),
        ),
        // 세번째 줄  rotate
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
                      CretaStudioLang.angle,
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
                        logger.fine('onEditComplete $value');
                        double newValue = int.parse(value).toDouble();
                        if (widget.model.angle.value == newValue) {
                          return;
                        }
                        widget.model.angle.set(newValue);
                        //BookMainPage.bookManagerHolder!.notify();
                        _sendEvent!.sendEvent(widget.model);
                        logger.fine('onEditComplete ${widget.model.angle.value}');
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
              SizedBox(width: 17),
              BTN.fill_gray_i_m(
                  tooltip: CretaStudioLang.angleTooltip,
                  tooltipBg: CretaColor.text[400]!,
                  iconSize: 18,
                  icon: Icons.rotate_90_degrees_ccw_outlined,
                  onPressed: () {
                    setState(() {
                      int turns = (widget.model.angle.value / 45).round() - 1;
                      double angle = (turns * 45.0) % 360;
                      if (angle < 0) {
                        angle = 360 - angle;
                      }
                      widget.model.angle.set(angle);
                    });
                    logger.finest('sendEvent');
                    _sendEvent!.sendEvent(widget.model);
                  }),
              BTN.fill_gray_i_m(
                  tooltip: CretaStudioLang.angleTooltip,
                  tooltipBg: CretaColor.text[400]!,
                  iconSize: 18,
                  icon: Icons.rotate_90_degrees_cw_outlined,
                  onPressed: () {
                    setState(() {
                      int turns = (widget.model.angle.value / 45).round() + 1;
                      widget.model.angle.set((turns * 45.0) % 360);
                    });

                    logger.finest('sendEvent');
                    _sendEvent!.sendEvent(widget.model);
                  }),
            ],
          ),
        ),
        // 네번째 줄  radius
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
                      CretaStudioLang.radius,
                      style: titleStyle,
                    ),
                    CretaTextField.xshortNumber(
                      maxNumber: 360,
                      defaultBorder: Border.all(color: CretaColor.text[100]!),
                      width: 45,
                      limit: 5,
                      textFieldKey: GlobalKey(),
                      value: widget.model.radius.value.round().toString(),
                      hintText: '',
                      onEditComplete: ((value) {
                        logger.fine('onEditComplete $value');
                        double newValue = int.parse(value).toDouble();
                        if (widget.model.radius.value == newValue) {
                          return;
                        }
                        mychangeStack.startTrans();
                        widget.model.radius.set(newValue);
                        widget.model.radiusLeftTop.set(newValue);
                        widget.model.radiusRightTop.set(newValue);
                        widget.model.radiusRightBottom.set(newValue);
                        widget.model.radiusLeftBottom.set(newValue);
                        mychangeStack.endTrans();
                        //BookMainPage.bookManagerHolder!.notify();
                        _sendEvent!.sendEvent(widget.model);
                        logger.fine('onEditComplete ${widget.model.radius.value}');
                      }),
                      minNumber: 0,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 17),
              BTN.fill_gray_i_m(
                  tooltip: CretaStudioLang.cornerTooltip,
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
                            onEditComplete: ((value) {}),
                            onSelected: (name, value, nvMap) {},
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _cornerRadius(
                            cornerValue: widget.model.radiusLeftBottom,
                            onEditComplete: ((value) {}),
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
                            onEditComplete: ((value) {}),
                            onSelected: (name, value, nvMap) {},
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _cornerRadius(
                            cornerValue: widget.model.radiusRightBottom,
                            onEditComplete: ((value) {}),
                            onSelected: (name, value, nvMap) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),

        // 다선번째 줄  autofit
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CretaStudioLang.autoFitContents,
                style: titleStyle,
              ),
              CretaToggleButton(
                defaultValue: widget.model.isAutoFit.value,
                onSelected: (value) {
                  widget.model.isAutoFit.set(value);
                  _sendEvent?.sendEvent(widget.model);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cornerRadius({
    // required bool isLeftWidget,
    // required CornerOpenFlag openFlag,
    required UndoAble<double> cornerValue,
    required void Function(String) onEditComplete,
    required void Function(String, bool, Map<String, bool>) onSelected,
  }) {
    return CretaTextField.xshortNumber(
      //enabled: openFlag.value,
      align: TextAlign.center,
      maxNumber: 360,
      defaultBorder: Border.all(color: CretaColor.text[100]!),
      width: 45,
      limit: 5,
      textFieldKey: GlobalKey(),
      value: cornerValue.value.round().toString(),
      hintText: '',
      onEditComplete: ((value) {
        logger.fine('onEditComplete $value');
        double newValue = int.parse(value).toDouble();
        if (cornerValue.value == newValue) {
          return;
        }
        cornerValue.set(newValue);
        //BookMainPage.bookManagerHolder!.notify();
        _sendEvent!.sendEvent(widget.model);
        logger.fine('onEditComplete ${cornerValue.value}');
        onEditComplete.call(value);
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
    //           logger.fine('onEditComplete $value');
    //           double newValue = int.parse(value).toDouble();
    //           if (cornerValue.value == newValue) {
    //             return;
    //           }
    //           cornerValue.set(newValue);
    //           //BookMainPage.bookManagerHolder!.notify();
    //           _sendEvent!.sendEvent(widget.model);
    //           logger.fine('onEditComplete ${cornerValue.value}');
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
    //             _sendEvent!.sendEvent(widget.model);
    //             logger.fine('onEditComplete ${cornerValue.value}');
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
    //           _sendEvent!.sendEvent(widget.model);
    //           logger.fine('onEditComplete ${cornerValue.value}');
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
    //         logger.fine('onEditComplete $value');
    //         double newValue = int.parse(value).toDouble();
    //         if (cornerValue.value == newValue) {
    //           return;
    //         }
    //         cornerValue.set(newValue);
    //         //BookMainPage.bookManagerHolder!.notify();
    //         _sendEvent!.sendEvent(widget.model);
    //         logger.fine('onEditComplete ${cornerValue.value}');
    //         onEditComplete.call(value);
    //       }),
    //       minNumber: 0,
    //     ),
    //   ],q
    // );
  }

  // Wdiget _eachCorner()
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
  //                         logger.fine('onEditComplete $value');
  //                         double newValue = int.parse(value).toDouble();
  //                         if (widget.model.radiusLeftTop.value == newValue) {
  //                           return;
  //                         }
  //                         widget.model.radiusLeftTop.set(newValue);
  //                         //BookMainPage.bookManagerHolder!.notify();
  //                         _sendEvent!.sendEvent(widget.model);
  //                         logger.fine('onEditComplete ${widget.model.radiusLeftTop.value}');
  //                       }),
  //                       minNumber: 0,
  //                     ),
  //                   ],
  //                 ),
  //               );
  // }

  bool _isFullScreen(BookModel book) {
    if (widget.model.width.value == book.width.value &&
        widget.model.width.value == book.height.value &&
        widget.model.posX.value == 0 &&
        widget.model.posY.value == 0) {
      return true;
    }
    return false;
  }

  void _sizeChanged(
    String value,
    UndoAble<double> targetAttr,
    UndoAble<double> counterAttr,
  ) {
    logger.fine('onEditComplete $value');
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
    logger.fine('onEditComplete ${targetAttr.value}');
  }

  Widget _pageColor() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: colorPropertyCard(
        title: CretaStudioLang.frameBgColor,
        color1: widget.model.bgColor1.value,
        color2: widget.model.bgColor2.value,
        opacity: widget.model.opacity.value,
        gradationType: widget.model.gradationType.value,
        cardOpenPressed: () {
          setState(() {});
        },
        onOpacityDragComplete: (value) {
          setState(() {
            widget.model.opacity.set(value);
            logger.fine('opacity1=${widget.model.opacity.value}');
          });
          _sendEvent!.sendEvent(widget.model);
        },
        onOpacityDrag: (value) {
          widget.model.opacity.set(value);
          logger.fine('opacity1=${widget.model.opacity.value}');
          _sendEvent!.sendEvent(widget.model);
        },
        onColor1Changed: (val) {
          setState(() {
            widget.model.bgColor1.set(val);
          });
          _sendEvent!.sendEvent(widget.model);
        },
        onColorIndicatorClicked: () {
          PropertyMixin.isColorOpen = true;
          setState(() {});
        },
      ),
    );
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
          _sendEvent!.sendEvent(widget.model);
        },
        onColor2Changed: (Color val) {
          setState(() {
            widget.model.bgColor2.set(val);
          });
          _sendEvent!.sendEvent(widget.model);
        },
        onColorIndicatorClicked: () {
          setState(() {
            PropertyMixin.isGradationOpen = true;
          });
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
          _sendEvent!.sendEvent(widget.model);
          //BookMainPage.bookManagerHolder?.notify();
        },
      ),
    );
  }

  Widget _pageTransition() {
    logger.finest('pageTransition=${widget.model.transitionEffect.value}');
    List<AnimationType> animations =
        AnimationType.toAniListFromInt(widget.model.transitionEffect.value);
    String trails = '';
    for (var ele in animations) {
      logger.finest('anymationTy=[$ele]');
      if (trails.isNotEmpty) {
        trails += "+";
      }
      trails += CretaStudioLang.animationTypes[ele.index];
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
        titleWidget: Text(CretaStudioLang.transitionFrame, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: SizedBox(
          width: 200,
          child: Text(
            trails,
            textAlign: TextAlign.right,
            style: CretaFont.titleSmall.copyWith(overflow: TextOverflow.fade),
          ),
        ),
        bodyWidget: _transitionBody(),
      ),
    );
  }

  Widget _transitionBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (int i = 0; i < AnimationType.end.index; i++)
            ExampleBox(
                key: GlobalKey(),
                model: widget.model,
                name: CretaStudioLang.animationTypes[i],
                aniType: AnimationType.values[i],
                selected: (i != 0 &&
                        (AnimationType.values[i].value & widget.model.transitionEffect.value ==
                            AnimationType.values[i].value) ||
                    i == 0 && widget.model.transitionEffect.value == 0),
                onSelected: () {
                  setState(() {});
                  _sendEvent!.sendEvent(widget.model);
                  //BookMainPage.bookManagerHolder!.notify();
                }),
          // ExampleBox(model: widget.model, name: CretaStudioLang.flip, aniType: AnimationType.flip),
          // ExampleBox(model: widget.model, name: CretaStudioLang.shake, aniType: AnimationType.shake),
          // ExampleBox(model: widget.model, name: CretaStudioLang.shimmer, aniType: AnimationType.shimmer),
        ],
      ),
    );
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
        titleWidget: Text(CretaStudioLang.border, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: widget.model.borderWidth.value == 0
            ? SizedBox.shrink()
            : colorIndicator(
                widget.model.borderColor.value,
                1.0,
                onColorChanged: (color) {
                  widget.model.borderColor.set(color);
                  _sendEvent!.sendEvent(widget.model);
                },
                onClicked: () {
                  setState(() {
                    _isBorderOpen = true;
                  });
                },
              ),
        bodyWidget: _borderBody(
            color1: widget.model.borderColor.value,
            borderWidth: widget.model.borderWidth.value,
            onBorderWidthChanged: (value) {
              widget.model.borderWidth.set(value);
              logger.finest('borderWidth=${widget.model.borderWidth.value}');
              _sendEvent!.sendEvent(widget.model);
            },
            onBorderWidthChangeComplete: (value) {
              setState(() {});
            },
            onColor1Changed: (color) {
              setState(() {
                widget.model.borderColor.set(color);
              });
              _sendEvent!.sendEvent(widget.model);
            },
            onPositionChanged: (value) {
              int idx = 1;
              for (String val in CretaStudioLang.borderPositionList.values) {
                if (value == val) {
                  widget.model.borderPosition.set(BorderPositionType.values[idx]);
                }
                idx++;
              }
              _sendEvent!.sendEvent(widget.model);
            },
            onStyleChanged: (value) {
              if (value == null || value == 0) {
                widget.model.borderType.set(0);
              } else {
                widget.model.borderType.set(value);
              }
              _sendEvent!.sendEvent(widget.model);
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
          name: CretaStudioLang.color,
          widget: colorIndicator(color1, 1.0, onColorChanged: onColor1Changed, onClicked: () {}),
        ),

        CretaPropertySlider(
          // 보더 두께
          name: CretaStudioLang.borderWidth,
          min: 0,
          max: 36,
          value: borderWidth,
          valueType: SliderValueType.normal,
          onChannged: onBorderWidthChanged,
          //onChanngeComplete: onBorderWidthChangeComplete,
        ),

        // 보더 위치
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CretaStudioLang.borderPosition, style: titleStyle),
              CretaTabButton(
                onEditComplete: onPositionChanged,
                width: 75,
                height: 24,
                selectedTextColor: CretaColor.primary,
                unSelectedTextColor: CretaColor.text[700]!,
                selectedColor: Colors.white,
                unSelectedColor: CretaColor.text[100]!,
                selectedBorderColor: CretaColor.primary,
                defaultString: _getBorderPostion(),
                buttonLables: CretaStudioLang.borderPositionList.keys.toList(),
                buttonValues: CretaStudioLang.borderPositionList.values.toList(),
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
              Text(CretaStudioLang.style, style: titleStyle),
              // CretaImageDropDown(
              //   imageList: _imageList,
              //   defaultValue: widget.model.borderType.value,
              //   onChanged: onStyleChanged,
              //   width: 180,
              //   height: 24,
              // ),
              CretaWidgetDropDown(
                items: [
                  _noBorder(156, 30),
                  ...CretaUtils.borderStyle.map((e) {
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
      ],
    );
  }

  String _getBorderPostion() {
    switch (widget.model.borderPosition.value) {
      case BorderPositionType.inSide:
        return 'inSide';
      case BorderPositionType.outSide:
        return 'outSide';
      default:
        return 'center';
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
        titleWidget: Text(CretaStudioLang.shadow, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: widget.model.isNoShadow()
            ? SizedBox.shrink()
            : ShadowIndicator(
                color: widget.model.shadowColor.value,
                spread: widget.model.shadowSpread.value,
                blur: widget.model.shadowBlur.value,
                direction: widget.model.shadowDirection.value,
                distance: widget.model.shadowOffset.value,
                opacity: CretaUtils.validCheckDouble(widget.model.shadowOpacity.value, 0, 1),
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
              _sendEvent!.sendEvent(widget.model);
            },
            onOpacityChanged: (value) {
              widget.model.shadowOpacity.set(value);
              logger.fine('shadowOpacity=${widget.model.shadowOpacity.value}');
              _sendEvent!.sendEvent(widget.model);
            },
            onSpreadChanged: (value) {
              widget.model.shadowSpread.set(value);
              logger.finest('shadowSpread=${widget.model.shadowSpread.value}');
              _sendEvent!.sendEvent(widget.model);
            },
            onBlurChanged: (value) {
              widget.model.shadowBlur.set(value);
              logger.finest('shadowBlur=${widget.model.shadowBlur.value}');
              _sendEvent!.sendEvent(widget.model);
            },
            onDirectionChanged: (value) {
              widget.model.shadowDirection.set(value);
              logger.finest('shadowDirection=${widget.model.shadowDirection.value}');
              _sendEvent!.sendEvent(widget.model);
            },
            onOffsetChanged: (value) {
              widget.model.shadowOffset.set(value);
              logger.finest('shadowOffset=${widget.model.shadowOffset.value}');
              _sendEvent!.sendEvent(widget.model);
            },
            onShadowSampleSelected: (spread, blur, direction, distance, opactiy) {
              logger.info('spread=$spread, blur=$blur, direction=$direction, distance=$distance,');
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
              _sendEvent!.sendEvent(widget.model);
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
    )
        onShadowSampleSelected,
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
          name: CretaStudioLang.color,
          widget: colorIndicator(
            shadowColor,
            CretaUtils.validCheckDouble(shadowOpacity, 0, 1),
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
        //       Text(CretaStudioLang.shadowIn, style: titleStyle),
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
        //         buttonLables: CretaStudioLang.shadowInList.keys.toList(),
        //         buttonValues: CretaStudioLang.shadowInList.values.toList(),
        //       ),
        //     ],
        //   ),
        // ),
        _shadowListView(
          widget.model,
          onShadowSampleSelected,
        ),
        CretaPropertySlider(
          // 그림자 방향
          key: GlobalKey(),
          name: CretaStudioLang.direction,
          min: 0,
          max: 360,
          value: shadowDirection,
          valueType: SliderValueType.normal,
          onChannged: onDirectionChanged,
          //onChanngeComplete: onDirectionChangeComplete,
        ),
        CretaPropertySlider(
          // 그림자 투명도
          key: GlobalKey(),
          name: CretaStudioLang.opacity,
          min: 0,
          max: 100,
          value: CretaUtils.validCheckDouble(shadowOpacity, 0, 1),
          valueType: SliderValueType.reverse,
          onChannged: onOpacityChanged,
          //onChanngeComplete: onOpacityChangeComplete,
          postfix: '%',
        ),
        CretaPropertySlider(
          // 그림자 크기
          key: GlobalKey(),
          name: CretaStudioLang.spread,
          min: 0,
          max: 24,
          value: shadowSpread,
          valueType: SliderValueType.normal,
          onChannged: onSpreadChanged,
          //onChanngeComplete: onSpreadChangeComplete,
        ),
        CretaPropertySlider(
          // 그림자 블러
          key: GlobalKey(),
          name: CretaStudioLang.blur,
          min: 0,
          max: 24,
          value: shadowBlur,
          valueType: SliderValueType.normal,
          onChannged: onBlurChanged,
          //onChanngeComplete: onBlurChangeComplete,
        ),
        CretaPropertySlider(
          // 그림자 거리
          key: GlobalKey(),
          name: CretaStudioLang.offset,
          min: 0,
          max: 24,
          value: shadowOffset,
          valueType: SliderValueType.normal,
          onChannged: onOffsetChanged,
          //onChanngeComplete: onOffsetChangeComplete,
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
    )
        onTapPressed,
  ) {
    List<Widget> shadowList = [];
    // 그림자 없음 버튼
    shadowList.add(ShadowIndicator(
      color: model.shadowColor.value,
      spread: 0,
      blur: 0,
      direction: 0,
      distance: 0,
      opacity: 0,
      isSelected: model.isNoShadow(),
      onTapPressed: onTapPressed,
      hintText: CretaStudioLang.nothing,
    ));

    int len = CretaUtils.shadowDataList.length;
    for (int i = 0; i < len; i++) {
      //logger.finest('gradient: ${GradationType.values[i].toString()}');
      ShadowData data = CretaUtils.shadowDataList[i];
      shadowList.add(ShadowIndicator(
        color: model.shadowColor.value,
        spread: data.spread,
        blur: data.blur,
        direction: data.direction,
        distance: data.distance,
        opacity: data.opacity,
        isSelected: _isSameShadow(data, model),
        onTapPressed: onTapPressed,
      ));
    }

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
      logger.info('_isSameShadow true');
      return true;
    }
    logger.info('_isSameShadow false');
    return false;
  }
}

class ExampleBox extends StatefulWidget {
  final FrameModel model;
  final String name;
  final AnimationType aniType;
  final bool selected;
  final Function onSelected;
  const ExampleBox({
    super.key,
    required this.name,
    required this.aniType,
    required this.model,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<ExampleBox> createState() => _ExampleBoxState();
}

class _ExampleBoxState extends State<ExampleBox> {
  bool? _isHover;
  bool _isClicked = false;

  final double _height = 106;
  final double _width = 156;

  @override
  void initState() {
    _isClicked = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return _selectAnimation();
    return MouseRegion(
      onHover: (value) {
        if (_isHover == null || _isHover! == false) {
          setState(() {
            logger.finest('transition hovered');
            _isHover = true;
          });
        }
      },
      onExit: (value) {
        if (_isHover == null || _isHover! == true) {
          setState(() {
            logger.finest('transition exit');
            _isHover = false;
          });
        }
      },
      child: GestureDetector(
        onLongPressDown: (details) {
          setState(() {
            _isClicked = !_isClicked;
            if (_isClicked) {
              widget.model.transitionEffect
                  .set(widget.model.transitionEffect.value | widget.aniType.value);
            } else {
              int newVal = widget.model.transitionEffect.value - widget.aniType.value;
              if (newVal < 0) newVal = 0;
              widget.model.transitionEffect.set(newVal);
            }
            logger.finest('pageTrasitionValue = ${widget.model.transitionEffect.value}');
          });
          widget.onSelected.call();
        },
        child: Container(
          height: _height,
          width: _width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: _isClicked ? CretaColor.primary : Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            height: _height - 8,
            width: _width - 8,
            decoration: BoxDecoration(
              color: CretaColor.text[200]!,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: _selectAnimation(),
            ),
          ),
        ),
      ),
    );
  }

  bool isAni() {
    if (_isHover == null) return true;
    return _isHover!;
  }

  Widget _selectAnimation() {
    switch (widget.aniType) {
      case AnimationType.fadeIn:
        return isAni() ? _aniBox().fadeIn() : _normalBox();
      case AnimationType.flip:
        return isAni() ? _aniBox().flip() : _normalBox();
      case AnimationType.shake:
        return isAni() ? _aniBox().shake() : _normalBox();
      case AnimationType.shimmer:
        return isAni() ? _aniBox().shimmer() : _normalBox();
      default:
        return _noAnimation();
    }
  }

  Widget _normalBox() {
    return Container(
      height: _height - 56,
      width: _width - 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Center(
        child: Text(widget.name, style: CretaFont.titleSmall),
      ),
    );
  }

  Animate _aniBox() {
    return _normalBox().animate(
        onPlay: (controller) => controller.loop(
            period: Duration(
              milliseconds: 1000,
            ),
            count: 3,
            reverse: true));
  }

  Widget _noAnimation() {
    return GestureDetector(
      onLongPressDown: (details) {
        setState(() {
          _isClicked = !_isClicked;
          widget.model.transitionEffect.set(0);
          logger.finest('pageTrasitionValue = ${widget.model.transitionEffect.value}');
        });
        widget.onSelected.call();
      },
      child: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: _isClicked ? CretaColor.primary : Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Container(
          height: _height - 8,
          width: _width - 8,
          decoration: BoxDecoration(
            color: CretaColor.text[200]!,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Center(
            child: Text(widget.name, style: CretaFont.titleSmall),
          ),
        ),
      ),
    );
  }
}
