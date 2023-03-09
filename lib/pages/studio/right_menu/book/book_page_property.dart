// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, must_be_immutable, unnecessary_brace_in_string_interps

import 'package:creta03/pages/studio/studio_constant.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';

//import '../../../../data_io/book_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/buttons/creta_toggle_button.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/menu/creta_drop_down_button.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../design_system/text_field/creta_text_field.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../book_main_page.dart';
import '../property_mixin.dart';

class BookPageProperty extends StatefulWidget {
  final BookModel model;
  final Function() parentNotify;
  const BookPageProperty({super.key, required this.model, required this.parentNotify});

  @override
  State<BookPageProperty> createState() => _BookPagePropertyState();
}

class _BookPagePropertyState extends State<BookPageProperty> with PropertyMixin {
  // ignore: unused_field
  //BookManager? _bookManager;
  // ignore: unused_field
  //late ScrollController _scrollController;
  final double horizontalPadding = 24;

  //bool isColorOpen = false;
  static bool _isOptionOpen = false;
  static bool _isSizeOpen = false;

  final GlobalKey<CretaTextFieldState> textFieldKey = GlobalKey<CretaTextFieldState>();
  GlobalKey popupKey = GlobalKey();
  TextEditingController colorTextController = TextEditingController();
  late ThemeMode themeMode;

  @override
  void initState() {
    logger.finer('_BookPagePropertyState.initState');
    super.initMixin();
    themeMode = ThemeMode.light;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageSize(),
        propertyDivider(),
        _pageColor(),
        propertyDivider(),
        _gradation(),
        propertyDivider(),
        _texture(),
        propertyDivider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: _bookOption(),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _pageColor() {
    logger.finest('opacity3=${widget.model.opacity.value}');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: colorPropertyCard(
          title: CretaStudioLang.bookBgColor,
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
            BookMainPage.bookManagerHolder?.notify();
          },
          onOpacityDrag: (value) {
            widget.model.opacity.set(value);
            logger.finest('opacity1=${widget.model.opacity.value}');
            BookMainPage.bookManagerHolder?.notify();
          },
          onColor1Changed: (val) {
            //setState(() {
            widget.model.bgColor1.set(val);
            //});
            BookMainPage.bookManagerHolder?.notify();
          },
          onColorIndicatorClicked: () {
            PropertyMixin.isColorOpen = true;
            setState(() {});
          }),
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
            //setState(() {
            if (widget.model.gradationType.value == type) {
              widget.model.gradationType.set(GradationType.none);
            } else {
              widget.model.gradationType.set(type);
            }
            //});
            BookMainPage.bookManagerHolder?.notify();
          },
          onColor2Changed: (Color val) {
            //setState(() {
            widget.model.bgColor2.set(val);
            //});
            BookMainPage.bookManagerHolder?.notify();
          },
          onColorIndicatorClicked: () {
            setState(() {
              PropertyMixin.isGradationOpen = true;
            });
          }),
    );
  }

  Widget _pageSize() {
    double height = widget.model.height.value;
    double width = widget.model.width.value;

    return propertyCard(
      padding: horizontalPadding,
      isOpen: _isSizeOpen,
      onPressed: () {
        setState(() {
          _isSizeOpen = !_isSizeOpen;
        });
      },
      titleWidget: Text(CretaStudioLang.pageSize, style: CretaFont.titleSmall),
      trailWidget: Text('${width.round()} x ${height.round()}', style: dataStyle),
      bodyWidget: _pageSizeBody(width, height),
    );
  }

  Widget _pageSizeBody(double width, double height) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 20, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CretaDropDownButton(
                    padding: EdgeInsets.only(left: 8, right: 4),
                    height: 28,
                    itemHeight: 24,
                    textStyle: CretaFont.bodyESmall,
                    dropDownMenuItemList: getPageSizeListItem(null),
                    align: MainAxisAlignment.start,
                    hintList: getPageSizeListHint(),
                  ),

                  widget.model.bookType.value != BookType.presentaion
                      ? CretaDropDownButton(
                          padding: EdgeInsets.only(left: 8, right: 4),
                          height: 28,
                          itemHeight: 24,
                          textStyle: CretaFont.bodyESmall,
                          dropDownMenuItemList: getResolutionListItem(null),
                          align: MainAxisAlignment.start,
                        )
                      : SizedBox.shrink(),

                  //: _editSize(),
                ],
              ),
              // 가로세로 버튼
              rotateButtons(
                  pWidth: widget.model.width.value,
                  pHeight: widget.model.height.value,
                  rotateButtonPresed: (value) {
                    //setState(() {
                    mychangeStack.startTrans();
                    widget.model.height.set(width);
                    widget.model.width.set(height);
                    mychangeStack.endTrans();
                    //});
                    logger.finest('notify');
                    BookMainPage.bookManagerHolder?.notify();
                  }),
            ],
          ),
        ),
        // 두번째 줄
        Padding(
          //padding: const EdgeInsets.only(top: 12, left: 20, right: 24),
          padding: const EdgeInsets.only(top: 6, left: 30, right: 24),
          child: Row(
            children: [
              Text(
                CretaStudioLang.width,
                style: titleStyle,
              ),
              SizedBox(width: 10),
              CretaTextField.xshortNumber(
                defaultBorder: Border.all(color: CretaColor.text[100]!),
                width: 45,
                limit: 5,
                textFieldKey: GlobalKey(),
                value: widget.model.width.value.round().toString(),
                hintText: '',
                minNumber: 10,
                onEditComplete: ((value) {
                  _sizeChanged(value, widget.model.width, widget.model.height);
                }),
              ),

              SizedBox(width: 10),
              BTN.fill_gray_i_m(
                  tooltip: CretaStudioLang.fixedRatio,
                  tooltipBg: CretaColor.text[400]!,
                  icon: widget.model.isFixedRatio.value
                      ? Icons.lock_outlined
                      : Icons.lock_open_outlined,
                  iconColor:
                      widget.model.isFixedRatio.value ? CretaColor.primary : CretaColor.text[700]!,
                  onPressed: () {
                    setState(() {
                      widget.model.isFixedRatio.set(!widget.model.isFixedRatio.value);
                    });
                  }),
              SizedBox(width: 10),
              Text(
                CretaStudioLang.height,
                style: titleStyle,
              ),
              SizedBox(width: 10),
              // widget.model.pageSizeType.value == 0
              //     ?
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
    );
  }

  void _sizeChanged(
    String value,
    UndoAble<double> targetAttr,
    UndoAble<double> counterAttr,
  ) {
    logger.finest('onEditComplete $value');
    double newValue = int.parse(value).toDouble();
    if (targetAttr.value == newValue) {
      return;
    }
    widget.model.pageSizeType.set(0);

    if (widget.model.isFixedRatio.value == true) {
      double ratio = counterAttr.value / targetAttr.value;
      counterAttr.set((newValue * ratio).roundToDouble());
    }
    targetAttr.set(newValue);
    BookMainPage.bookManagerHolder!.notify();
    logger.finest('onEditComplete ${targetAttr.value}');
  }

  // Widget _editSize() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 16.0),
  //     child: Row(
  //       children: [
  //         CretaTextField.xshortNumber(
  //             defaultBorder: Border.all(color: CretaColor.text[200]!),
  //             width: 45,
  //             limit: 5,
  //             textFieldKey: GlobalKey(),
  //             value: widget.model.width.value.toString(),
  //             hintText: '',
  //             onEditComplete: ((value) {
  //               widget.model.width.set(int.parse(value));
  //               BookMainPage.bookManagerHolder!.notify();
  //             })),
  //         Text(' x ', style: dataStyle),
  //         CretaTextField.xshortNumber(
  //           defaultBorder: Border.all(color: CretaColor.text[200]!),
  //           width: 45,
  //           limit: 5,
  //           textFieldKey: GlobalKey(),
  //           value: widget.model.height.value.toString(),
  //           hintText: '',
  //           onEditComplete: ((value) {
  //             widget.model.height.set(int.parse(value));
  //             BookMainPage.bookManagerHolder!.notify();
  //           }),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  List<String> choicePageSizeName(BookType bookType) {
    if (bookType == BookType.presentaion) {
      return CretaStudioLang.pageSizeMapPresentation.keys.toList();
    }
    return CretaStudioLang.pageSizeListSignage;
  }

  List<Size> choiceResolution(BookType bookType, int idx) {
    if (bookType == BookType.presentaion) {
      int len = StudioConst.presentationResolution.length;
      if (0 > idx || len <= idx) {
        return StudioConst.presentationResolution[0];
      }
      return StudioConst.presentationResolution[idx];
    }
    int len = StudioConst.signageResolution.length;
    if (0 > idx || len <= idx) {
      return StudioConst.signageResolution[0];
    }
    return StudioConst.signageResolution[idx];
  }

  List<CretaMenuItem> getPageSizeListItem(Function? onChnaged) {
    List<CretaMenuItem> retval = [];
    List<String> sizeStringList = choicePageSizeName(widget.model.bookType.value);
    int sizeTypeLen = sizeStringList.length;

    for (int i = 0; i < sizeTypeLen; i++) {
      retval.add(
        CretaMenuItem(
            caption: sizeStringList[i],
            onPressed: () {
              widget.model.pageSizeType.set(i);
              if (i != 0) {
                Size matchedSize = matchedReSolution();
                saveSize(matchedSize);
              }
              BookMainPage.bookManagerHolder!.notify();
            },
            selected: (i == widget.model.pageSizeType.value)),
      );
    }

    return retval;
  }

  List<String>? getPageSizeListHint() {
    if (widget.model.bookType.value == BookType.presentaion) {
      return CretaStudioLang.pageSizeMapPresentation.values.toList();
    }
    return null;
  }

  Size matchedReSolution() {
    List<Size> resolutionList =
        choiceResolution(widget.model.bookType.value, widget.model.pageSizeType.value);
    int resolutionLen = resolutionList.length;
    for (int i = 0; i < resolutionLen; i++) {
      double width = resolutionList[i].width;
      double height = resolutionList[i].height;
      bool isLands = widget.model.width.value >= widget.model.height.value;
      if (isLands) {
        if (width.round() == widget.model.width.value &&
            height.round() == widget.model.height.value) {
          return resolutionList[i];
        }
      } else {
        if (height.round() == widget.model.width.value &&
            width.round() == widget.model.height.value) {
          return resolutionList[i];
        }
      }
    }
    return resolutionList[0];
  }

  List<CretaMenuItem> getResolutionListItem(Function? onChnaged) {
    if (widget.model.pageSizeType.value == 0) {
      return [];
    }

    List<CretaMenuItem> retval = [];
    List<Size> resolutionList =
        choiceResolution(widget.model.bookType.value, widget.model.pageSizeType.value);
    int resolutionLen = resolutionList.length;

    for (int i = 0; i < resolutionLen; i++) {
      bool isLands = widget.model.width.value >= widget.model.height.value;
      int width = resolutionList[i].width.round();
      int height = resolutionList[i].height.round();
      retval.add(CretaMenuItem(
        caption: isLands ? '${width}x${height}' : '${height}x${width}',
        onPressed: () {
          saveSize(resolutionList[i]);
          BookMainPage.bookManagerHolder!.notify();
        },
        selected: (width.round() == widget.model.width.value &&
                height.round() == widget.model.height.value) ||
            (height.round() == widget.model.width.value &&
                width.round() == widget.model.height.value),
      ));
    }
    return retval;
  }

  String getResolutionString() {
    if (widget.model.pageSizeType.value == 0) {
      return '';
    }
    List<Size> resolutionList = StudioConst.presentationResolution[widget.model.pageSizeType.value];
    int width = resolutionList[0].width.round();
    int height = resolutionList[0].height.round();

    bool isLands = widget.model.width.value >= widget.model.height.value;
    return isLands ? '${width}x${height}' : '${height}x${width}';
  }

  void saveSize(Size size) {
    bool isLands = widget.model.width.value >= widget.model.height.value;
    mychangeStack.startTrans();
    if (isLands) {
      widget.model.width.set(size.width);
      widget.model.height.set(size.height);
    } else {
      widget.model.width.set(size.height);
      widget.model.height.set(size.width);
    }
  }

  Widget _bookOption() {
    logger.finest('_bookOption=${widget.model.isAutoPlay.value}');
    return propertyCard(
      isOpen: _isOptionOpen,
      onPressed: () {
        setState(() {
          _isOptionOpen = !_isOptionOpen;
        });
      },
      titleWidget: Text(CretaStudioLang.option, style: CretaFont.titleSmall),
      //trailWidget: SizedBox.shrink(),
      bodyWidget: _optionBody(),
    );
  }

  Widget _optionBody() {
    return propertyLine(
        name: CretaStudioLang.autoPlay,
        widget: CretaToggleButton(
          defaultValue: widget.model.isAutoPlay.value,
          onSelected: (value) {
            widget.model.isAutoPlay.set(value);
          },
        ));
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
          BookMainPage.bookManagerHolder?.notify();
        },
      ),
    );
  }
}
