// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'creta_popup_menu.dart';

class CretaDropDownButton extends StatefulWidget {
  //final double width;
  final double height;
  final double itemHeight;
  final List<CretaMenuItem> dropDownMenuItemList;
  final List<String>? hintList;
  final MainAxisAlignment align;
  double? width;
  TextStyle? textStyle;
  double? iconSize;
  EdgeInsetsGeometry? padding; //EdgeInsets.only(left: 8, right: 4)
  final Color selectedColor;
  final double? borderRadius;
  final bool alwaysShowBorder;
  final Color? allTextColor;
  final int maxVisibleRowCount;
  final IconData pulldownIcon;
  final bool isActive;

  CretaDropDownButton({
    super.key,
    this.width,
    this.textStyle,
    this.iconSize,
    this.padding,
    required this.height,
    required this.dropDownMenuItemList,
    this.align = MainAxisAlignment.center,
    this.itemHeight = 39,
    this.hintList,
    this.selectedColor = CretaColor.primary,
    this.borderRadius,
    this.alwaysShowBorder = false,
    this.allTextColor,
    this.maxVisibleRowCount = 8,
    this.pulldownIcon = Icons.keyboard_arrow_down,
    this.isActive = true,
  });

  @override
  State<CretaDropDownButton> createState() => _CretaDropDownButtonState();
}

class _CretaDropDownButtonState extends State<CretaDropDownButton> {
  final GlobalKey dropDownButtonKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool dropDownButtonOpened = false;
  double? fontSize;
  double iconSize = 22;
  String allText = '';
  int _itemIndex = 0;

  @override
  void initState() {
    widget.textStyle ??= CretaFont.buttonLarge.copyWith(fontWeight: CretaFont.medium);
    fontSize ??= widget.textStyle!.fontSize;
    iconSize = widget.iconSize ?? iconSize;
    if (widget.dropDownMenuItemList.isNotEmpty) {
      allText = widget.dropDownMenuItemList[0].caption;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String displayString = getSelectedString();
    return ElevatedButton(
      key: dropDownButtonKey,
      style: _buttonStyle(allText != displayString, false),
      onPressed: widget.isActive
          ? () {
              logger.finest('Main button pressed');
              setState(() {
                showMenu(
                    context: context,
                    globalKey: dropDownButtonKey,
                    popupMenu: widget.dropDownMenuItemList,
                    hintList: widget.hintList,
                    initFunc: () {
                      dropDownButtonOpened = true;
                    }).then((value) {
                  logger.finest('팝업메뉴 닫기');
                  setState(() {
                    dropDownButtonOpened = false;
                  });
                });
                dropDownButtonOpened = !dropDownButtonOpened;
              });
            }
          : null,
      child: SizedBox(
        //     width: widget.width,
        height: widget.height,
        child: Row(
          mainAxisAlignment: widget.align,
          children: [
            Text(
              displayString,
              style: widget.textStyle?.copyWith(
                color: widget.allTextColor ??
                    (allText == displayString ? CretaColor.text[700] : widget.selectedColor),
              ),
              overflow: TextOverflow.fade,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                color: widget.allTextColor ??
                    (allText == displayString ? CretaColor.text[700] : widget.selectedColor),
                widget.pulldownIcon, //Icons.keyboard_arrow_down,
                size: iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getSelectedString() {
    for (var ele in widget.dropDownMenuItemList) {
      if (ele.selected == true) {
        return ele.caption;
      }
    }
    return allText;
  }

  ButtonStyle _buttonStyle(bool isSelected, bool isPopup) {
    return ButtonStyle(
      padding: widget.padding != null
          ? WidgetStateProperty.all<EdgeInsetsGeometry>(widget.padding!)
          : null,
      textStyle: WidgetStateProperty.all<TextStyle>(
          CretaFont.buttonLarge.copyWith(fontWeight: CretaFont.medium)),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return CretaColor.text[100]!;
          }
          return Colors.white;
        },
      ),
      elevation: WidgetStateProperty.all<double>(0.0),
      shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (widget.allTextColor != null) {
            return widget.allTextColor;
          }
          if (isSelected) {
            return CretaColor.primary;
          }
          if (states.contains(WidgetState.hovered)) {
            return CretaColor.text[500]!;
          }
          return CretaColor.text;
        },
      ),
      backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
      shape: WidgetStateProperty.resolveWith<OutlinedBorder?>(
        (Set<WidgetState> states) {
          return RoundedRectangleBorder(
            side: (!isPopup && widget.alwaysShowBorder)
                ? BorderSide(width: 0.5, color: Colors.grey)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? widget.height / 2),
          );
        },
      ),
    );
  }

  Future<void> showMenu({
    required BuildContext context,
    required GlobalKey globalKey,
    required List<CretaMenuItem> popupMenu,
    List<String>? hintList,
    Function? initFunc,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // Dialog를 제외한 다른 화면 터치 x
      barrierColor: null,
      builder: (BuildContext context) {
        if (initFunc != null) initFunc();

        final RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;

        double x = position.dx;
        double y = position.dy + size.height; // - 1;

        int maxRow = (popupMenu.length > widget.maxVisibleRowCount
            ? widget.maxVisibleRowCount
            : popupMenu.length);
        double itemSpacing = 5;
        double dialogHeight = (widget.itemHeight + itemSpacing) * maxRow + itemSpacing * 2;
        if (y + dialogHeight > StudioVariables.displayHeight) {
          //dialogHeight = StudioVariables.workHeight - y;
          y = y - dialogHeight - widget.height;
          if (y < 0) {
            //y = LayoutConst.topMenuBarHeight + CretaConst.appbarHeight + 5;
            y = 5;
          }
        }

        if (popupMenu.length > 1 && dialogHeight < widget.itemHeight + itemSpacing * 2) {
          dialogHeight = widget.itemHeight + itemSpacing * 2;
        }

        double width = widget.width ?? _getMaxWidth(popupMenu);
        logger.finest('x=$x, width=$width, d:${StudioVariables.displayWidth}');
        double gap = x + width - StudioVariables.displayWidth;
        if (gap > 0) {
          x = x - gap - 20;
        }
        logger.finest('x=$x, width=$width, d:${StudioVariables.displayWidth}');

        return _createDropDownMenu(
          context,
          x,
          y,
          //size.width,
          widget.width ?? _getMaxWidth(popupMenu),
          dialogHeight,
          widget.itemHeight,
          itemSpacing,
          popupMenu,
          hintList,
        );
      },
    );

    return Future.value();
  }

  Widget _createDropDownMenu(
    BuildContext context,
    double x,
    double y,
    double width,
    double height,
    double itemHeight,
    double itemSpacing,
    List<CretaMenuItem> menuItem,
    List<String>? hintList,
  ) {
    _itemIndex = 0;
    return Stack(
      children: [
        Positioned(
          left: x,
          top: y,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: CretaColor.text[300]!),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            padding: EdgeInsets.fromLTRB(0, itemSpacing, 0, itemSpacing),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: itemSpacing, // <-- Spacing between children
                  children: menuItem.map((item) {
                    _itemIndex++;
                    return SizedBox(
                      width: width + 8,
                      height: itemHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          style: _buttonStyle(item.selected, true),
                          onPressed: () {
                            if (item.disabled) return;
                            setState(() {
                              for (var ele in menuItem) {
                                if (ele.selected == true) {
                                  ele.selected = false;
                                }
                              }
                              item.selected = true;
                              item.onPressed?.call();
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              hintList == null || hintList.length < _itemIndex
                                  ? Text(
                                      item.caption,
                                      style: widget.textStyle?.copyWith(
                                        fontFamily: item.fontFamily,
                                        fontWeight: item.fontWeight,
                                        color: item.disabled
                                            ? CretaColor.text[300]!
                                            : widget.allTextColor,
                                      ),
                                      overflow: TextOverflow.fade,
                                    )
                                  : Text.rich(
                                      TextSpan(
                                          text: item.caption,
                                          style: widget.textStyle,
                                          children: [
                                            TextSpan(
                                              text: ' (${hintList[_itemIndex - 1]})',
                                              style: widget.textStyle?.copyWith(
                                                  color: CretaColor.secondary,
                                                  overflow: TextOverflow.fade),
                                            ),
                                          ]),
                                    ),
                              Expanded(child: Container()),
                              item.selected
                                  ? Icon(
                                      Icons.check,
                                      size: iconSize,
                                      color: widget.allTextColor,
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getMaxWidth(List<CretaMenuItem> menuItem) {
    double retval = 0;
    for (var ele in menuItem) {
      int length = ele.caption.length;
      //int bytes = utf8.encode(ele.caption).length;

      // 한글의 수 x 와 영문의 수 y 를 알아내기 위한 방정식
      // bytes = 3x + y
      // length = x + y
      // y = length -x
      // bytes = 3x + (length - x)
      // bytes - length = 2x;
      // x = (bytes -length)/2
      // y =  legnth - (bytes - length)/2  =  (3*legnth - bytes)/2
      // 따라서 문자열 길이는  x*fontSize + y*fontSize*4/5 = ((bytes + length)/4) * fontSize
      //double totalLength = (((bytes + 7 * length)).toDouble() / 10.0) * (fontSize! * 1.1);
      double totalLength = length.toDouble() * (fontSize!);

      if (retval < totalLength) {
        retval = totalLength;
        logger.finest('fontSize=$fontSize, length=$totalLength');
      }
    }
    double margin = 32; // 앞뒤,사이 마진 한글자씩
    return retval + margin + iconSize;
  }

  // ButtonStyle buttonStyle2(CretaMenuItem item) {
  //   return ButtonStyle(
  //     overlayColor: MaterialStateProperty.resolveWith<Color?>(
  //       (Set<MaterialState> states) {
  //         if (states.contains(MaterialState.hovered)) {
  //           return Color.fromARGB(255, 242, 242, 242);
  //         }
  //         return Colors.white;
  //       },
  //     ),
  //     elevation: MaterialStateProperty.all<double>(0.0),
  //     shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
  //     foregroundColor: MaterialStateProperty.resolveWith<Color?>(
  //       (Set<MaterialState> states) {
  //         if (item.selected) {
  //           return Color.fromARGB(255, 0, 122, 255);
  //         } else if (states.contains(MaterialState.hovered)) {
  //           return Color.fromARGB(255, 89, 89, 89);
  //         }
  //         return Color.fromARGB(255, 140, 140, 140);
  //       },
  //     ),
  //     backgroundColor: MaterialStateProperty.resolveWith<Color?>(
  //       (Set<MaterialState> states) {
  //         if (states.contains(MaterialState.hovered)) {
  //           return Color.fromARGB(255, 242, 242, 242);
  //         }
  //         return Colors.white;
  //       },
  //     ),
  //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //       RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(18.0),
  //         side: BorderSide(color: Colors.white),
  //       ),
  //     ),
  //   );
  // }
}
