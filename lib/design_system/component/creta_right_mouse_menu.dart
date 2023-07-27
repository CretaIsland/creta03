import 'package:flutter/material.dart';

import '../creta_color.dart';
import '../creta_font.dart';
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
    required double height,
    TextStyle? textStyle,
    required double iconSize,
    required bool alwaysShowBorder,
    double? borderRadius,
    Color? allTextColor,
    EdgeInsetsGeometry? padding,
    int maxVisibleRowCount = 8,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // Dialog를 제외한 다른 화면 터치 x
      barrierColor: null,
      builder: (BuildContext context) {
        if (initFunc != null) initFunc();
        return CretaRightMouseMenuWidget(
          key: GlobalObjectKey(title),
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
}

class CretaRightMouseMenuWidget extends StatefulWidget {
  final double x;
  final double y;
  final double width;
  final double height;
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
    required this.height,
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

  @override
  Widget build(BuildContext context) {
    return _createDropDownMenu();
  }

  Widget _createDropDownMenu() {
    _itemIndex = 0;
    return Stack(
      children: [
        Positioned(
          left: widget.x,
          top: widget.y,
          child: Container(
            height: widget.height,
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
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: widget.itemSpacing, // <-- Spacing between children
                  children: widget.menuItem.map((item) {
                    if (item.caption.isEmpty) {
                      return SizedBox(
                        width: widget.width,
                        child: Divider(
                          color: CretaColor.text[100]!,
                          height: 4,
                          indent: 8,
                        ),
                      );
                    }
                    _itemIndex++;
                    return SizedBox(
                      width: widget.width + 8,
                      height: widget.itemHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          style: _buttonStyle(item.selected, item.disabled, true),
                          onPressed: () {
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
                              widget.hintList == null || widget.hintList!.length < _itemIndex
                                  ? Text(
                                      item.caption,
                                      style: widget.textStyle?.copyWith(
                                        fontFamily: item.fontFamily,
                                        fontWeight: item.fontWeight,
                                      ),
                                      overflow: TextOverflow.fade,
                                    )
                                  : Text.rich(
                                      TextSpan(
                                          text: item.caption,
                                          style: widget.textStyle,
                                          children: [
                                            TextSpan(
                                              text: ' (${widget.hintList![_itemIndex - 1]})',
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
                                      size: widget.iconSize,
                                      color: widget.allTextColor,
                                    )
                                  : const SizedBox.shrink(),
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

  ButtonStyle _buttonStyle(bool isSelected, bool disabled, bool isPopup) {
    return ButtonStyle(
      padding: widget.padding != null
          ? MaterialStateProperty.all<EdgeInsetsGeometry>(widget.padding!)
          : null,
      textStyle: MaterialStateProperty.all<TextStyle>(
          CretaFont.buttonLarge.copyWith(fontWeight: CretaFont.medium)),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return disabled ? Colors.white : CretaColor.text[100]!;
          }
          return Colors.white;
        },
      ),
      elevation: MaterialStateProperty.all<double>(0.0),
      shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (widget.allTextColor != null) {
            return widget.allTextColor;
          }
          if (isSelected) {
            return CretaColor.primary;
          }
          if (states.contains(MaterialState.hovered)) {
            return disabled ? CretaColor.text[200]! : CretaColor.text[600]!;
          }
          return disabled ? CretaColor.text[200]! : CretaColor.text;
        },
      ),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      shape: disabled
          ? MaterialStateProperty.resolveWith<OutlinedBorder?>(
              (Set<MaterialState> states) {
                return RoundedRectangleBorder(
                  side: (!isPopup && widget.alwaysShowBorder)
                      ? const BorderSide(width: 0.5, color: Colors.grey)
                      : BorderSide.none,
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? widget.height / 2),
                );
              },
            )
          : null,
    );
  }
}
