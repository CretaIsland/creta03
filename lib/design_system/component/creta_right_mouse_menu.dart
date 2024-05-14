import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../menu/creta_popup_menu.dart';

class CretaRightMouseMenu {
  static Future<void> showMenu({
    required String title,
    required BuildContext context,
    required List<CretaMenuItem> popupMenu,
    List<String>? hintList,
    Function? initFunc,
    required double itemHeight,
    required double x,
    required double y,
    required double width,
    double? height,
    TextStyle? textStyle,
    required double iconSize,
    required bool alwaysShowBorder,
    double? borderRadius,
    Color? allTextColor,
    EdgeInsetsGeometry? padding,
    int maxVisibleRowCount = 8,
  }) async {
    //print('showDialog');
    await showDialog(
      context: context,
      barrierDismissible: true, // Dialog를 제외한 다른 화면 터치 x
      barrierColor: null,
      builder: (BuildContext context) {
        if (initFunc != null) initFunc();
        return CretaRightMouseMenuWidget(
          //key: GlobalObjectKey(title),
          x: x,
          y: y,
          width: width,
          height: height,
          itemHeight: itemHeight,
          itemSpacing: 5,
          menuItem: popupMenu,
          hintList: hintList,
          textStyle: textStyle,
          iconSize: iconSize,
          allTextColor: allTextColor,
          padding: padding,
          borderRadius: borderRadius,
          alwaysShowBorder: alwaysShowBorder,
        );
      },
    );

    return Future.value();
  }

  static void closeMenu(BuildContext context) {
    Navigator.pop(context);
  }
}

class CretaRightMouseMenuWidget extends StatefulWidget {
  final double x;
  final double y;
  final double width;
  final double? height;
  final double itemHeight;
  final double itemSpacing;
  final List<CretaMenuItem> menuItem;
  final List<String>? hintList;
  final TextStyle? textStyle;
  final double iconSize;
  final Color? allTextColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool alwaysShowBorder;

  const CretaRightMouseMenuWidget({
    super.key,
    required this.x,
    required this.y,
    required this.width,
    this.height,
    required this.itemHeight,
    required this.itemSpacing,
    required this.menuItem,
    this.hintList,
    this.textStyle,
    required this.iconSize,
    required this.alwaysShowBorder,
    this.borderRadius,
    this.allTextColor,
    this.padding,
  });

  @override
  State<CretaRightMouseMenuWidget> createState() => CretaRightMouseMenuWidgetState();
}

class CretaRightMouseMenuWidgetState extends State<CretaRightMouseMenuWidget> {
  int _itemIndex = 0;
  final ScrollController _scrollController = ScrollController();
  late double _widgetHeight;
  late double _baseHeight;

  @override
  void initState() {
    super.initState();

    int dividerCount = 0;
    for (var item in widget.menuItem) {
      if (item.caption.isEmpty) {
        dividerCount++;
      }
    }

    if (widget.height == null) {
      _widgetHeight =
          widget.itemHeight * (widget.menuItem.length - dividerCount) + (widget.itemSpacing * 4);
      // divider 가 있어서...
    } else {
      _widgetHeight = widget.height!;
    }
    _baseHeight = _widgetHeight;

    // print(
    //     'initState-----$_widgetHeight-------------$dividerCount----------------${widget.menuItem.length}');
  }

  @override
  Widget build(BuildContext context) {
    //print('build -----------------------------');
    return SizedBox(child: _createDropDownMenu());
  }

  Widget _createDropDownMenu() {
    _itemIndex = 0;
    return Stack(
      children: [
        Positioned(
          left: widget.x,
          top: widget.y,
          child: Container(
            height: _widgetHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: CretaColor.text[300]!),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            padding: EdgeInsets.fromLTRB(0, widget.itemSpacing, 0, widget.itemSpacing),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  //direction: Axis.vertical,
                  //spacing: widget.itemSpacing, // <-- Spacing between children
                  children: widget.menuItem.map((item) {
                    if (item.caption.isEmpty) {
                      return SizedBox(
                        width: widget.width,
                        child: Divider(
                          color: CretaColor.text[200]!,
                          height: 4,
                          indent: 8,
                        ),
                      );
                    }
                    //print('${item.caption} = ${item.isHover}');
                    if (item.isHover && item.subMenu != null) {
                      return Column(
                        children: [
                          _eachItemWidget(item),
                          ..._subMenus(item.subMenu!),
                        ],
                      );
                    }
                    Widget retval = _eachItemWidget(item);
                    _itemIndex++;
                    return retval;
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _subMenus(List<CretaMenuItem> subItems) {
    return subItems.map((e) {
      return _eachItemWidget(e, leftPadding: 20, isSub: true);
    }).toList();
  }

  Widget _eachItemWidget(CretaMenuItem item, {double leftPadding = 0, bool isSub = false}) {
    return SizedBox(
      width: widget.width + 8,
      height: widget.itemHeight,
      child: Padding(
        padding: EdgeInsets.only(left: 4.0 + leftPadding, right: 4.0),
        child: ElevatedButton(
          style: _buttonStyle(item.selected, item.disabled, true, item.isSub),
          onHover: (value) {
            // // 1. hover 여부는 parent 만 체크하고, sub는 체크하지 않는다.
            // // 2. 마우스가 나한테 들어오면, 나는 true 가 되고, 나머지 item 들은 모두 false 가 된다.
            // // 3. 마우스가 나가면, 아무것도 하지 않는다.  즉,  마우스가 들어오면 true 이지만, 나가도 true 이다.
            // // 4. 마우스가 나갔다고 해서 false 가 되는 것이 아니고, 다른 애 한테 들어가면, 그때 false 가 되는 것이다.
            // if (item.isSub == false) {
            //   if (value == true) {
            //     item.isHover = true;
            //     for (var e in widget.menuItem) {
            //       if (e.caption != item.caption) {
            //         e.isHover = false;
            //       }
            //     }

            //     setState(() {
            //       (item.isHover && item.subMenu != null)
            //           ? _widgetHeight = _baseHeight + (widget.itemHeight * item.subMenu!.length)
            //           : _widgetHeight = _baseHeight;
            //     });
            //   } else {
            //     // 5. 단, 마우스가 메뉴를 완전히 완전히 빠져 나가면, 모두 false 가 되어야 한다.
            //     // 마우스가 내 메뉴에서 빠져나갔는데, 나를 제외한 모두가 다 false 라면, 완전히 빠진것이다.
            //   }
            // }

            // //print('${item.caption} isHover = ${item.isHover}');

            // item.onHover?.call(value);
          },
          onPressed: () {
            if (item.subMenu != null) {
              item.isHover = !item.isHover;
              setState(() {
                if (item.subMenu != null) {
                  if (item.isHover) {
                    //_widgetHeight = _baseHeight + (widget.itemHeight * item.subMenu!.length);
                    _widgetHeight += (widget.itemHeight * item.subMenu!.length);
                  } else {
                    if (_widgetHeight > _baseHeight) {
                      _widgetHeight -= (widget.itemHeight * item.subMenu!.length);
                    }
                  }
                }
              });
              return;
            }

            setState(() {
              for (var ele in widget.menuItem) {
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
              widget.hintList == null || widget.hintList!.length <= _itemIndex
                  ? Text(
                      item.caption,
                      style: widget.textStyle?.copyWith(
                        fontFamily: item.fontFamily,
                        fontWeight: item.fontWeight,
                      ),
                      overflow: TextOverflow.fade,
                    )
                  : Text.rich(
                      TextSpan(text: item.caption, style: widget.textStyle, children: [
                        TextSpan(
                          text: ' (${widget.hintList![_itemIndex]})',
                          style: widget.textStyle
                              ?.copyWith(color: CretaColor.secondary, overflow: TextOverflow.fade),
                        ),
                      ]),
                    ),
              Expanded(child: Container()),
              item.selected
                  ? Icon(
                      Icons.check,
                      size: widget.iconSize,
                      color: widget.allTextColor,
                    )
                  : const SizedBox.shrink(),
              if (item.subMenu != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    item.isHover ? Icons.expand_less_outlined : Icons.expand_more_outlined,
                    size: widget.iconSize,
                    color: widget.allTextColor,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(bool isSelected, bool disabled, bool isPopup, bool isSubMenu) {
    return ButtonStyle(
      padding: widget.padding != null
          ? WidgetStateProperty.all<EdgeInsetsGeometry>(widget.padding!)
          : null,
      textStyle: WidgetStateProperty.all<TextStyle>(
          CretaFont.buttonLarge.copyWith(fontWeight: CretaFont.medium)),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return disabled ? Colors.white : CretaColor.text[100]!;
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
            return disabled
                ? CretaColor.text[200]!
                : isSubMenu
                    ? CretaColor.primary
                    : CretaColor.text[600]!;
          }
          return disabled
              ? CretaColor.text[200]!
              : isSubMenu
                  ? CretaColor.primary
                  : CretaColor.text[600]!;
        },
      ),
      backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
      shape: disabled
          ? WidgetStateProperty.resolveWith<OutlinedBorder?>(
              (Set<WidgetState> states) {
                return RoundedRectangleBorder(
                  side: (!isPopup && widget.alwaysShowBorder)
                      ? const BorderSide(width: 0.5, color: Colors.grey)
                      : BorderSide.none,
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? _baseHeight / 2),
                );
              },
            )
          : null,
    );
  }
}
