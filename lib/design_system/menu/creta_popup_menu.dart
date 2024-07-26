// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
// import 'package:hycop/common/util/logger.dart';
import 'package:url_launcher/link.dart';
import 'package:routemaster/routemaster.dart';

class CretaMenuItem {
  final String caption;
  final IconData? iconData;
  final double? iconSize;
  Function? onPressed;
  Function(bool)? onHover;
  List<CretaMenuItem>? subMenu;
  String? referencedAttr;
  bool? isDescending;
  bool selected;
  String? linkUrl;
  final bool isIconText;
  final String fontFamily;
  final FontWeight? fontWeight;
  final bool disabled;
  bool isHover;
  final bool isSub;
  final int index;

  CretaMenuItem({
    required this.caption,
    required this.onPressed,
    this.onHover,
    this.selected = false,
    this.iconData,
    this.iconSize,
    this.linkUrl,
    this.referencedAttr,
    this.isDescending,
    this.isIconText = false,
    this.fontFamily = 'NotoSans',
    this.fontWeight,
    this.disabled = false,
    this.subMenu,
    this.isHover = false,
    this.isSub = false,
    this.index = 0,
  });

  CretaMenuItem.clone(CretaMenuItem src)
      : this(
          caption: src.caption,
          iconData: src.iconData,
          iconSize: src.iconSize,
          onPressed: src.onPressed,
          onHover: src.onHover,
          referencedAttr: src.referencedAttr,
          isDescending: src.isDescending,
          selected: src.selected,
          linkUrl: src.linkUrl,
          isIconText: src.isIconText,
          fontFamily: src.fontFamily,
          fontWeight: src.fontWeight,
          disabled: src.disabled,
          subMenu: src.subMenu,
          isHover: src.isHover,
          index: src.index,
        );

  // bool get isSubHover {
  //   bool retval = false;
  //   if (isSub) return isHover;
  //   if (subMenu == null || subMenu!.isEmpty) return isHover;
  //   subMenu!.map((e) {
  //     retval |= e.isHover;
  //   });
  //   return retval;
  // }
}

class CretaPopupMenu {
  static Widget _createPopupMenu(
    BuildContext context,
    double x,
    double y,
    double width,
    List<CretaMenuItem> menuItem, {
    Alignment textAlign = Alignment.center,
  }) {
    return Stack(
      children: [
        Positioned(
          left: x,
          top: y,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              // shadow
              borderRadius: BorderRadius.circular(16.4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  //offset: Offset(0.0, 20.0),
                  spreadRadius: -10.0,
                  blurRadius: 20.0,
                )
              ],
            ),
            padding: EdgeInsets.all(8),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 4, // <-- Spacing between children
              children: <Widget>[
                ...menuItem.map((item) {
                  if ((item.linkUrl ?? '').isEmpty) {
                    return _elevatedButton(context, item, width, textAlign);
                  } else {
                    return Link(
                      uri: Uri.parse(item.linkUrl ?? ''),
                      builder: (context, function) {
                        return _elevatedButton(context, item, width, textAlign);
                      },
                    );
                  }
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _elevatedButton(
      BuildContext context, CretaMenuItem item, double width, Alignment textAlign) {
    return SizedBox(
      width: width,
      height: 32,
      child: ElevatedButton(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Color.fromARGB(255, 242, 242, 242);
              }
              return Colors.white;
            },
          ),
          alignment: textAlign,
          elevation: WidgetStateProperty.all<double>(0.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
          foregroundColor: item.disabled
              ? WidgetStateProperty.all<Color>(CretaColor.text[300]!)
              : WidgetStateProperty.all<Color>(CretaColor.text[700]!),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.white))),
        ),
        onPressed: () {
          Navigator.pop(context);
          if ((item.linkUrl ?? '').isEmpty) {
            item.onPressed?.call();
          } else {
            Routemaster.of(context).push(item.linkUrl!);
          }
        },
        child: Text(
          item.caption,
          style: item.disabled
              ? CretaFont.buttonMedium.copyWith(color: CretaColor.text[300]!)
              : CretaFont.buttonMedium,
          // TextStyle(
          //   fontSize: 13,
          //   fontWeight: item.fontWeight,
          //   fontFamily: item.fontFamily,
          // ),
        ),
      ),
    );
  }

  static Future<void> showMenu({
    required BuildContext context,
    GlobalKey? globalKey,
    required List<CretaMenuItem> popupMenu,
    double width = 114,
    double xOffset = 0,
    double yOffset = 0,
    Offset? position,
    Alignment textAlign = Alignment.center,
    Function? initFunc,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // Dialog를 제외한 다른 화면 터치 x
      barrierColor: null,
      builder: (BuildContext context) {
        if (initFunc != null) initFunc();

        double x = 0;
        double y = 0;
        if (position == null && globalKey != null) {
          try {
            final RenderBox? renderBox = globalKey.currentContext!.findRenderObject() as RenderBox?;
            if (renderBox == null) {
              return SizedBox.shrink();
            }

            final position = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;

            x = position.dx + size.width - 70;
            y = position.dy + 40;
          } catch (e) {
            return SizedBox.shrink();
          }
        } else {
          x = position!.dx;
          y = position.dy;
        }

        return _createPopupMenu(
          context,
          x + xOffset,
          y + yOffset,
          width,
          popupMenu,
          textAlign: textAlign,
        );
      },
    );

    return Future.value();
  }
}
