// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, must_be_immutable, unnecessary_brace_in_string_interps

import 'package:creta03/pages/studio/studio_constant.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';

//import '../../../../data_io/book_manager.dart';
import '../../../../design_system/buttons/creta_slider.dart';
import '../../../../design_system/buttons/creta_toggle_button.dart';
import '../../../../design_system/component/colorPicker/gradation_indicator.dart';
import '../../../../design_system/component/colorPicker/my_color_indicator.dart';
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
  BookPageProperty({super.key, required this.model, required this.parentNotify});

  final List<String> rotationStrings = ["lands", "ports"];
  final List<IconData> rotaionIcons = [
    Icons.crop_landscape_outlined,
    Icons.crop_portrait_outlined,
  ];

  @override
  State<BookPageProperty> createState() => _BookPagePropertyState();
}

class _BookPagePropertyState extends State<BookPageProperty> with PropertyMixin {
  // ignore: unused_field
  //BookManager? _bookManager;
  // ignore: unused_field
  //late ScrollController _scrollController;
  final double horizontalPadding = 24;

  bool _isColorOpen = false;
  bool _isOptionOpen = false;
  bool _isSizeOpen = false;

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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: _pageColor(),
        ),
        propertyDivider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: _bookOption(),
        ),
      ],
    );
  }

  Widget _pageColor() {
    logger.fine('opacity3=${widget.model.opacity.value}');
    return propertyCard(
      isOpen: _isColorOpen,
      onPressed: () {
        setState(() {
          _isColorOpen = !_isColorOpen;
        });
      },
      titleWidget: Text(CretaStudioLang.pageBgColor, style: CretaFont.titleSmall),
      //trailWidget: _isColorOpen ? _gradationButton() : _colorIndicator(),
      trailWidget: _colorIndicator1(),
      bodyWidget: _colorBody(),
    );
  }

  // Widget _gradationButton() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: 20),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         CustomRadioButton(
  //           radioButtonValue: (value) {
  //             setState(() {
  //               bgType = value;
  //               if (bgType == 'Solid') {
  //                 widget.model.bgColor2.set(Colors.transparent);
  //               }
  //             });
  //           },
  //           width: 80,
  //           height: 28,
  //           defaultSelected: bgType,
  //           buttonLables: CretaStudioLang.colorTypes,
  //           buttonValues: const ["Solid", "Gradation"],
  //           buttonTextStyle: ButtonTextStyle(
  //             selectedColor: CretaColor.primary,
  //             unSelectedColor: CretaColor.text[700]!,
  //             //textStyle: CretaFont.buttonMedium.copyWith(fontWeight: FontWeight.bold),
  //             textStyle: CretaFont.buttonMedium,
  //           ),
  //           selectedColor: CretaColor.text[100]!,
  //           unSelectedColor: Colors.white,
  //           absoluteZeroSpacing: false,
  //           selectedBorderColor: Colors.transparent,
  //           unSelectedBorderColor: Colors.transparent,
  //           elevation: 0,
  //           enableButtonWrap: true,
  //           enableShape: true,
  //           shapeRadius: 60,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _colorBody() {
    return Column(
      children: [
        //_gradationButton(),
        propertyLine(
          // 색
          name: CretaStudioLang.color,
          widget: _colorIndicator1(),
        ),
        propertyLine2(
          // 투명도
          name: CretaStudioLang.opacity,
          widget1: SizedBox(
            height: 22,
            width: 168,
            child: CretaSlider(
              key: UniqueKey(),
              min: 0,
              max: 100,
              value: (1 - widget.model.opacity.value) * 100,
              onDragComplete: (value) {
                setState(() {
                  widget.model.opacity.set(1 - (value / 100));
                  logger.fine('opacity1=${widget.model.opacity.value}');
                });
                BookMainPage.bookManagerHolder?.notify();
              },
            ),
          ),
          widget2: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CretaTextField.xshortNumber(
                defaultBorder: Border.all(color: CretaColor.text[100]!),
                width: 40,
                limit: 3,
                textFieldKey: GlobalKey(),
                value: '${((1 - widget.model.opacity.value) * 100).round()}',
                hintText: '',
                onEditComplete: ((value) {
                  setState(() {
                    double opacity = double.parse(value) / 100;
                    widget.model.opacity.set(1 - opacity);
                    logger.fine('opacity2=${widget.model.opacity.value}');
                  });
                  BookMainPage.bookManagerHolder?.notify();
                }),
              ),
              Text('%', style: CretaFont.bodySmall),
            ],
          ),
        ),
        propertyLine(
          // 그라데이션
          name: CretaStudioLang.gradation,
          widget: _colorIndicator2(),
        ),
        _gradationTypes(),
      ],
    );
  }

  Widget _gradationTypes() {
    List<Widget> gradientList = [];
    for (int i = 0; i < GradationType.end.index; i++) {
      logger.fine('gradient: ${GradationType.values[i].toString()}');
      gradientList.add(GradationIndicator(
          color1: widget.model.bgColor1.value,
          color2: widget.model.bgColor2.value,
          gradationType: GradationType.values[i],
          onTapPressed: () {
            setState(() {
              widget.model.gradationType.set(GradationType.values[i]);
            });
          }));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: gradientList),
    );
  }

  Widget _colorIndicator1() {
    return MyColorIndicator(
        //opacity: widget.model.opacity.value,
        color: widget.model.bgColor1.value,
        onColorChanged: (val) {
          setState(() {
            widget.model.bgColor1.set(val);
          });
          BookMainPage.bookManagerHolder?.notify();
        });
  }

  Widget _colorIndicator2() {
    return MyColorIndicator(
        //opacity: widget.model.opacity.value,
        color: widget.model.bgColor2.value,
        onColorChanged: (val) {
          setState(() {
            widget.model.bgColor2.set(val);
          });
          BookMainPage.bookManagerHolder?.notify();
        });
  }

  Widget _pageSize() {
    int height = widget.model.height.value;
    int width = widget.model.width.value;

    return propertyCard(
      padding: horizontalPadding,
      isOpen: _isSizeOpen,
      onPressed: () {
        setState(() {
          _isSizeOpen = !_isSizeOpen;
        });
      },
      titleWidget: Text(CretaStudioLang.pageSize, style: CretaFont.titleSmall),
      trailWidget: Text('$width x $height', style: dataStyle),
      bodyWidget: _pageBody(width, height),
    );
  }

  Widget _pageBody(int width, int height) {
    //return Column(children: [
    //Text(CretaStudioLang.pageSize, style: CretaFont.titleSmall),
    return Padding(
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
              ),
              widget.model.pageSizeType.value != 0
                  ? CretaDropDownButton(
                      padding: EdgeInsets.only(left: 8, right: 4),
                      height: 28,
                      itemHeight: 24,
                      textStyle: CretaFont.bodyESmall,
                      dropDownMenuItemList: getResolutionListItem(null),
                      align: MainAxisAlignment.start)
                  : _editSize(),
            ],
          ),
          // 가로세로 버튼
          CustomRadioButton(
            radioButtonValue: (value) {
              setState(() {
                mychangeStack.startTrans();
                widget.model.height.set(width);
                widget.model.width.set(height);
                mychangeStack.endTrans();
              });
              logger.finest('notify');
              BookMainPage.bookManagerHolder?.notify();
            },
            width: 32,
            height: 32,
            defaultSelected:
                height <= width ? widget.rotationStrings[0] : widget.rotationStrings[1],
            buttonLables: widget.rotationStrings,
            buttonIcons: widget.rotaionIcons,
            buttonValues: widget.rotationStrings,
            buttonTextStyle: ButtonTextStyle(
              selectedColor: CretaColor.primary,
              unSelectedColor: CretaColor.text[700]!,
              //textStyle: CretaFont.buttonMedium.copyWith(fontWeight: FontWeight.bold),
              textStyle: CretaFont.buttonMedium,
            ),
            selectedColor: CretaColor.text[100]!,
            unSelectedColor: Colors.white,
            absoluteZeroSpacing: true,
            selectedBorderColor: Colors.transparent,
            unSelectedBorderColor: Colors.transparent,
            elevation: 0,
            enableButtonWrap: true,
            enableShape: true,
            shapeRadius: 60,
          ),
        ],
      ),
    );
    // Padding(
    //   padding: const EdgeInsets.only(top: 6),
    //   child: Row(
    //     children: [
    //       Text(
    //         CretaStudioLang.width,
    //         style: titleStyle,
    //       ),
    //       SizedBox(width: 10),
    //       widget.model.pageSizeType.value == 0
    //           ? CretaTextField.xshortNumber(
    //               defaultBorder: Border.all(color: CretaColor.text[100]!),
    //               width: 45,
    //               limit: 5,
    //               textFieldKey: GlobalKey(),
    //               value: widget.model.width.value.toString(),
    //               hintText: '',
    //               onEditComplete: ((value) {
    //                 widget.model.width.set(int.parse(value));
    //                 BookMainPage.bookManagerHolder!.notify();
    //               }))
    //           : SizedBox(
    //               width: 45,
    //               child: Text(
    //                 widget.model.width.value.toString(),
    //                 style: dataStyle,
    //                 textAlign: TextAlign.end,
    //               ),
    //             ),
    //       SizedBox(width: 10),
    //       BTN.fill_gray_i_m(icon: Icons.link_outlined, onPressed: () {}),
    //       SizedBox(width: 10),
    //       Text(
    //         CretaStudioLang.height,
    //         style: titleStyle,
    //       ),
    //       SizedBox(width: 10),
    //       widget.model.pageSizeType.value == 0
    //           ? CretaTextField.xshortNumber(
    //               defaultBorder: Border.all(color: CretaColor.text[100]!),
    //               width: 45,
    //               limit: 5,
    //               textFieldKey: GlobalKey(),
    //               value: widget.model.height.value.toString(),
    //               hintText: '',
    //               onEditComplete: ((value) {
    //                 widget.model.height.set(int.parse(value));
    //                 BookMainPage.bookManagerHolder!.notify();
    //               }),
    //             )
    //           : SizedBox(
    //               width: 55,
    //               child: Text(
    //                 widget.model.height.value.toString(),
    //                 style: dataStyle,
    //                 textAlign: TextAlign.end,
    //               ),
    //             ),
    //     ],
    //   ),
    // ),
    //]);
  }

  Widget _editSize() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          CretaTextField.xshortNumber(
              defaultBorder: Border.all(color: CretaColor.text[200]!),
              width: 45,
              limit: 5,
              textFieldKey: GlobalKey(),
              value: widget.model.width.value.toString(),
              hintText: '',
              onEditComplete: ((value) {
                widget.model.width.set(int.parse(value));
                BookMainPage.bookManagerHolder!.notify();
              })),
          Text(' x ', style: dataStyle),
          CretaTextField.xshortNumber(
            defaultBorder: Border.all(color: CretaColor.text[200]!),
            width: 45,
            limit: 5,
            textFieldKey: GlobalKey(),
            value: widget.model.height.value.toString(),
            hintText: '',
            onEditComplete: ((value) {
              widget.model.height.set(int.parse(value));
              BookMainPage.bookManagerHolder!.notify();
            }),
          ),
        ],
      ),
    );
  }

  List<String> choicePageSizeName(BookType bookType) {
    if (bookType == BookType.presentaion) {
      return CretaStudioLang.pageSizeListSignage;
    }
    return CretaStudioLang.pageSizeListPresentation;
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

  void saveSize(Size size) {
    bool isLands = widget.model.width.value >= widget.model.height.value;
    mychangeStack.startTrans();
    if (isLands) {
      widget.model.width.set(size.width.round());
      widget.model.height.set(size.height.round());
    } else {
      widget.model.width.set(size.height.round());
      widget.model.height.set(size.width.round());
    }
  }

  Widget _bookOption() {
    logger.fine('_bookOption=${widget.model.isAutoPlay.value}');
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
}
