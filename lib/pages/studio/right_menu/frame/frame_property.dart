// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/text_field/creta_text_field.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/frame_model.dart';
import '../../book_main_page.dart';
import '../../studio_getx_controller.dart';
import '../property_mixin.dart';

class FrameProperty extends StatefulWidget {
  const FrameProperty({super.key});

  @override
  State<FrameProperty> createState() => _FramePropertyState();
}

class _FramePropertyState extends State<FrameProperty> with PropertyMixin {
  // ignore: unused_field
  //late ScrollController _scrollController;
  double horizontalPadding = 24;
  // ignore: unused_field
  FrameModel? _model;
  // ignore: unused_field
  FrameManager? _frameManager;
  bool _isTransitionOpen = false;
  bool _isSizeOpen = false;

  FrameEventController? frameEvent;
  @override
  void initState() {
    logger.finer('_FramePropertyState.initState');

    super.initMixin();
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _model = BookMainPage.pageManagerHolder!.getSelectedFrame();
    if (_model == null) {
      return SizedBox.shrink();
    }
    //frameEvent = Get.find(/*tag: 'frameEvent1'*/);
    final FrameEventController aController = Get.find(/*tag: 'frameEvent1'*/);
    frameEvent = aController;

    return StreamBuilder<FrameModel>(
        stream: aController.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.mid == _model!.mid) {
            snapshot.data!.copyTo(_model!);
          }

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
          ]);
        });
  }

  Widget _pageSize() {
    double height = _model!.height.value;
    double width = _model!.width.value;

    return propertyCard(
      padding: horizontalPadding,
      isOpen: _isSizeOpen,
      onPressed: () {
        setState(() {
          _isSizeOpen = !_isSizeOpen;
        });
      },
      titleWidget: Text(CretaStudioLang.frameSize, style: CretaFont.titleSmall),
      trailWidget: Text('${width.round()} x ${height.round()}', style: dataStyle),
      bodyWidget: _pageSizeBody(width, height),
    );
  }

  Widget _pageSizeBody(double width, double height) {
    //return Column(children: [
    //Text(CretaStudioLang.pageSize, style: CretaFont.titleSmall),
    return Column(
      children: [
// 첫번쨰 줄
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 30, right: 24),
          child: Row(
            children: [
              Text(
                CretaStudioLang.posX,
                style: titleStyle,
              ),
              SizedBox(width: 5),
              CretaTextField.xshortNumber(
                defaultBorder: Border.all(color: CretaColor.text[100]!),
                width: 45,
                limit: 5,
                textFieldKey: GlobalKey(),
                value: _model!.posX.value.round().toString(),
                hintText: '',
                onEditComplete: ((value) {
                  _model!.posX.set(int.parse(value).toDouble());
                  frameEvent?.sendEvent(_model!);
                }),
                minNumber: 0,
              ),
              SizedBox(width: 10),
              Text(
                CretaStudioLang.posY,
                style: titleStyle,
              ),
              SizedBox(width: 5),
              CretaTextField.xshortNumber(
                defaultBorder: Border.all(color: CretaColor.text[100]!),
                width: 45,
                limit: 5,
                textFieldKey: GlobalKey(),
                value: _model!.posY.value.round().toString(),
                hintText: '',
                minNumber: 0,
                onEditComplete: ((value) {
                  _model!.posY.set(int.parse(value).toDouble());
                  frameEvent?.sendEvent(_model!);
                }),
              ),
            ],
          ),
        ),
        // 두번째 줄
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    CretaStudioLang.width,
                    style: titleStyle,
                  ),
                  SizedBox(width: 5),
                  CretaTextField.xshortNumber(
                    defaultBorder: Border.all(color: CretaColor.text[100]!),
                    width: 45,
                    limit: 5,
                    textFieldKey: GlobalKey(),
                    value: _model!.width.value.round().toString(),
                    hintText: '',
                    onEditComplete: ((value) {
                      _sizeChanged(value, _model!.width, _model!.height);
                    }),
                    minNumber: 10,
                  ),
                  SizedBox(width: 6),
                  BTN.fill_gray_i_m(
                      tooltip: CretaStudioLang.fixedRatio,
                      tooltipBg: CretaColor.text[400]!,
                      icon: _model!.isFixedRatio.value
                          ? Icons.lock_outlined
                          : Icons.lock_open_outlined,
                      iconColor:
                          _model!.isFixedRatio.value ? CretaColor.primary : CretaColor.text[700]!,
                      onPressed: () {
                        setState(() {
                          _model!.isFixedRatio.set(!_model!.isFixedRatio.value);
                        });
                      }),
                  SizedBox(width: 6),
                  Text(
                    CretaStudioLang.height,
                    style: titleStyle,
                  ),
                  SizedBox(width: 5),
                  CretaTextField.xshortNumber(
                    defaultBorder: Border.all(color: CretaColor.text[100]!),
                    width: 45,
                    limit: 5,
                    textFieldKey: GlobalKey(),
                    value: _model!.height.value.round().toString(),
                    hintText: '',
                    minNumber: 10,
                    onEditComplete: ((value) {
                      _sizeChanged(value, _model!.height, _model!.width);
                    }),
                  ),
                ],
              ),
              BTN.fill_gray_i_m(
                  iconSize: 18,
                  icon: Icons.fullscreen_outlined,
                  onPressed: () {
                    BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
                    if (book == null) return;
                    if (_isFullScreen(book)) return;

                    mychangeStack.startTrans();
                    _model!.height.set(book.height.value);
                    _model!.width.set(book.width.value);
                    _model!.posX.set(0);
                    _model!.posY.set(0);
                    mychangeStack.endTrans();
                    //});
                    logger.finest('sendEvent');
                    frameEvent!.sendEvent(_model!);
                  })
            ],
          ),
        ),
        // 세번째 줄
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 30, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    CretaStudioLang.angle,
                    style: titleStyle,
                  ),
                  SizedBox(width: 5),
                  CretaTextField.xshortNumber(
                    maxNumber: 3600,
                    defaultBorder: Border.all(color: CretaColor.text[100]!),
                    width: 45,
                    limit: 5,
                    textFieldKey: GlobalKey(),
                    value: _model!.angle.value.round().toString(),
                    hintText: '',
                    onEditComplete: ((value) {
                      logger.fine('onEditComplete $value');
                      double newValue = int.parse(value).toDouble();
                      if (_model!.angle.value == newValue) {
                        return;
                      }
                      _model!.angle.set(newValue);
                      //BookMainPage.bookManagerHolder!.notify();
                      frameEvent!.sendEvent(_model!);
                      logger.fine('onEditComplete ${_model!.angle.value}');
                    }),
                    minNumber: 0,
                  ),
                  // SizedBox(width: 6),
                  // BTN.fill_gray_i_m(
                  //     tooltip: CretaStudioLang.fixedRatio,
                  //     tooltipBg: CretaColor.text[400]!,
                  //     icon: _model!.isFixedRatio.value
                  //         ? Icons.lock_outlined
                  //         : Icons.lock_open_outlined,
                  //     iconColor:
                  //         _model!.isFixedRatio.value ? CretaColor.primary : CretaColor.text[700]!,
                  //     onPressed: () {
                  //       setState(() {
                  //         _model!.isFixedRatio.set(!_model!.isFixedRatio.value);
                  //       });
                  //     }),
                  // SizedBox(width: 6),
                  // Text(
                  //   CretaStudioLang.height,
                  //   style: titleStyle,
                  // ),
                  // SizedBox(width: 5),
                  // CretaTextField.xshortNumber(
                  //   defaultBorder: Border.all(color: CretaColor.text[100]!),
                  //   width: 45,
                  //   limit: 5,
                  //   textFieldKey: GlobalKey(),
                  //   value: _model!.height.value.round().toString(),
                  //   hintText: '',
                  //   minNumber: 10,
                  //   onEditComplete: ((value) {
                  //     _sizeChanged(value, _model!.height, _model!.width);
                  //   }),
                  // ),
                ],
              ),
              // BTN.fill_gray_i_m(
              //     iconSize: 18,
              //     icon: Icons.fullscreen_outlined,
              //     onPressed: () {
              //       BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
              //       if (book == null) return;
              //       if (_isFullScreen(book)) return;

              //       mychangeStack.startTrans();
              //       _model!.height.set(book.height.value);
              //       _model!.width.set(book.width.value);
              //       _model!.posX.set(0);
              //       _model!.posY.set(0);
              //       mychangeStack.endTrans();
              //       //});
              //       logger.finest('sendEvent');
              //       frameEvent!.sendEvent(_model!);
              //     })
            ],
          ),
        ),
      ],
    );
  }

  bool _isFullScreen(BookModel book) {
    if (_model!.width.value == book.width.value &&
        _model!.width.value == book.height.value &&
        _model!.posX.value == 0 &&
        _model!.posY.value == 0) {
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
    double newValue = int.parse(value).toDouble();
    if (targetAttr.value == newValue) {
      return;
    }

    if (_model!.isFixedRatio.value == true) {
      double ratio = counterAttr.value / targetAttr.value;
      counterAttr.set((newValue * ratio).roundToDouble());
    }
    targetAttr.set(newValue);
    //BookMainPage.bookManagerHolder!.notify();
    frameEvent!.sendEvent(_model!);
    logger.fine('onEditComplete ${targetAttr.value}');
  }

  Widget _pageColor() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: colorPropertyCard(
        title: CretaStudioLang.frameBgColor,
        color1: _model!.bgColor1.value,
        color2: _model!.bgColor2.value,
        opacity: _model!.opacity.value,
        gradationType: _model!.gradationType.value,
        cardOpenPressed: () {
          setState(() {});
        },
        onOpacityDragComplete: (value) {
          setState(() {
            _model!.opacity.set(1 - (value / 100));
            logger.finest('opacity1=${_model!.opacity.value}');
          });
          frameEvent!.sendEvent(_model!);
          //BookMainPage.bookManagerHolder?.notify();
        },
        onColor1Changed: (val) {
          setState(() {
            _model!.bgColor1.set(val);
          });
          frameEvent!.sendEvent(_model!);
          //BookMainPage.bookManagerHolder?.notify();
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
        bgColor1: _model!.bgColor1.value,
        bgColor2: _model!.bgColor2.value,
        opacity: _model!.opacity.value,
        gradationType: _model!.gradationType.value,
        onGradationTapPressed: (GradationType type, Color color1, Color color2) {
          logger.finest('GradationIndicator clicked');
          setState(() {
            if (_model!.gradationType.value == type) {
              _model!.gradationType.set(GradationType.none);
            } else {
              _model!.gradationType.set(type);
            }
          });
          frameEvent!.sendEvent(_model!);
          //BookMainPage.bookManagerHolder?.notify();
        },
        onColor2Changed: (Color val) {
          setState(() {
            _model!.bgColor2.set(val);
          });
          frameEvent!.sendEvent(_model!);
          //BookMainPage.bookManagerHolder?.notify();
        },
      ),
    );
  }

  Widget _texture() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: textureCard(
        textureType: _model!.textureType.value,
        onPressed: () {
          setState(() {});
        },
        onTextureTapPressed: (val) {
          setState(() {
            _model!.textureType.set(val);
          });
          frameEvent!.sendEvent(_model!);
          //BookMainPage.bookManagerHolder?.notify();
        },
      ),
    );
  }

  Widget _pageTransition() {
    logger.finest('pageTransition=${_model!.transitionEffect.value}');
    List<AnimationType> animations = AnimationType.toAniListFromInt(_model!.transitionEffect.value);
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
        titleWidget: Text(CretaStudioLang.transitionPage, style: CretaFont.titleSmall),
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
                model: _model!,
                name: CretaStudioLang.animationTypes[i],
                aniType: AnimationType.values[i],
                selected: (i != 0 &&
                        (AnimationType.values[i].value & _model!.transitionEffect.value ==
                            AnimationType.values[i].value) ||
                    i == 0 && _model!.transitionEffect.value == 0),
                onSelected: () {
                  setState(() {});
                  frameEvent!.sendEvent(_model!);
                  //BookMainPage.bookManagerHolder!.notify();
                }),
          // ExampleBox(model: _model!, name: CretaStudioLang.flip, aniType: AnimationType.flip),
          // ExampleBox(model: _model!, name: CretaStudioLang.shake, aniType: AnimationType.shake),
          // ExampleBox(model: _model!, name: CretaStudioLang.shimmer, aniType: AnimationType.shimmer),
        ],
      ),
    );
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
    return _selectAnimation();
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
