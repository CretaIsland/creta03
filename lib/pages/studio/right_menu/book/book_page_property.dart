// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, must_be_immutable, unnecessary_brace_in_string_interps

import 'package:creta03/pages/studio/studio_constant.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';

//import '../../../../data_io/book_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/buttons/creta_tab_button.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/menu/creta_drop_down_button.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../design_system/text_field/creta_text_field.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../book_main_page.dart';

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

class _BookPagePropertyState extends State<BookPageProperty> {
  // ignore: unused_field
  //BookManager? _bookManager;
  // ignore: unused_field
  //late ScrollController _scrollController;

  final double horizontalPadding = 24;

  late TextStyle _titleStyle;
  // ignore: unused_field
  late TextStyle _dataStyle;

  @override
  void initState() {
    logger.finer('_BookPagePropertyState.initState');
    _titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
    _dataStyle = CretaFont.bodySmall;

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
        ..._pageSize(),
        Divider(
          color: CretaColor.text[200]!,
          indent: 0,
          endIndent: 0,
        ),
        _pageColor(),
      ],
    );
  }

  Widget _pageColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  BTN.fill_blue_i_menu(
                      icon: Icons.expand_circle_down_outlined,
                      width: 20,
                      height: 20,
                      onPressed: () {}),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(CretaStudioLang.pageBgColor, style: CretaFont.titleSmall),
                  ),
                ],
              ),
              CretaTabButton(
                onEditComplete: (value) {
                  setState(() {});
                },
                width: 90,
                height: 28,
                defaultString: "0",
                buttonLables: CretaStudioLang.colorTypes,
                buttonValues: const ["0", "1"],
                selectedTextColor: CretaColor.primary,
                unSelectedTextColor: CretaColor.text[700]!,
                selectedColor: CretaColor.text[100]!,
                unSelectedColor: Colors.white,
                absoluteZeroSpacing: true,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CretaStudioLang.color, style: _titleStyle),
              GestureDetector(
                onLongPressDown: (details) {
                  logger.finest('color picker invoke');
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      color: Colors.amber, borderRadius: BorderRadius.all(Radius.circular(2))),
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.circle),
              //   iconSize: 24,
              //   color: Colors.amber,
              //   onPressed: () {},
              // )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CretaStudioLang.opacity, style: _titleStyle),
              // CretaSlider(
              //   min: 0,
              //   max: 100,
              //   value: widget.model.opacity.value,
              //   onDragComplete: (value) {},
              // ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _pageSize() {
    int height = widget.model.height.value;
    int width = widget.model.width.value;
    return [
      Text(CretaStudioLang.pageSize, style: CretaFont.titleSmall),
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Row(
          children: [
            CretaDropDownButton(
              height: 28,
              textStyle: CretaFont.bodyESmall,
              dropDownMenuItemList: getPageSizeListItem(null),
              align: MainAxisAlignment.start,
            ),
            widget.model.pageSizeType.value != 0
                ? CretaDropDownButton(
                    height: 28,
                    textStyle: CretaFont.bodyESmall,
                    dropDownMenuItemList: getResolutionListItem(null),
                    align: MainAxisAlignment.start)
                : Container(),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  CretaStudioLang.width,
                  style: _titleStyle,
                ),
                SizedBox(width: 10),
                widget.model.pageSizeType.value == 0
                    ? CretaTextField.xshortNumber(
                        defaultBorder: Border.all(color: CretaColor.text[100]!),
                        width: 45,
                        limit: 5,
                        textFieldKey: GlobalKey(),
                        value: widget.model.width.value.toString(),
                        hintText: '',
                        onEditComplete: ((value) {
                          widget.model.width.set(int.parse(value));
                          BookMainPage.bookManagerHolder!.notify();
                        }))
                    : SizedBox(
                        width: 45,
                        child: Text(
                          widget.model.width.value.toString(),
                          style: _dataStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                SizedBox(width: 10),
                BTN.fill_gray_i_m(icon: Icons.link_outlined, onPressed: () {}),
                SizedBox(width: 10),
                Text(
                  CretaStudioLang.height,
                  style: _titleStyle,
                ),
                SizedBox(width: 10),
                widget.model.pageSizeType.value == 0
                    ? CretaTextField.xshortNumber(
                        defaultBorder: Border.all(color: CretaColor.text[100]!),
                        width: 45,
                        limit: 5,
                        textFieldKey: GlobalKey(),
                        value: widget.model.height.value.toString(),
                        hintText: '',
                        onEditComplete: ((value) {
                          widget.model.height.set(int.parse(value));
                          BookMainPage.bookManagerHolder!.notify();
                        }),
                      )
                    : SizedBox(
                        width: 55,
                        child: Text(
                          widget.model.height.value.toString(),
                          style: _dataStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
              ],
            ),
            Row(
              children: [
                CretaTabButton(
                  onEditComplete: (value) {
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
                  defaultString:
                      height <= width ? widget.rotationStrings[0] : widget.rotationStrings[1],
                  buttonLables: widget.rotationStrings,
                  buttonIcons: widget.rotaionIcons,
                  buttonValues: widget.rotationStrings,
                  selectedTextColor: CretaColor.primary,
                  unSelectedTextColor: CretaColor.text[700]!,
                  //selectedBorderColor: CretaColor.primary,
                  //unSelectedBorderColor: Colors.transparent,
                  selectedColor: CretaColor.text[100]!,
                  unSelectedColor: Colors.white,
                  absoluteZeroSpacing: true,
                ),
                //BTN.fill_gray_i_m(icon: Icons.crop_portrait_outlined, onPressed: () {}),
                //BTN.fill_gray_i_m(icon: Icons.crop_landscape_outlined, onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  List<String> choicePageSizeName(BookType bookType) {
    if (bookType == BookType.presentaion) {
      return CretaStudioLang.pageSizeListPresentation;
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
}
